//
//  TicketDetailsFetcher.swift
//  buyticket
//
//  Created by Elena Jovcevska on 2/11/19.
//  Copyright © 2019 Elena Jovcevska. All rights reserved.
//

import Foundation

struct TicketDetailsFetcher {
    
    static func fetchTicketDetails() -> TicketDetailsModel? {
        if let path = Bundle.main.path(forResource: "tickets",
                                       ofType: "json") {
            if let jsonData = NSData.init(contentsOfFile: path) {
                do {
                    let decoder = JSONDecoder()
                    return try decoder.decode(TicketDetailsModel.self,
                                              from: jsonData as Data)
                } catch let parsingError {
                    print("%@ occured", parsingError)
                    return nil
                }
            }
        }
        return nil
    }
}
