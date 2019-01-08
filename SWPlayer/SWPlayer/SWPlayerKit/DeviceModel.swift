//
//  DeviceModel.swift
//  SWPlayer
//
//  Created by liuhongli on 2019/1/5.
//  Copyright © 2019年 liuhongli. All rights reserved.
//

import UIKit

enum SWScreenEnum {
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
        case "iPhone5,1", "iPhone5,2":                  return "0"
        case "iPhone5,3", "iPhone5,4":                  return "0"
        case "iPhone6,1", "iPhone6,2":                  return "0"
        case "iPhone7,2":                               return "0"
        case "iPhone7,1":                               return "0"
        case "iPhone8,1":                               return "0"
        case "iPhone8,2":                               return "0"
        case "iPhone8,4":                               return "0"
        case "iPhone9,1", "iPhone9,3":                  return "1"
        case "iPhone9,2", "iPhone9,4":                  return "1"
        case "iPhone10,1", "iPhone10,3":                  return "1"
        case "iPhone10,2", "iPhone10,4":                  return "1"
        case "iPhone10,5", "iPhone10,6":                  return "1"
        default:                                        return hardwareMachine
        }
    }
    
    
    
    
    
}
