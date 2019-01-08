//
//  SWMainViewController.swift
//  SWBaseProject
//
//  Created by 刘宏立 on 2018/10/3.
//  Copyright © 2018 lhl. All rights reserved.
//

import UIKit

struct SWMainVCStruct {
    var title: String = ""
    var imgName: String = ""
    var vc: UIViewController!
}

class SWMainViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.addChildViewControllers()
    }
    

    func addChildViewControllers() {
        let first = SWMainVCStruct.init(title: "SWPlayer", imgName: "me", vc: PlayerListViewController())
        let array = [first]
        var arrayM = [UIViewController]()
        for item in array {
            arrayM.append(self.childControllers(params: item))
        }
        self.viewControllers = arrayM
    }
    
    //tabbar_icon_me_highlight
    //tabbar_icon_emotarBear_highlight
    func childControllers(params: SWMainVCStruct) -> UIViewController{
        let vc: UIViewController = params.vc
        vc.title = params.title
        let imgName = "tabbar_icon_\(params.imgName)_normal"
        let imageNameHL = "tabbar_icon_\(params.imgName)_highlight"
        vc.tabBarItem.image = UIImage.init(named: imgName)
        vc.tabBarItem.selectedImage = UIImage.init(named: imageNameHL)?.withRenderingMode(.alwaysOriginal)
        let nav = UINavigationController.init(rootViewController: vc)
        return nav
    }

}
