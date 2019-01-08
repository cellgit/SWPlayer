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
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.isNavigationBarHidden = true
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
        
        self.title = "Normal Player"
        
        setupUI()
    }
    
    
    func setupUI() {
        containerView = PlayerTableView.init(frame: self.view.frame)
        self.view.addSubview(containerView)
        containerView.viewController = self
    }
    
    
}

