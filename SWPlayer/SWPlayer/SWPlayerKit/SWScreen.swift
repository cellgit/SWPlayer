//
//  SWScreen.swift
//  SWPlayer
//
//  Created by liuhongli on 2019/1/10.
//  Copyright © 2019年 lhl. All rights reserved.
//

import Foundation

import UIKit

class SWScreen: NSObject {
    
    static let shared = SWScreen()
    
    /// 屏幕旋转设置
    func direction(to direction: SWScreenDirectionEnum, view: UIView) {
        if direction == .right {
            self.driveScreen(to: .landscapeRight)
            view.frame = UIScreen.main.bounds
        }
        else if direction == .left {
            self.driveScreen(to: .landscapeLeft)
            view.frame = UIScreen.main.bounds
        }
        else if direction == .portrait {
            self.driveScreen(to: .portrait)
            view.frame = UIScreen.main.bounds
        }
    }
    func driveScreen(to direction: UIInterfaceOrientation) {
        UIDevice.current.setValue(direction.rawValue, forKey: "orientation")
    }
}
