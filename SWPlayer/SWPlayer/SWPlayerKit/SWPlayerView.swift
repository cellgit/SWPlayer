//
//  SWPlayerView.swift
//  SWPlayer
//
//  Created by liuhongli on 2018/12/20.
//  Copyright © 2018年 liuhongli. All rights reserved.
//

import UIKit
import AVFoundation

/// 快进或快退的时长绝对值
let FastSeekSeconds: Double = 10

/// 屏幕的方向
enum SWScreenDirectionEnum {
    case right
    case left
    case portrait
}

/// 控件功能枚举
enum SWPlayerControlEnum {
    case previous
    case next
    case dismiss
    case more
    case share
    case add
    case unknown
}

protocol SWPlayerControlDelegate {
    func sw_control_action(_ control: SWPlayerControlEnum)
    func sw_screen_direction_action(direction: SWScreenDirectionEnum)
}

class SWPlayerView: UIView {
    
    private(set) var player = SWPlayer()
    var delegate: SWPlayerControlDelegate!
    
    override class var layerClass: AnyClass {
        get {
            return AVPlayerLayer.self
        }
    }
    
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
            self.playerMaskView.statusDidChanged(status: status)
        }
        self.player.playedDurationDidChangeHandler = { (played, total) in
//            print("------===---===\(played)/\(total)")
            self.playerMaskView.timeSlider.value = Float(played/total)
            self.playerMaskView.currentTimeLabel.text = SWTimer.formatSecondsToString(played)
            self.playerMaskView.totalTimeLabel.text = SWTimer.formatSecondsToString(total)
        }
    }
}

extension SWPlayerView: SWMaskViewDelegate {
    func sw_more_function_action(sender: UIButton) {
        delegate.sw_control_action(.more)
    }
    func sw_next_action(sender: UIButton) {
        delegate.sw_control_action(.next)
    }
    func sw_previous_action(sender: UIButton) {
        delegate.sw_control_action(.previous)
    }
    func sw_share_action(sender: UIButton) {
        delegate.sw_control_action(.share)
    }
    func sw_fast_forward_action() {
        print("快进 10 seconds")
        guard let currentTime = self.player.currentItem?.currentTime().seconds else {
            return
        }
        self.player.seek(to: currentTime + FastSeekSeconds)
    }
    
    func sw_fast_rewind_action() {
        print("快退 10 seconds")
        guard let currentTime = self.player.currentItem?.currentTime().seconds else {
            return
        }
        self.player.seek(to: currentTime + (-FastSeekSeconds))
    }
    
    func sw_dismiss_action() {
        delegate.sw_control_action(.dismiss)
    }
    
    func sw_play_action(isPlaying: Bool, isEnd: Bool) {
        if isEnd == false {
            if isPlaying == false {
                self.player.play()
            }
            else {
                self.player.pause()
            }
        }
        else {
            /// replay
            self.player.seek(to: 0)
            self.player.play()
        }
    }
    
    func sw_player_rotate_action(angle: Double) {
        if angle < 0 {
            if SWScreenDirection == .right {
                delegate.sw_screen_direction_action(direction: .left)
                self.playerMaskView.frame = self.bounds
                UIView.animate(withDuration: 0.3) {
                    self.transform = CGAffineTransform.identity
                        .rotated(by:CGFloat(0))
                    self.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                    self.playerMaskView.frame = self.bounds
                }
            }
            else {
                delegate.sw_screen_direction_action(direction: .portrait)
                self.playerMaskView.frame = self.bounds
                UIView.animate(withDuration: 0.3) {
                    self.transform = CGAffineTransform.identity
                    self.frame = self.verFrame
                    self.playerMaskView.frame = self.bounds
                }
            }
        }
        else {
            delegate.sw_screen_direction_action(direction: .right)
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
