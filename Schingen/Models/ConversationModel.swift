//
//  ConversationModel.swift
//  Schingen
//
//  Created by Ozan Barış Günaydın on 15.11.2021.
//

import Foundation

struct Conversation {
    let id: String
    let name: String
    let otherUserEmail: String
    let latestMessage: LatestMessage
}

struct LatestMessage {
    let date: String
    let text: String
    let isRead: Bool
}
