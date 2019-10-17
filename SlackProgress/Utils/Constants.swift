//
//  Constants.swift
//  SlackProgress
//
//  Created by Salmaan Ahmed on 24/05/2019.
//  Copyright © 2019 Salmaan Ahmed. All rights reserved.
//

import Foundation

struct MessageString {
    static var workFromHome: String {
        get {
            return workFromHomeExcuses[Int.random(in: 0..<workFromHomeExcuses.count)]
        }
    }
    
    
    static var holiday: String {
        get {
            return holidayExcuses[Int.random(in: 0..<holidayExcuses.count)]
        }
    }
    
    
    static var late: String {
        get {
            return lateExcuse[Int.random(in: 0..<lateExcuse.count)]
        }
    }
    
    private static let workFromHomeExcuses = [
        "I will work from home today as an unexpected work found me",
        "I am working from home today, due to some work, I would spend more in the car than working in the office. I will be more productive from home.",
        "I am unwell but I can manage to work from home"
    ]
    
    private static let holidayExcuses = [
        "I am unwell and wont be able to work today, not even from home",
        "I wont be able to come to office today due to some work at home",
        "I have to go for some urgent work, therefore wont be able to attent office today"
    ]
    
    private static let lateExcuse = [
        "I will be little late today",
        "Running late today, will reach office after some time",
        "I will be little late as I have some work on my way to office"
    ]
}
