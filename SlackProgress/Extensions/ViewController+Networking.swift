//
//  ViewController+Networking.swift
//  SlackProgress
//
//  Created by Salmaan Ahmed on 20/05/2019.
//  Copyright © 2019 Salmaan Ahmed. All rights reserved.
//
// This class is used for networking purpose

import Foundation

extension ViewController {
    
    func getStoriesFromCh() -> ChResults? {
        
        // Create URL using URLComponents
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.clubhouse.io"
        components.path = "/api/v2/search/stories"
        components.queryItems = [
            URLQueryItem(name: "token", value: chToken),
            URLQueryItem(name: "query", value: "state:\"In Progress\"owner:salmaanahmed")
        ]
        guard let url = components.url else { return nil }
        
        let request = NSMutableURLRequest(url: url as URL)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        var result: ChResults?
        
        let semaphore = DispatchSemaphore(value: 0)
        URLSession.shared.dataTask(with: request as URLRequest) { (data, _, _) in
            if let data = data {
                result = try? JSONDecoder().decode(ChResults.self, from: data)
            }
            semaphore.signal()
            }.resume()
        _ = semaphore.wait(wallTimeout: .distantFuture)
        return result
    }
    
    func postMessageToSlack(message: Message) -> Bool {
        
        // Create URL using URLComponents
        var components = URLComponents()
        components.scheme = "https"
        components.host = "slack.com"
        components.path = "/api/chat.postMessage"
        guard let url = components.url else { return false }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(slackToken)", forHTTPHeaderField: "Authorization")
        
        let json = try? JSONEncoder().encode(message)
        var result = false
        
        let semaphore = DispatchSemaphore(value: 0)
        URLSession.shared.uploadTask(with: request, from: json) { data, response, error in
            if let _ = data {
                result = true
            }
            semaphore.signal()
            }.resume()
        _ = semaphore.wait(wallTimeout: .distantFuture)
        return result
    }
}
