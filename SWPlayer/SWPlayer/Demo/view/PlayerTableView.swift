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
        let data4 = EpisodeItemStruct.init(url: ApiEpisodeUrl4, mode: .live, title: "喜欢你-邓紫棋")
        let data5 = EpisodeItemStruct.init(url: ApiEpisodeUrl5, mode: .live, title: "喜欢你-邓紫棋")
        let data6 = EpisodeItemStruct.init(url: ApiEpisodeUrl6, mode: .live, title: "喜欢你-邓紫棋")
        let data7 = EpisodeItemStruct.init(url: ApiEpisodeUrl7, mode: .live, title: "喜欢你-邓紫棋")
        let data8 = EpisodeItemStruct.init(url: ApiEpisodeUrl8, mode: .live, title: "喜欢你-邓紫棋")
        let data9 = EpisodeItemStruct.init(url: ApiEpisodeUrl9, mode: .live, title: "喜欢你-邓紫棋")
        let data10 = EpisodeItemStruct.init(url: ApiEpisodeUrl10, mode: .live, title: "喜欢你-邓紫棋")
        let data11 = EpisodeItemStruct.init(url: ApiEpisodeUrl11, mode: .live, title: "喜欢你-邓紫棋")
        let data12 = EpisodeItemStruct.init(url: ApiEpisodeUrl12, mode: .live, title: "喜欢你-邓紫棋")
        let data13 = EpisodeItemStruct.init(url: ApiEpisodeUrl13, mode: .live, title: "喜欢你-邓紫棋")
        let data14 = EpisodeItemStruct.init(url: ApiEpisodeUrl14, mode: .live, title: "喜欢你-邓紫棋")
        let data15 = EpisodeItemStruct.init(url: ApiEpisodeUrl15, mode: .live, title: "喜欢你-邓紫棋")
        let data16 = EpisodeItemStruct.init(url: ApiEpisodeUrl16, mode: .live, title: "喜欢你-邓紫棋")
        let data17 = EpisodeItemStruct.init(url: ApiEpisodeUrl17, mode: .live, title: "喜欢你-邓紫棋")
        let data18 = EpisodeItemStruct.init(url: ApiEpisodeUrl18, mode: .live, title: "喜欢你-邓紫棋")
        let data19 = EpisodeItemStruct.init(url: ApiEpisodeUrl19, mode: .live, title: "喜欢你-邓紫棋")
        let data20 = EpisodeItemStruct.init(url: ApiEpisodeUrl20, mode: .live, title: "喜欢你-邓紫棋")
        let data21 = EpisodeItemStruct.init(url: ApiEpisodeUrl21, mode: .live, title: "喜欢你-邓紫棋")
        let data22 = EpisodeItemStruct.init(url: ApiEpisodeUrl22, mode: .live, title: "喜欢你-邓紫棋")
        let data23 = EpisodeItemStruct.init(url: ApiEpisodeUrl23, mode: .live, title: "喜欢你-邓紫棋")
        let data24 = EpisodeItemStruct.init(url: ApiEpisodeUrl24, mode: .live, title: "喜欢你-邓紫棋")
        let data25 = EpisodeItemStruct.init(url: ApiEpisodeUrl25, mode: .live, title: "喜欢你-邓紫棋")
        let data26 = EpisodeItemStruct.init(url: ApiEpisodeUrl26, mode: .live, title: "喜欢你-邓紫棋")
        let data27 = EpisodeItemStruct.init(url: ApiEpisodeUrl27, mode: .live, title: "喜欢你-邓紫棋")
        let data28 = EpisodeItemStruct.init(url: ApiEpisodeUrl28, mode: .live, title: "喜欢你-邓紫棋")
        let data29 = EpisodeItemStruct.init(url: ApiEpisodeUrl29, mode: .live, title: "喜欢你-邓紫棋")
        let data30 = EpisodeItemStruct.init(url: ApiEpisodeUrl30, mode: .live, title: "喜欢你-邓紫棋")
        let data31 = EpisodeItemStruct.init(url: ApiEpisodeUrl31, mode: .live, title: "喜欢你-邓紫棋")
        let data32 = EpisodeItemStruct.init(url: ApiEpisodeUrl32, mode: .live, title: "喜欢你-邓紫棋")
        let data33 = EpisodeItemStruct.init(url: ApiEpisodeUrl33, mode: .live, title: "喜欢你-邓紫棋")
        let data34 = EpisodeItemStruct.init(url: ApiEpisodeUrl34, mode: .live, title: "喜欢你-邓紫棋")
        let data35 = EpisodeItemStruct.init(url: ApiEpisodeUrl35, mode: .live, title: "喜欢你-邓紫棋")
        let data36 = EpisodeItemStruct.init(url: ApiEpisodeUrl36, mode: .live, title: "喜欢你-邓紫棋")
        let data37 = EpisodeItemStruct.init(url: ApiEpisodeUrl37, mode: .live, title: "喜欢你-邓紫棋")
        let data38 = EpisodeItemStruct.init(url: ApiEpisodeUrl38, mode: .live, title: "喜欢你-邓紫棋")
        let data39 = EpisodeItemStruct.init(url: ApiEpisodeUrl39, mode: .live, title: "喜欢你-邓紫棋")
        let data40 = EpisodeItemStruct.init(url: ApiEpisodeUrl40, mode: .live, title: "喜欢你-邓紫棋")
        let data41 = EpisodeItemStruct.init(url: ApiEpisodeUrl41, mode: .live, title: "喜欢你-邓紫棋")
        let data42 = EpisodeItemStruct.init(url: ApiEpisodeUrl42, mode: .live, title: "喜欢你-邓紫棋")
        let data43 = EpisodeItemStruct.init(url: ApiEpisodeUrl43, mode: .live, title: "喜欢你-邓紫棋")
        let data44 = EpisodeItemStruct.init(url: ApiEpisodeUrl44, mode: .live, title: "喜欢你-邓紫棋")
        let data45 = EpisodeItemStruct.init(url: ApiEpisodeUrl45, mode: .live, title: "喜欢你-邓紫棋")
        let data46 = EpisodeItemStruct.init(url: ApiEpisodeUrl46, mode: .live, title: "喜欢你-邓紫棋")
        let data47 = EpisodeItemStruct.init(url: ApiEpisodeUrl47, mode: .live, title: "喜欢你-邓紫棋")
        let data48 = EpisodeItemStruct.init(url: ApiEpisodeUrl48, mode: .live, title: "喜欢你-邓紫棋")
        let data49 = EpisodeItemStruct.init(url: ApiEpisodeUrl49, mode: .live, title: "喜欢你-邓紫棋")
        let data50 = EpisodeItemStruct.init(url: ApiEpisodeUrl50, mode: .live, title: "喜欢你-邓紫棋")
        let data51 = EpisodeItemStruct.init(url: ApiEpisodeUrl51, mode: .live, title: "喜欢你-邓紫棋")
        let data52 = EpisodeItemStruct.init(url: ApiEpisodeUrl52, mode: .live, title: "喜欢你-邓紫棋")
        let data53 = EpisodeItemStruct.init(url: ApiEpisodeUrl53, mode: .live, title: "喜欢你-邓紫棋")
        let data54 = EpisodeItemStruct.init(url: ApiEpisodeUrl54, mode: .live, title: "喜欢你-邓紫棋")
        let data55 = EpisodeItemStruct.init(url: ApiEpisodeUrl55, mode: .live, title: "喜欢你-邓紫棋")
        let data56 = EpisodeItemStruct.init(url: ApiEpisodeUrl56, mode: .live, title: "喜欢你-邓紫棋")
        let data57 = EpisodeItemStruct.init(url: ApiEpisodeUrl57, mode: .live, title: "喜欢你-邓紫棋")
        let data58 = EpisodeItemStruct.init(url: ApiEpisodeUrl58, mode: .live, title: "喜欢你-邓紫棋")
        let data59 = EpisodeItemStruct.init(url: ApiEpisodeUrl59, mode: .live, title: "喜欢你-邓紫棋")
        let data60 = EpisodeItemStruct.init(url: ApiEpisodeUrl60, mode: .live, title: "喜欢你-邓紫棋")
        let data61 = EpisodeItemStruct.init(url: ApiEpisodeUrl61, mode: .live, title: "喜欢你-邓紫棋")
        let data62 = EpisodeItemStruct.init(url: ApiEpisodeUrl62, mode: .live, title: "喜欢你-邓紫棋")
        let data63 = EpisodeItemStruct.init(url: ApiEpisodeUrl63, mode: .live, title: "喜欢你-邓紫棋")
        let data64 = EpisodeItemStruct.init(url: ApiEpisodeUrl64, mode: .live, title: "喜欢你-邓紫棋")
        let data65 = EpisodeItemStruct.init(url: ApiEpisodeUrl65, mode: .live, title: "喜欢你-邓紫棋")
        let data66 = EpisodeItemStruct.init(url: ApiEpisodeUrl66, mode: .live, title: "喜欢你-邓紫棋")
        let data67 = EpisodeItemStruct.init(url: ApiEpisodeUrl67, mode: .live, title: "喜欢你-邓紫棋")
        let data68 = EpisodeItemStruct.init(url: ApiEpisodeUrl68, mode: .live, title: "喜欢你-邓紫棋")
        let data69 = EpisodeItemStruct.init(url: ApiEpisodeUrl69, mode: .live, title: "喜欢你-邓紫棋")
        let data70 = EpisodeItemStruct.init(url: ApiEpisodeUrl70, mode: .live, title: "喜欢你-邓紫棋")
        let data71 = EpisodeItemStruct.init(url: ApiEpisodeUrl71, mode: .live, title: "喜欢你-邓紫棋")
        let data72 = EpisodeItemStruct.init(url: ApiEpisodeUrl72, mode: .live, title: "喜欢你-邓紫棋")
        let data73 = EpisodeItemStruct.init(url: ApiEpisodeUrl73, mode: .live, title: "喜欢你-邓紫棋")
        let data74 = EpisodeItemStruct.init(url: ApiEpisodeUrl74, mode: .live, title: "喜欢你-邓紫棋")
        let data75 = EpisodeItemStruct.init(url: ApiEpisodeUrl75, mode: .live, title: "喜欢你-邓紫棋")
        let data76 = EpisodeItemStruct.init(url: ApiEpisodeUrl76, mode: .live, title: "喜欢你-邓紫棋")
        let data77 = EpisodeItemStruct.init(url: ApiEpisodeUrl77, mode: .live, title: "喜欢你-邓紫棋")
        
        urlArrayM = [data0,
                     data1,
                     data2,
                     data3,
                     data4,
                     data5,
                     data6,
                     data7,
                     data8,
                     data9,
                     data10,
                     data11,
                     data12,
                     data13,
                     data14,
                     data15,
                     data16,
                     data17,
                     data18,
                     data19,
                     data20,
                     data21,
                     data22,
                     data23,
                     data24,
                     data25,
                     data26,
                     data27,
                     data28,
                     data29,
                     data30,
                     data31,
                     data32,
                     data33,
                     data34,
                     data35,
                     data36,
                     data37,
                     data38,
                     data39,
                     data40,
                     data41,
                     data42,
                     data43,
                     data44,
                     data45,
                     data46,
                     data47,
                     data48,
                     data49,
                     data50,
                     data51,
                     data52,
                     data53,
                     data54,
                     data55,
                     data56,
                     data57,
                     data58,
                     data59,
                     data60,
                     data61,
                     data62,
                     data63,
                     data64,
                     data65,
                     data66,
                     data67,
                     data68,
                     data69,
                     data70,
                     data71,
                     data72,
                     data73,
                     data74,
                     data75,
                     data76,
                     data77]
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
