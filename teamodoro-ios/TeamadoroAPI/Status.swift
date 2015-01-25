//
//  Status.swift
//  teamodoro-ios
//
//  Created by Alexander Makarov on 25.01.15.
//  Copyright (c) 2015 Alexander Makarov. All rights reserved.
//

import Foundation

enum Status: String {
    case Running = "running"
    case ShortBreak = "shortBreak"
    case LongBreak = "longBreak"
    case Unknow = "unknow"
    
    func stringValue() -> String {
        switch self {
        case .Running:
            return "Running"
        case .ShortBreak:
            return "Short Break"
        case .LongBreak:
            return "Long Break"
        case .Unknow:
            return "Unknow"
        }
    }
}