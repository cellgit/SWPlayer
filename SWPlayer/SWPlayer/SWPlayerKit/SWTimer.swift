//
//  SWTimer.swift
//  SWPlayer
//
//  Created by liuhongli on 2019/1/10.
//  Copyright © 2019年 lhl. All rights reserved.
//

import Foundation

class SWTimer: NSObject {}

extension SWTimer {
    static func formatSecondsToString(_ time: TimeInterval) -> String {
        let allTime: Int = Int(time)
        var hours = 0
        var minutes = 0
        var seconds = 0
        var hoursText = ""
        var minutesText = ""
        var secondsText = ""
        
        hours = allTime / 3600
        hoursText = hours > 9 ? "\(hours)" : "0\(hours)"
        
        minutes = allTime % 3600 / 60
        minutesText = minutes > 9 ? "\(minutes)" : "0\(minutes)"
        
        seconds = allTime % 3600 % 60
        secondsText = seconds > 9 ? "\(seconds)" : "0\(seconds)"
        
        if seconds > 3600 {
            return "\(hoursText):\(minutesText):\(secondsText)"
        }
        else {
            return "\(minutesText):\(secondsText)"
        }
    }
}

