//
//  GestureRecognizerManager.swift
//  SWPlayer
//
//  Created by liuhongli on 2019/1/22.
//  Copyright © 2019年 lhl. All rights reserved.
//

import UIKit

class GestureRecognizerManager: NSObject {

}


class TapGestureRecognizer: NSObject {
    public func count(tap view: UIView) -> Int {
        /// 双击maskView, double tap to fast forward or fast rewind
        let doubleTapGes = UITapGestureRecognizer.init(target: self, action: #selector(tapAction(sender:)))
        doubleTapGes.numberOfTapsRequired = 2
        doubleTapGes.numberOfTouchesRequired = 1
        view.addGestureRecognizer(doubleTapGes)
        
        /// 单击maskView: sigle tap to displaying or hidden control views
        let sigleTapGes = UITapGestureRecognizer.init(target: self, action: #selector(tapAction(sender:)))
        sigleTapGes.numberOfTapsRequired = 1
        sigleTapGes.numberOfTouchesRequired = 1
        sigleTapGes.delaysTouchesBegan = true
        view.addGestureRecognizer(sigleTapGes)
        
        /// 优先检测双击手势
        sigleTapGes.require(toFail: doubleTapGes)
        
        
        return 0
    }
    @objc func tapAction(sender: UITapGestureRecognizer) {
        let tapsCount = sender.numberOfTapsRequired
        let fingersCount = sender.numberOfTouchesRequired
        let numberOfTouches = sender.numberOfTouches
        print("tapsCount ==== \(tapsCount)")
        print("fingersCount ==== \(fingersCount)")
        print("numberOfTouches ==== \(numberOfTouches)")
    }
    
}
