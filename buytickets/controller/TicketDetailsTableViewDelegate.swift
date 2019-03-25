//
//  TicketDetailsTableViewDelegate.swift
//  buyticket
//
//  Created by Elena Jovcevska on 2/11/19.
//  Copyright © 2019 Elena Jovcevska. All rights reserved.
//

import UIKit

// Custom class that implements the ticket details feature TsableView's methods
class TicketDetailsTableViewDelegate: NSObject, UITableViewDelegate, UITableViewDataSource {
    private weak var tableView: UITableView?
    private var ticketDetails: TicketDetailsModel
    
    init(_ tableView: UITableView,
         _ ticketDetails: TicketDetailsModel) {
        self.ticketDetails = ticketDetails
        self.tableView = tableView
        super.init()
        self.tableView?.delegate = self
        self.tableView?.dataSource = self
        // Setting tableview row height to be automatic, based on the content height
        self.tableView?.rowHeight = UITableView.automaticDimension
        self.tableView?.estimatedRowHeight = 50
        // Register for custom header nib
        let nib = UINib(nibName: "TicketDetailsHeaderView", bundle: nil)
        self.tableView?.register(nib, forHeaderFooterViewReuseIdentifier: "TicketDetailsHeaderView")
    }
    
    //MARK: TableViewDelegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "numberOfTicketsCellIdentifier") as! StepperCell
            cell.titleLabel.text = "Select tickets"
            cell.selectionStyle = .none
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "descriptionTicketCellIdentifier") as! TicketDescriptionCell
        cell.titleLabel.text = ticketDetails.description
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 35
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "TicketDetailsHeaderView") as! TicketDetailsHeaderView
        if section == 0 {
            headerView.titleLabel.text = "SELECT NUMBER OF TICKETS"
        } else {
            headerView.titleLabel.text =  "DESCRIPTION"
        }
        return headerView
    }
}
