//
//  TicketModel.swift
//  buyticket
//
//  Created by Elena Jovcevska on 2/11/19.
//  Copyright © 2019 Elena Jovcevska. All rights reserved.
//

import Foundation

struct TicketDetailsModel: Codable {
    var price: String
    var location: String
    var date: String
    var title: String
    var description: String
    var image: String
}
