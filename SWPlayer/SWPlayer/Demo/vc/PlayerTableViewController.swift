//
//  PlayerTableViewController.swift
//  SWPlayer
//
//  Created by 刘宏立 on 2019/1/6.
//  Copyright © 2019 lhl. All rights reserved.
//

import UIKit


protocol SWPlayerDismissDelegate {
    func sw_player_dismiss_action()
}


class PlayerTableViewController: UIViewController {
    
    var containerView: PlayerTableView!
    var delegate: SWPlayerDismissDelegate!
    
    override var shouldAutorotate: Bool {
        print("NormalPlayerVC.shouldAutorotate")
        return false
    }
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return .portrait
    }
    override var prefersStatusBarHidden: Bool {
        return true
    }
    /// 控制旋转(横竖屏)动画效果
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: nil, completion: {_ in
            UIView.setAnimationsEnabled(true)
        })
        // 传递true旋转时有动画
        UIView.setAnimationsEnabled(true)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.isNavigationBarHidden = true
        isAllowAutoRotate = true
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
        isAllowAutoRotate = false
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.title = "Player"
        
        setupUI()
    }
    
    
    func setupUI() {
        containerView = PlayerTableView.init(frame: self.view.frame)
        self.view.addSubview(containerView)
        containerView.viewController = self
    }
}

