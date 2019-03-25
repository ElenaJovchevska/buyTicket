//
//  SupportChatManagerDelegate.swift
//  buytickets
//
//  Created by Elena Jovcevska on 3/2/19.
//  Copyright © 2019 Elena Jovcevska. All rights reserved.
//

import Foundation
import PusherChatkit

// Protocol updating TicketDetailsViewController for PChatManagerDelegate typing method's updates
protocol ChatManagerTypingDelegate {
    func didChangeTypingState(for content: String)
}

// Custom class implementing the PChatManagerDelegate for the support chat
class SupportChatManagerDelegate: PCChatManagerDelegate {
    private let delegate: ChatManagerTypingDelegate
    private let currentUsername: String
    
    init(_ delegate: ChatManagerTypingDelegate,
         _ currentUsername: String) {
        self.delegate = delegate
        self.currentUsername = currentUsername
    }
    
    func onUserStartedTyping(inRoom room: PCRoom,
                             user: PCUser) {
        if currentUsername != user.id {
            let message = String.init(format:"%@ started typing...", user.name ?? "")
            delegate.didChangeTypingState(for: message)
        }
    }
    
    func onUserStoppedTyping(inRoom room: PCRoom,
                             user: PCUser) {
        if currentUsername != user.name {
            delegate.didChangeTypingState(for: "")
        }
    }
}
