//
//  PlayerListViewController.swift
//  SWPlayer
//
//  Created by 刘宏立 on 2019/1/6.
//  Copyright © 2019 lhl. All rights reserved.
//

import UIKit



class PlayerListViewController: UIViewController {
    
    let KUITableViewCell = "UITableViewCell"
    
    var tableView: UITableView!
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.tabBarController?.tabBar.isHidden = false
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        
        self.title = "SWPlayer"
        
        
        setTable()
    }
    
    func setTable() {
        self.tableView = UITableView.init(frame: self.view.frame)
        self.view.addSubview(self.tableView)
        let arrayM = [KUITableViewCell]
        for str in arrayM {
            self.tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: str)
        }
        tableView.delegate = self
        tableView.dataSource = self
    }
}


extension PlayerListViewController: UITableViewDataSource,UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: KUITableViewCell, for: indexPath)
        cell.textLabel?.text = "Normal Player"
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.row == 0 {
            let vc = PlayerTableViewController()
            vc.delegate = self
            sw_navigation_present_action(vc:vc)
        }
        
//        else if indexPath.row == 1 {
//            let vc = PlayerTableViewController()
//            vc.delegate = self
//            self.navigationController?.present(vc, animated: true, completion: nil)
//        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 16
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
    
    func sw_navigation_present_action(vc: UIViewController) {
        vc.view.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.3)
        let nav = UINavigationController.init(rootViewController: vc)
        nav.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        nav.isNavigationBarHidden = true
        vc.modalTransitionStyle = UIModalTransitionStyle.coverVertical
        self.tabBarController?.tabBar.isHidden = true
        self.present(nav, animated: true, completion: nil)
    }
}


extension PlayerListViewController: SWPlayerDismissDelegate {
    func sw_player_dismiss_action() {
        self.tabBarController?.tabBar.isHidden = false
    }
}
