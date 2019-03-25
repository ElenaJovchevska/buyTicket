//
//  SimpleOneLabelTableViewCell.swift
//  buyticket
//
//  Created by Elena Jovcevska on 2/11/19.
//  Copyright © 2019 Elena Jovcevska. All rights reserved.
//

import UIKit

class TicketDescriptionCell: UITableViewCell {
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.layer.cornerRadius = 8.0
    }

}
