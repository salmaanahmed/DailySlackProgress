//
//  ViewController.swift
//  SlackProgress
//
//  Created by Salmaan Ahmed on 13/05/2019.
//  Copyright © 2019 Salmaan Ahmed. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let weekDays = [2, 3, 4, 5, 6]
    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        requestUserNotifications()
        clearNotifications()
        scheduleNotification()
        registerListeners()
    }
}

//MARK:- Button actions
extension ViewController {
    @IBAction func sendProgressDidTapped(_ sender: Any) {
        sendStatus()
    }
    @IBAction func runningLateDidTapped(_ sender: Any) {
        sendExcuseMessage(excuse: Message(channel: slackBoss, text: MessageString.late))
    }
    
    @IBAction func notComingDidTapped(_ sender: Any) {
        sendExcuseMessage(excuse: Message(channel: slackBoss, text: MessageString.holiday))
    }
}

//MARK:- main methods
extension ViewController {
    func sendExcuseMessage(excuse: Message) {
        DispatchQueue.global(qos: .utility).async {
            
            // Send message to boss and update text view
            let informedBoss = self.sendMessageToBoss(withExcuse: excuse)
            let informedColleagues = self.sendMessageToColleagues(withExcuse: excuse)
            
            var missionStatus: String {
                get {
                    if informedBoss && informedColleagues {
                        return "Mission Accomplished, Bull's Eye 🎯"
                    } else if informedBoss {
                        return "Tough Nut, Success! ⚔️"
                    } else {
                        return "🧨 Abort ... I REPEAT ... Mission Abort 💣"
                    }
                }
            }
            
            let missionResult = """
            Message sent to boss: \(informedBoss)
            Message sent to colleagues: \(informedColleagues)
            
            Remember the sent excuse:
            \(excuse)
            
            Bottom Line: \(missionStatus)
            """
            self.updateTextView(missionResult)
        }
    }
    
    func sendMessageToColleagues(withExcuse excuse: Message) -> Bool {
        var message = excuse
        for slackId in slackColleagues {
            message.channel = slackId
            if self.postMessageToSlack(message: message) {
                print("Success")
            } else {
                print("Couldn't send message")
                return false
            }
        }
        return true
    }
    
    func sendMessageToBoss(withExcuse excuse: Message) -> Bool {
        if self.postMessageToSlack(message: excuse) {
            print("Success")
            return true
        } else {
            print("Couldn't send message")
            return false
        }
    }
    
    func sendStatus() {
        DispatchQueue.global(qos: .utility).async {
            self.updateTextView("Fetching your \"In Progress\" tasks from clubhouse")
            var message = Message(channel: slackChannel, text: "")
            if let chStories = self.getStoriesFromCh() {
                message.text = chStories.getFormattedProgress()
                self.updateTextView("Posting message to slack ;)")
                if self.postMessageToSlack(message: message) {
                    self.updateTextView("Following status has been sent\n\n\(message.text)")
                } else {
                    self.updateTextView("Unable to send status")
                }
            }
        }
    }
    
    func updateTextView(_ text: String) {
        DispatchQueue.main.async {
            self.textView.text = text
        }
    }
}
