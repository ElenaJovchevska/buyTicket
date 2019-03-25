//
//  SupportChatTableViewDelegate.swift
//  buytickets
//
//  Created by Elena Jovcevska on 2/16/19.
//  Copyright © 2019 Elena Jovcevska. All rights reserved.
//

import UIKit
import PusherChatkit

// Custom class that implements the support chat feature TableView's methods
class SupportChatTableViewDelegate: NSObject, UITableViewDelegate, UITableViewDataSource {
    private weak var tableView: UITableView?
    private var messages: [PCMessageInfo] = []
    
    init(_ tableView: UITableView,
         _ messages: [PCMessageInfo]) {
        self.tableView = tableView
        self.messages = messages
        super.init()
        self.tableView?.delegate = self
        self.tableView?.dataSource = self
        self.tableView?.transform = CGAffineTransform(scaleX: 1, y: -1)
        self.tableView?.register(UINib.init(nibName: "SupportChatMessageCell",
                                            bundle: nil),
                                 forCellReuseIdentifier: "supportChatMessageCellIdentifier")
        self.tableView?.rowHeight = UITableView.automaticDimension
        self.tableView?.estimatedRowHeight = 50
    }
    
    func update(_ messages: [PCMessageInfo]) {
        self.messages = messages
    }
    
    //MARK: TableViewDelegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "supportChatMessageCellIdentifier",
                                                 for: indexPath) as! SupportChatMessageCell
        cell.contentView.transform = CGAffineTransform(scaleX: 1, y: -1)
        cell.selectionStyle = .none
        let messageInfo = self.messages[indexPath.row]
        if messageInfo.received {
            cell.titleLabel?.textAlignment = .left
            cell.titleLabel?.text = "\(messageInfo.message.sender.displayName): \(messageInfo.message.text)"
        } else {
            cell.titleLabel?.textAlignment = .right
            cell.titleLabel?.text = "\("You:") \(messageInfo.message.text)"
        }
        return cell
    }
    
    
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView,
                   heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(_ tableView: UITableView,
                   heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }
}
