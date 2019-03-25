//
//  ViewController.swift
//  buyticket
//
//  Created by Elena Jovcevska on 2/11/19.
//  Copyright © 2019 Elena Jovcevska. All rights reserved.
//

import UIKit
import PusherChatkit

// Struct defining whether the current message is received or the send one
struct PCMessageInfo {
    var message: PCMessage
    var received: Bool
}

/// ViewController representing the details of the selected tickets.
class TicketDetailsViewController: AbstractViewController, PCRoomDelegate, ChatManagerTypingDelegate {
    // We are defining two tableviews so we wouldn't need to reload the data constantly
    //IBOutlets
    @IBOutlet weak var supportChatContainerView: UIView!
    @IBOutlet weak var supportChatTableView: UITableView!
    @IBOutlet weak var ticketDetailsTableView: UITableView!
    @IBOutlet weak var typingIndicatorLabel: UILabel!
    @IBOutlet weak var supportChatInput: UITextField!
    @IBOutlet weak var ticketDetailsTopView: TicketDetailsTopView!
    
    // Delegates
    private var supportChatTableViewDelegate: SupportChatTableViewDelegate?
    private var ticketDetailsTableViewDelegate: TicketDetailsTableViewDelegate?
    
    // Model
    private var ticketDetails: TicketDetailsModel!
    
    // Chat vars
    var chatManager: ChatManager!
    var currentUser: PCCurrentUser?
    var chatManagerDelegate: PCChatManagerDelegate?
    var messages: [PCMessageInfo] = []
    var defaultFrame: CGRect!
    var usernameCredential = ""
    
    // Constants
    let chatInstanceLocator = "INSTANCE_LOCATOR_KEY"
    let chatTokenProvider =  "https://us1.pusherplatform.io/services/chatkit_token_provider/v1/TOKEN_PROVIDER_KEY/token"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Load the selected ticket details
        loadTicketDetails()
        
        // Initialize the tableViewDelegates
        setupTableViewDelegateForTicketDetails()
        setupTableViewDelegateForSupportChat()
        
        // Setup ticketDetails header view
        setupTicketDetailsTopView()
        
        //Setup chat manager for the support chat
        setupChatManager()
        
        // Initialize the default frame
        defaultFrame = self.view.frame
        
        //Register for notifications
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    //MARK: Load methods
    func loadTicketDetails() {
        guard let ticketDetails = TicketDetailsFetcher.fetchTicketDetails() else {
            handleTechnicalError("Couldn't load the tickets details")
            return
        }
        self.ticketDetails = ticketDetails
    }
    
    //MARK: Setup methods
    private func setupTicketDetailsTopView() {
        if let topView = ticketDetailsTopView,
            let details = ticketDetails {
            topView.ticketImageView.image = UIImage.init(named: details.image)
            topView.ticketTitleLabel.text = details.location
            topView.ticketDescriptionFirstLabel.text = details.title
            topView.ticketDescriptionSecondLabel.text = details.date
        }
    }
    
    private func setupTableViewDelegateForSupportChat() {
        supportChatTableViewDelegate = SupportChatTableViewDelegate.init(supportChatTableView, messages)
        supportChatTableView.reloadData()
    }
    
    func setupTableViewDelegateForTicketDetails() {
        if let details = ticketDetails {
            ticketDetailsTableViewDelegate = TicketDetailsTableViewDelegate.init(ticketDetailsTableView, details)
            ticketDetailsTableView.reloadData()
        }
    }
    
    func setupChatManager() {
        chatManager = ChatManager(
            instanceLocator: chatInstanceLocator,
            tokenProvider: PCTokenProvider(url: chatTokenProvider),
            userID: usernameCredential
        )
        
        self.chatManagerDelegate = SupportChatManagerDelegate(self, usernameCredential)
        guard let chatManagerDelegate = self.chatManagerDelegate else { return }
        chatManager.connect(delegate: chatManagerDelegate) { [unowned self] currentUser, error in
            guard error == nil else {
                self.handleTechnicalError("Error connecting")
                return
            }
            
            guard let currentUser = currentUser else { return }
            self.currentUser = currentUser
            guard let rooms = self.currentUser?.rooms else { return }
            if rooms.count > 0 {
                self.subscribeUser(to: rooms[0])
            } else {
                currentUser.getJoinableRooms(completionHandler: { (rooms, error) in
                    guard let rooms = rooms else { return }
                    self.joinUser(to: rooms[0])
                })
            }
        }
    }
    
    private func subscribeUser(to room: PCRoom) {
        currentUser?.subscribeToRoom(
            room: room,
            roomDelegate: self,
            messageLimit: 0
        ) { error in
            guard error == nil else {
                self.handleTechnicalError("Error subscribing to room")
                return
            }
        }
    }
    
    private func joinUser(to room: PCRoom) {
        currentUser?.joinRoom(room,
                             completionHandler: { (room, error) in
                                guard error == nil else {
                                    self.handleTechnicalError("Error subscribing to room")
                                    return
                                }
        })
    }
    
    //MARK: IBActions
    @IBAction func didTapSegmentedControl(_ sender: UISegmentedControl) {
        let segment = sender.selectedSegmentIndex
        animateTableView(for: segment)
        if segment == 0 {
            supportChatInput.resignFirstResponder()
        } else {
            supportChatInput.becomeFirstResponder()
        }
    }
    
    // We can use Bitwise operators because there are only two segments.
    private func animateTableView(for segment: Int) {
        ticketDetailsTableView.alpha = CGFloat(segment)
        supportChatContainerView.alpha = CGFloat(segment ^ 1)
        if segment == 0 {
            ticketDetailsTableView.isHidden = false
        } else {
            supportChatContainerView.isHidden = false
        }
        UIView.animate(withDuration: 0.3, animations: {
            self.ticketDetailsTableView.alpha = CGFloat(segment ^ 1)
            self.supportChatContainerView.alpha = CGFloat(segment & 1)
        }) { (finished) in
            if finished == true {
                self.ticketDetailsTableView.isHidden = (segment == 1)
                self.supportChatContainerView.isHidden = (segment == 0)
            }
        }
    }
    
    //MARK: PCRoomDelegate
    func onMessage(_ message: PCMessage) {
        let isReceivedMessage = !(message.sender.id == usernameCredential)
        let messageInfo = PCMessageInfo.init(message: message,
                                             received: isReceivedMessage)
        messages.insert(messageInfo, at: 0)
        DispatchQueue.main.async {
            self.supportChatTableViewDelegate?.update(self.messages)
            self.supportChatTableView.reloadData()
        }
    }
    
    //MARK: ChatManagerTypingDelegate
    func didChangeTypingState(for content: String) {
        DispatchQueue.main.async {
            // UILabel must be updated from main thread
            self.typingIndicatorLabel.text = content
        }
    }
    
    // Keyboard Notification Selectors
    @objc func keyBoardWillShow(notification: NSNotification) {
        moveViewsWithKeyboard(height: -ticketDetailsTopView.frame.size.height)
    }
    
    @objc func keyBoardWillHide(notification: NSNotification) {
        moveViewsWithKeyboard(height: 0)
    }
    
    func moveViewsWithKeyboard(height: CGFloat) {
        self.view.frame = defaultFrame.offsetBy(dx: 0, dy: height)
    }
    
    //MARK: IBActions
    @IBAction func textFieldDidChange(_ sender: Any) {
        guard let currentUser = self.currentUser else {return}
        currentUser.typing(in: currentUser.rooms[0],
                           completionHandler: { error in
                            guard error == nil else {
                                self.handleTechnicalError("Error occured")
                                return
                            }
        })
    }
    
    @IBAction func sendMessageButton(_ sender: Any) {
        guard let currentUser = self.currentUser else {return}
        currentUser.sendMessage(
            roomID: currentUser.rooms.first?.id ?? "",
            text: self.supportChatInput.text!
        ) { messageId, error in
            guard error == nil else {
                self.handleTechnicalError("Error sending message")
                return
            }
            //print("Message sent!")
        }
        self.supportChatInput.text?.removeAll()
    }
}

