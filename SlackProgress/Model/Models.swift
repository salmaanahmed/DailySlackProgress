//
//  Models.swift
//  SlackProgress
//
//  Created by Salmaan Ahmed on 20/05/2019.
//  Copyright © 2019 Salmaan Ahmed. All rights reserved.
//

import Foundation

struct ChResults: Codable {
    let data: [ChResult]?
    let next: String?
    let total: Int?
    
    // Formatting tasks as needed in progress report
    func getFormattedProgress() -> String {
        var text = getDateHeader()
        guard let tickets = data else { return text}
        for ticket in tickets {
            if let title = ticket.name, let id = ticket.id {
                text += "- \(title) `\(id)`\n"
            }
        }
        return text
    }
    
    // Create date heading
    func getDateHeader() -> String {
        let date = Date()
        let format = DateFormatter()
        format.dateFormat = "MMM dd, yyyy"
        let formattedDate = format.string(from: date)
        return "*Progress \(formattedDate)*\n"
    }
}

// ClubHouse object
struct ChResult: Codable {
    let estimate: Int?
    let id: Int?
    let started: Bool?
    let name: String?
}

struct Message: Codable {
    var channel = slackSelf
    var text = ""
    let as_user = true
}

