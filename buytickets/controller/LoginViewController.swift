//
//  LoginViewController.swift
//  buytickets
//
//  Created by Elena Jovcevska on 3/2/19.
//  Copyright © 2019 Elena Jovcevska. All rights reserved.
//

import UIKit

class LoginViewController: AbstractViewController {
    let storageAccess = StorageAccess()
    @IBOutlet weak var usernameTextField: UITextField!
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        usernameTextField.becomeFirstResponder()
    }
    
    //MARK: IBActions
    @IBAction func didTapLogin(_ sender: Any) {
        let validCredentials = storageAccess.getCredentials()
        if let text = usernameTextField.text {
            if validCredentials?.contains(text) == true{
                performSegue(withIdentifier: "loginToTicketDetailsIdentifier",
                             sender: self)
                return
            }
        }
        handleTechnicalError("Wrong username or password")
    }
    
    //MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "loginToTicketDetailsIdentifier" {
            let destinationVC = segue.destination as! TicketDetailsViewController
            destinationVC.usernameCredential = usernameTextField.text ?? ""
        }
    }

}
