//
//  DeviceModel.swift
//  SWPlayer
//
//  Created by liuhongli on 2019/1/5.
//  Copyright © 2019年 liuhongli. All rights reserved.
//

import UIKit

enum SWScreenEnum: Int {
    case normal     /// 普通屏幕:非全面屏,如iPhone6
    case notch      /// 刘海屏幕:全面屏,如iPhoneX
}

public extension UIDevice {
    
    static var hardwareMachine: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        print("identifier====== \(identifier)")
        return identifier
    }
    
    /// 0普通屏幕:非全面屏,如iPhone6
    /// 1刘海屏幕:全面屏,如iPhoneX
    static var modelScreen: String {
        switch hardwareMachine {
        case "i386":                       return "-1"      // 模拟器
        case "x86_64":                     return "-1"      // 模拟器
            
        case "iPhone1,1":                  return "0"       // iPhone
        case "iPhone1,2":                  return "0"       // iPhone 3G
        case "iPhone2,1":                  return "0"       // iPhone 3GS
        case "iPhone3,1":                  return "0"       // iPhone 4
        case "iPhone3,2":                  return "0"       // iPhone 4 GSM Rev A
        case "iPhone3,3":                  return "0"       // iPhone 4 CDMA
        case "iPhone4,1":                  return "0"       // iPhone 4S
        case "iPhone5,1":                  return "0"       // iPhone 5 (GSM)
        case "iPhone5,2":                  return "0"       // iPhone 5 (GSM+CDMA)
        case "iPhone5,3":                  return "0"       // iPhone 5C (GSM)
        case "iPhone5,4":                  return "0"       // iPhone 5C (Global)
        case "iPhone6,1":                  return "0"       // iPhone 5S (GSM)
        case "iPhone6,2":                  return "0"       // iPhone 5S (Global)
        case "iPhone7,1":                  return "0"       // iPhone 6 Plus
        case "iPhone7,2":                  return "0"       // iPhone 6
        case "iPhone8,1":                  return "0"       // iPhone 6s
        case "iPhone8,2":                  return "0"       // iPhone 6s Plus
        case "iPhone8,4":                  return "0"       // iPhone SE (GSM)
        case "iPhone9,1":                  return "0"       // iPhone 7
        case "iPhone9,2":                  return "0"       // iPhone 7 Plus
        case "iPhone9,3":                  return "0"       // iPhone 7
        case "iPhone9,4":                  return "0"       // iPhone 7 Plus
        case "iPhone10,1":                 return "0"       // iPhone 8
        case "iPhone10,2":                 return "0"       // iPhone 8 Plus
        case "iPhone10,4":                 return "0"       // iPhone 8
        case "iPhone10,5":                 return "0"       // iPhone 8 Plus
            
        case "iPhone10,3":                 return "1"       // iPhone X Global
        case "iPhone10,6":                 return "1"       // iPhone X GSM
        case "iPhone11,2":                 return "1"       // iPhone XS
        case "iPhone11,4":                 return "1"       // iPhone XS Max
        case "iPhone11,6":                 return "1"       // iPhone XS Max Global
        case "iPhone11,8":                 return "1"       // iPhone XR
        default:                           return hardwareMachine
        }
    }
}
