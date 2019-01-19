//
//  BaseNavigationController.swift
//  SWPlayer
//
//  Created by liuhongli on 2019/1/16.
//  Copyright © 2019年 lhl. All rights reserved.
//

import UIKit

class BaseNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func preferredStatusBarStyle() -> UIStatusBarStyle {
        let topVC = self.topViewController
        return topVC?.preferredStatusBarStyle ?? .default
    }
    

}
