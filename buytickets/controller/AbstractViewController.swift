//
//  AbstractViewController.swift
//  buytickets
//
//  Created by Elena Jovcevska on 3/2/19.
//  Copyright © 2019 Elena Jovcevska. All rights reserved.
//

import UIKit

class AbstractViewController: UIViewController {

    //MARK: Error Handling
    func handleTechnicalError(_ errorMessage: String) {
        let alert = UIAlertController(title: "Technical error occured",
                                      message: errorMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction.init(title: "OK",
                                           style: .default,
                                           handler: { (action) in
                                            self.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true)
    }

}
