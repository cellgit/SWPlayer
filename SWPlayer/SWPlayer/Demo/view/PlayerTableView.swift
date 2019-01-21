//
//  PlayerTableView.swift
//  SWPlayer
//
//  Created by 刘宏立 on 2019/1/6.
//  Copyright © 2019 lhl. All rights reserved.
//

import UIKit
import AVKit

let kNotchViewHeight: CGFloat = 44  // 刘海区域黑色遮盖视图的高度: Notch View Height + 14 = radius value

class PlayerTableView: UIView {
    let KUITableViewCell = "UITableViewCell"
    var tableView: UITableView!
    var playerView: SWPlayerView!
    var viewController: PlayerTableViewController!
    
    
    var urlArrayM = [EpisodeItemStruct]()
    var idx: Int = 0
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupPlayer()
        setTable()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    func setupPlayer() {
        if UIDevice.modelScreen == "1" {
            let blackTopView = UIView.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: kNotchViewHeight))
            self.addSubview(blackTopView)
            blackTopView.backgroundColor = UIColor.black
            playerView = SWPlayerView.init(frame: CGRect(x: 0, y: kNotchViewHeight, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width * (9/16)))
        }
        else {
            playerView = SWPlayerView.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width * (9/16)))
        }
        playerView.delegate = self
        
        let data0 = EpisodeItemStruct.init(url: ApiEpisodeUrl0, mode: .live, title: "Apple Live Test")
        let data1 = EpisodeItemStruct.init(url: ApiEpisodeUrl1, mode: .live, title: "CCTV 1 Live")
        let data2 = EpisodeItemStruct.init(url: ApiEpisodeUrl2, mode: .live, title: "CCTV 5 Live")
        let data3 = EpisodeItemStruct.init(url: ApiEpisodeUrl3, mode: .live, title: "CCTV 6 Live")
        let data4 = EpisodeItemStruct.init(url: ApiEpisodeUrl4, mode: .normal, title: "喜欢你-邓紫棋")
        
        urlArrayM = [data0,
                     data1,
                     data2,
                     data3,
                     data4]
        let item = urlArrayM[idx]
        EpisodeMode = item.mode
        playerView.playerMaskView.titleLabel.text = item.title
        
        if playerView.player.status == .playing {
            playerView.player.pause()
            playerView.player.stop()
        }
        
        playerView.player.replace(with: URL.init(string: item.url)!)
        
        playerView.player.play()
    }
    
    
    func setTable(){
        let offset_y = playerView.bounds.height
        print("offset_y ===== \(offset_y)")
        if UIDevice.modelScreen == "1" {
            tableView = UITableView.init(frame: CGRect(x: 0, y: offset_y + kNotchViewHeight, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - offset_y), style: .grouped)
        }
        else {
            tableView = UITableView.init(frame: CGRect(x: 0, y: offset_y, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - offset_y), style: .grouped)
        }
        self.addSubview(tableView)
        tableView.showsVerticalScrollIndicator = false
        self.tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 100
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
            tableView.insetsContentViewsToSafeArea = true
        } else {}
        let arrayM = [KUITableViewCell]
        for str in arrayM {
            self.tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: str)
        }
        self.addSubview(playerView)
        tableView.delegate = self
        tableView.dataSource = self
    }
}

extension PlayerTableView: UITableViewDataSource,UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: KUITableViewCell, for: indexPath)
        cell.backgroundColor = .clear
        cell.textLabel?.text = "\(indexPath.section)-\(indexPath.row)"
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 14
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
}

/// 屏幕上控件action
extension PlayerTableView: SWPlayerControlDelegate {
    func sw_control_action(_ control: SWPlayerControlEnum) {
        switch control {
        case .previous:
            self.previousEpisode()
        case .next:
            self.nextEpisode()
        case .dismiss:
            self.dismiss()
        case .share:
            self.share()
        case .add:
            self.add()
        case .more:
            self.more()
        default:
            break
        }
    }
    
    func previousEpisode() {
        changeEpisode(mode: .previous)
    }
    func nextEpisode() {
        changeEpisode(mode: .next)
    }
    func dismiss() {
        self.viewController.dismiss(animated: true) {
            self.playerView.player.pause()
            self.viewController.delegate.sw_player_dismiss_action()
        }
    }
    func share() {}
    func add() {}
    func more() {}
    
    /// 屏幕旋转设置
    func sw_screen_direction_action(direction: SWScreenDirectionEnum) {
        SWScreen.shared.direction(to: direction, view: self)
    }
}

extension PlayerTableView {
    func changeEpisode(mode: OperationModeEnum) {
        playerView.player.pause()
        playerView.player.stop()
        
        var idx = IndexOperation()
        idx.maxIndex = urlArrayM.count - 1
        idx.index = self.idx
        idx.mode = mode
        let episodeIdx = idx.indexOperated
        print("episodeIdx1 == \(idx.indexOperated)")
        self.idx = episodeIdx
        let item = urlArrayM[episodeIdx]
        EpisodeMode = item.mode
        playerView.playerMaskView.titleLabel.text = item.title
        playerView.player.replace(with: URL.init(string: item.url)!)
        playerView.player.play()
    }
}
