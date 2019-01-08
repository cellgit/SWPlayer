//
//  SWPlayerView.swift
//  SWPlayer
//
//  Created by liuhongli on 2018/12/20.
//  Copyright © 2018年 liuhongli. All rights reserved.
//

import UIKit
import AVFoundation

/// 屏幕的方向
enum SWScreenDirectionEnum {
    case right
    case left
    case portrait
}

protocol SWPlayerViewDelegate {
    func sw_dismiss_action()
}
protocol SWScreenDirectionDelegate {
    func sw_screen_direction_action(direction: SWScreenDirectionEnum)
}

class SWPlayerView: UIView {
    
    private(set) var player = SWPlayer()
    var directionDelegate: SWScreenDirectionDelegate!
    
    
    override class var layerClass: AnyClass {
        get {
            return AVPlayerLayer.self
        }
    }
    
    var delegate: SWPlayerViewDelegate!
    var playerMaskView: SWMaskView!
    var playerLayer: AVPlayerLayer!
    /// 竖屏是playerView的frame
    var verFrame: CGRect!
    /// 播放源
    var currentItem: AVPlayerItem?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.black
        player.bind(to: layer as! AVPlayerLayer)
        self.playerMaskView = setupMaskView() as? SWMaskView
        self.addSubview(playerMaskView)
        self.verFrame = frame
        
//        self.player.playedDurationDidChangeHandler = { (played, total) in
//            print("------===---===\(played)/\(total)")
//        }
        
        playingProgress()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupMaskView() -> UIView {
        let maskView = SWMaskView.init(frame: self.bounds)
        maskView.delegate = self
        maskView.sliderDelegate = self
        return maskView
    }
    
    func playingProgress() {
        self.player.statusDidChangeHandler = { status in
            print("status ==== \(status)")
        }
        self.player.playedDurationDidChangeHandler = { (played, total) in
//            print("------===---===\(played)/\(total)")
            self.playerMaskView.timeSlider.value = Float(played/total)
            self.playerMaskView.currentTimeLabel.text = SWPlayer.formatSecondsToString(played)
            self.playerMaskView.totalTimeLabel.text = SWPlayer.formatSecondsToString(total)
        }
    }
}

extension SWPlayerView: SWMaskViewDelegate {
    func sw_fast_forward_action() {
        print("快进 10 seconds")
        let durationSeconds : Double = 10
        guard let currentTime = self.player.currentItem?.currentTime().seconds else {
            return
        }
        self.player.seek(to: currentTime + durationSeconds)
    }
    
    func sw_fast_rewind_action() {
        print("快退 10 seconds")
        let durationSeconds : Double = -10
        guard let currentTime = self.player.currentItem?.currentTime().seconds else {
            return
        }
        self.player.seek(to: currentTime + durationSeconds)
    }
    
    func sw_dismiss_vc_action() {
        delegate.sw_dismiss_action()
    }
    
    func sw_play_action(isPlaying: Bool) {
        if isPlaying == false {
            self.player.play()
        }
        else {
            self.player.pause()
        }
    }
    
    func sw_player_rotate_action(angle: Double) {
        if angle < 0 {
            if SWScreenDirection == .right {
                directionDelegate.sw_screen_direction_action(direction: .left)
                self.playerMaskView.frame = self.bounds
                UIView.animate(withDuration: 0.3) {
                    self.transform = CGAffineTransform.identity
                        .rotated(by:CGFloat(0))
                    self.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                    self.playerMaskView.frame = self.bounds
                }
            }
            else {
                directionDelegate.sw_screen_direction_action(direction: .portrait)
                self.playerMaskView.frame = self.bounds
                UIView.animate(withDuration: 0.3) {
                    self.transform = CGAffineTransform.identity
                    self.frame = self.verFrame
                    self.playerMaskView.frame = self.bounds
                }
            }
        }
        else {
            directionDelegate.sw_screen_direction_action(direction: .right)
            UIView.animate(withDuration: 0.3) {
                self.transform = CGAffineTransform.identity
                    .rotated(by:CGFloat(0))
                self.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                self.playerMaskView.frame = self.bounds
            }
        }
    }
}

extension SWPlayerView: SWPlayerSliderDelegate {
    func sw_player_slider_touch_Began(sender: UISlider) {
        self.player.pause()
        print("SliderTouchBegan== \(sender.value)")
    }

    func sw_player_slider_value_chnaged(sender: UISlider) {
        print("SliderValueChanged== \(sender.value)")
        self.seekToCurrentDuration(sender: sender)
    }

    func sw_player_slider_touch_end(sender: UISlider) {
        print("SliderTouchEnded== \(sender.value)")
        self.player.play()
    }

    func seekToCurrentDuration(sender: UISlider) {
        guard let duration = self.player.currentItem?.duration.seconds else {
            return
        }
        let currentDuration = duration * Double(sender.value)
        if self.playerMaskView.isPlaying == true {
            self.player.seek(to: currentDuration)
        }
        else {
            self.player.seek(to: currentDuration)
        }
    }
}
