//
//  StepperTableViewCell.swift
//  buyticket
//
//  Created by Elena Jovcevska on 2/11/19.
//  Copyright © 2019 Elena Jovcevska. All rights reserved.
//

import UIKit

class StepperCell: UITableViewCell {
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var stepperView: UIStepper!
    @IBOutlet weak var stepperValueLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        stepperView.layer.cornerRadius = 5.0
        containerView.layer.cornerRadius = 8.0
    }
    
    //MARK: IBAction
    @IBAction func didChangeValue(_ sender: UIStepper) {
        stepperValueLabel.text = String.init(format:"%d", Int(sender.value))
    }
}
