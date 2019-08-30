//
//  SWMaskView.swift
//  SWPlayer
//
//  Created by liuhongli on 2018/12/20.
//  Copyright © 2018年 liuhongli. All rights reserved.
//

import UIKit

protocol SWMaskViewDelegate {
    func sw_player_rotate_action(angle: Double)
    func sw_play_action(isPlaying: Bool, isEnd: Bool)
    func sw_dismiss_action()
    func sw_fast_forward_action()
    func sw_fast_rewind_action()
    func sw_more_function_action(sender: UIButton)
    func sw_next_action(sender: UIButton)
    func sw_previous_action(sender: UIButton)
    func sw_share_action(sender: UIButton)
}

protocol SWPlayerSliderDelegate {
    func sw_player_slider_touch_Began(sender: UISlider)
    func sw_player_slider_value_chnaged(sender: UISlider)
    func sw_player_slider_touch_end(sender: UISlider)
}


/// 判断点击区域: position of taped
enum SWTapDirection {
    case left
    case right
}

enum SWTapTimes {
    case zero
    case one
    case two
}

/// 全局记录屏幕方向: global var of screen direction
var SWScreenDirection = SWScreenDirectionEnum.portrait
var kCountDownSeconds = 3

class SWMaskView: UIView {
    
    public var delegate: SWMaskViewDelegate!
    public var sliderDelegate: SWPlayerSliderDelegate!
    
    /// 是否横屏: is landscape
    var isLandscape: Bool = false
//    var isScreenHorizontal: Bool = false
    /// 控件是否在显示状态: is control displaying status
    var isControlDisplaying: Bool = false
    /// 是否在播放状态: is player playing status
    var isPlaying: Bool = true
    
    
    /// 全屏切换按钮: full screen button
    var fullBtn: SWRippleButton!
    /// 播放暂停按钮: play and pause button
//    var playerBtn: UIButton!
    var playerBtn: SWRippleButton!
    /// 前一个: previous episode button
    var previousBtn: SWRippleButton!
    /// 下一个: next episode button
    var nextBtn: SWRippleButton!
    /// dismiss播放控制器: dismiss viewController button
    var dismissBtn: SWRippleButton!
    /// 更多功能按钮: more function button, you need custom the function in the called func
    var moreBtn: SWRippleButton!
    /// 分享按钮: share button: you need custom the function in the called func
    var shareBtn: SWRippleButton!
    /// 进度滑竿: episode progress slider
    open var timeSlider: SWTimeSlider!
    /// load progress view
    open var progressView     = UIProgressView()
    
    /// 显示当前播放的时间label: the label that displaying played time
    var currentTimeLabel: UILabel!
    /// 显示全部的时间label: the label that displaying total time
    var totalTimeLabel: UILabel!
    /// 当前播放是否已结束,播放状态从结束变为播放(播放,重新播放,快退,快进,滑动杆滑动,前一个,后一个),需要设置isEnd: is play ended
    /// title label, displaying the title of episode
    var titleLabel: UILabel!
    var isEnd: Bool = false
    
    var countDownSeconds = kCountDownSeconds
    var timer: Timer!
    ///  times of tap maskView
    var tapTime: SWTapTimes = SWTapTimes.zero
    
    
    let playBtnWidth: CGFloat = 44
    let fullBtnWidth: CGFloat = 44
    
    let dismissBtnWidth: CGFloat = 44
    let previousBtnWidth: CGFloat = 44
    let nextBtnWidth: CGFloat = 44
    let moreBtnWidth: CGFloat = 44
    let shareBtnWidth: CGFloat = 44
    
    
    let clearImg = UIImage.init(named: "")?.withRenderingMode(.alwaysTemplate)
    let fullImg = UIImage.init(named: "fullscreen_24px_outlined.png")?.withRenderingMode(.alwaysTemplate)
    let unfullImg = UIImage.init(named: "fullscreen_exit_24px_outlined.png")?.withRenderingMode(.alwaysTemplate)
    let pauseImg = UIImage.init(named: "pause_24px_outlined.png")?.withRenderingMode(.alwaysTemplate)
    let playImg = UIImage.init(named: "play_arrow_24px_outlined.png")?.withRenderingMode(.alwaysTemplate)
    let fastForwardImg = UIImage.init(named: "fast_forward_24px_outlined.png")?.withRenderingMode(.alwaysTemplate)
    let fastRewindImg = UIImage.init(named: "fast_rewind_24px_outlined.png")?.withRenderingMode(.alwaysTemplate)
    let playlistAddCheckImg = UIImage.init(named: "playlist_add_check_24px_outlined.png")?.withRenderingMode(.alwaysTemplate)
    let playlistAddImg = UIImage.init(named: "playlist_add_24px_outlined.png")?.withRenderingMode(.alwaysTemplate)
    let previousImg = UIImage.init(named: "skip_previous_24px_outlined.png")?.withRenderingMode(.alwaysTemplate)
    let nextImg = UIImage.init(named: "skip_next_24px_outlined.png")?.withRenderingMode(.alwaysTemplate)
    let dismissImg = UIImage.init(named: "expand_more_24px_outlined.png")?.withRenderingMode(.alwaysTemplate)
    let moreImg = UIImage.init(named: "more_vert_24px_outlined.png")?.withRenderingMode(.alwaysTemplate)
    let shareImg = UIImage.init(named: "arrow_upward_24px_outlined.png")?.withRenderingMode(.alwaysTemplate)
    let sliderImg = UIImage.init(named: "player_slider_thumb")?.withRenderingMode(.alwaysTemplate)

    override init(frame: CGRect) {
        super.init(frame: frame)
        
//        self.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.4)
        self.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        
        addNotification()
        setupUI()
        layoutControl()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    func setupUI() {
        /// 双击maskView, double tap to fast forward or fast rewind
        let doubleTapGes = UITapGestureRecognizer.init(target: self, action: #selector(tapAction(sender:)))
        doubleTapGes.numberOfTapsRequired = 2
        doubleTapGes.numberOfTouchesRequired = 1
        self.addGestureRecognizer(doubleTapGes)
        
        /// 单击maskView: sigle tap to displaying or hidden control views
        let sigleTapGes = UITapGestureRecognizer.init(target: self, action: #selector(tapAction(sender:)))
        sigleTapGes.numberOfTapsRequired = 1
        sigleTapGes.numberOfTouchesRequired = 1
        sigleTapGes.delaysTouchesBegan = true
        self.addGestureRecognizer(sigleTapGes)
        
        /// 优先检测双击手势
        sigleTapGes.require(toFail: doubleTapGes)
    }
    
    @objc func tapAction(sender: UITapGestureRecognizer) {
        let tapsCount = sender.numberOfTapsRequired
        let fingersCount = sender.numberOfTouchesRequired
        
        let tapLocation = sender.location(in: self)
        let numberOfTouches = sender.numberOfTouches
        
        print("tapsCount ==== \(tapsCount)")
        print("fingersCount ==== \(fingersCount)")
        
        print("tapLocation ==== \(tapLocation)")
        print("numberOfTouches ==== \(numberOfTouches)")
        let tapDirection = getTapDirection(view: self, isHorizontal: isLandscape, point: tapLocation)
        
        print("tapDirection===== \(tapDirection)")
        
        if tapsCount == 2 {
            self.tapTime = .two
            isControlDisplaying = false
            // 双击快进或快退: double tap to fast forward or fast rewind
            if tapDirection == .right {  //快进: fast forward
                isEnd = false
                self.delegate.sw_fast_forward_action()
            }
            else {//快退: fast rewind
                isEnd = false
                self.delegate.sw_fast_rewind_action()
            }
            
            if timer != nil {
                timer.invalidate()
            }
            createTimer()
        }
        else if tapsCount == 1 {
            self.tapTime = .one
            isControlDisplaying = !isControlDisplaying
            // 单击显示或隐藏maskView上的所有控件: sigle tap to dispalying or hidden the views on maskview
            self.displayControl(isDisplaying: isControlDisplaying, type: EpisodeMode, times: .one)
            if timer != nil {
                timer.invalidate()
            }
            if isControlDisplaying == true {
                createTimer()
            }
        }
    }
}


extension SWMaskView {
    ///通过点所在区域,返回left,right区域,左侧或右侧: judge taped left or right via position
    
    func getTapDirection(view: UIView, isHorizontal: Bool, point: CGPoint) -> SWTapDirection {
        let bounds = view.bounds
        print("viewBounds=== \(bounds)")
        if isHorizontal == false {  // 竖屏: portrait
            //
            if point.x > bounds.width / 2 {
                return SWTapDirection.right
            }
            else {
                return SWTapDirection.left
            }
        }
        else {  // 横屏: landscape
            if point.x > bounds.width / 2 {
                return SWTapDirection.right
            }
            else {
                return SWTapDirection.left
            }
        }
    }
}


/// 交互控件
extension SWMaskView {
    //放大: control_camera_24px_outlined.png
    //放大2: shuffle_24px_outlined.png
    //缩小: games_24px_outlined.png
    
    //全屏: fullscreen_24px_outlined.png
    //退出全屏: fullscreen_exit_24px_outlined.png
    
    //暂停: pause_24px_outlined.png
    //播放: play_arrow_24px_outlined.png
    //快进: fast_forward_24px_outlined.png
    //快退: fast_rewind_24px_outlined.png
    //已加入列表: playlist_add_check_24px_outlined.png
    //列表: playlist_add_24px_outlined.png
    //前一个: skip_previous_24px_outlined.png
    //下一个: skip_next_24px_outlined.png
    //播放完成: play_circle_filled_24px_outlined.png
    //播放完开始下一个: pause_circle_filled_24px_outlined.png
    
    
    func layoutControl() {
        fullBtn = SWRippleButton.init(type: .custom)
        fullBtn.setImage(fullImg, for: .normal)
        fullBtn.setImage(fullImg, for: .selected)
        self.addSubview(fullBtn)
        fullBtn.imageView?.tintColor = .white
        fullBtn.imageEdgeInsets = UIEdgeInsets.init(top: 9, left: 9, bottom: 9, right: 9)
        fullBtn.buttonCornerRadius = Float(fullBtnWidth / 2)
        fullBtn.shadowRippleRadius = Float(fullBtnWidth / 2)
        fullBtn.rippleColor = .clear
        fullBtn.rippleBackgroundColor = UIColor.init(white: 0.7, alpha: 0.4)
        fullBtn.touchUpAnimationTime = 1.0
        fullBtn.addTarget(self, action: #selector(change_screen_action(sender:)), for: .touchUpInside)
        
        playerBtn = SWRippleButton.init()
        playerBtn.setImage(pauseImg, for: .normal)
//        playerBtn.setImage(pauseImg, for: .selected)
        self.addSubview(playerBtn)
        playerBtn.imageView?.tintColor = .white
        playerBtn.buttonCornerRadius = Float(playBtnWidth / 2)
        playerBtn.shadowRippleRadius = Float(playBtnWidth / 2)
        playerBtn.rippleColor = .clear
        playerBtn.rippleBackgroundColor = UIColor.init(white: 0.7, alpha: 0.4)
        playerBtn.touchUpAnimationTime = 1.0
        
        playerBtn.translatesAutoresizingMaskIntoConstraints = false
        self.addConstraint(NSLayoutConstraint.init(item: playerBtn, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint.init(item: playerBtn, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint.init(item: playerBtn, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: 44))
        self.addConstraint(NSLayoutConstraint.init(item: playerBtn, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 44))
        playerBtn.addTarget(self, action: #selector(play_action(sender:)), for: .touchUpInside)
        
        previousBtn = SWRippleButton.init(type: .custom)
        previousBtn.setImage(previousImg, for: .normal)
        previousBtn.setImage(previousImg, for: .selected)
        self.addSubview(previousBtn)
        previousBtn.imageView?.tintColor = .white
        previousBtn.buttonCornerRadius = Float(previousBtnWidth / 2)
        previousBtn.shadowRippleRadius = Float(previousBtnWidth / 2)
        previousBtn.rippleColor = .clear
        previousBtn.rippleBackgroundColor = UIColor.init(white: 0.7, alpha: 0.4)
        previousBtn.touchUpAnimationTime = 1.0
        
        previousBtn.imageEdgeInsets = UIEdgeInsets.init(top: 3, left: 3, bottom: 3, right: 3)
        previousBtn.translatesAutoresizingMaskIntoConstraints = false
        self.addConstraint(NSLayoutConstraint.init(item: previousBtn, attribute: .centerX, relatedBy: .equal, toItem: playerBtn, attribute: .centerX, multiplier: 1, constant: -80))
        self.addConstraint(NSLayoutConstraint.init(item: previousBtn, attribute: .centerY, relatedBy: .equal, toItem: playerBtn, attribute: .centerY, multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint.init(item: previousBtn, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: 44))
        self.addConstraint(NSLayoutConstraint.init(item: previousBtn, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 44))
        previousBtn.addTarget(self, action: #selector(previous_action(sender:)), for: .touchUpInside)
        
        nextBtn = SWRippleButton.init(type: .custom)
        nextBtn.setImage(nextImg, for: .normal)
        nextBtn.setImage(nextImg, for: .selected)
        self.addSubview(nextBtn)
        nextBtn.imageView?.tintColor = .white
        nextBtn.buttonCornerRadius = Float(nextBtnWidth / 2)
        nextBtn.shadowRippleRadius = Float(nextBtnWidth / 2)
        nextBtn.rippleColor = .clear
        nextBtn.rippleBackgroundColor = UIColor.init(white: 0.7, alpha: 0.4)
        nextBtn.touchUpAnimationTime = 1.0
        nextBtn.imageEdgeInsets = UIEdgeInsets.init(top: 3, left: 3, bottom: 3, right: 3)
        nextBtn.translatesAutoresizingMaskIntoConstraints = false
        self.addConstraint(NSLayoutConstraint.init(item: nextBtn, attribute: .centerX, relatedBy: .equal, toItem: playerBtn, attribute: .centerX, multiplier: 1, constant: 80))
        self.addConstraint(NSLayoutConstraint.init(item: nextBtn, attribute: .centerY, relatedBy: .equal, toItem: playerBtn, attribute: .centerY, multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint.init(item: nextBtn, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: 44))
        self.addConstraint(NSLayoutConstraint.init(item: nextBtn, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 44))
        nextBtn.addTarget(self, action: #selector(next_action(sender:)), for: .touchUpInside)
        
        dismissBtn = SWRippleButton.init(type: .custom)
        dismissBtn.setImage(dismissImg, for: .normal)
        dismissBtn.setImage(dismissImg, for: .selected)
        self.addSubview(dismissBtn)
        dismissBtn.imageView?.tintColor = .white
        dismissBtn.buttonCornerRadius = Float(dismissBtnWidth / 2)
        dismissBtn.shadowRippleRadius = Float(dismissBtnWidth / 2)
        dismissBtn.rippleColor = .clear
        dismissBtn.rippleBackgroundColor = UIColor.init(white: 0.7, alpha: 0.4)
        dismissBtn.touchUpAnimationTime = 1.0
        dismissBtn.imageEdgeInsets = UIEdgeInsets.init(top: 5, left: 5, bottom: 5, right: 5)
        dismissBtn.translatesAutoresizingMaskIntoConstraints = false
        self.addConstraint(NSLayoutConstraint.init(item: dismissBtn, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: 5))
        self.addConstraint(NSLayoutConstraint.init(item: dismissBtn, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 5))
        self.addConstraint(NSLayoutConstraint.init(item: dismissBtn, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: 44))
        self.addConstraint(NSLayoutConstraint.init(item: dismissBtn, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 44))
        dismissBtn.addTarget(self, action: #selector(dismiss_action(sender:)), for: .touchUpInside)
        
        moreBtn = SWRippleButton.init(type: .custom)
        moreBtn.setImage(moreImg, for: .normal)
        moreBtn.setImage(moreImg, for: .selected)
        self.addSubview(moreBtn)
        moreBtn.imageView?.tintColor = .white
        moreBtn.buttonCornerRadius = Float(moreBtnWidth / 2)
        moreBtn.shadowRippleRadius = Float(moreBtnWidth / 2)
        moreBtn.rippleColor = .clear
        moreBtn.rippleBackgroundColor = UIColor.init(white: 0.7, alpha: 0.4)
        moreBtn.touchUpAnimationTime = 1.0
        moreBtn.imageEdgeInsets = UIEdgeInsets.init(top: 9, left: 9, bottom: 9, right: 9)
        
        moreBtn.addTarget(self, action: #selector(more_action(sender:)), for: .touchUpInside)
        
        shareBtn = SWRippleButton.init(type: .custom)
        shareBtn.setImage(shareImg, for: .normal)
        shareBtn.setImage(shareImg, for: .selected)
        self.addSubview(shareBtn)
        shareBtn.imageView?.tintColor = .white
        shareBtn.buttonCornerRadius = Float(shareBtnWidth / 2)
        shareBtn.shadowRippleRadius = Float(shareBtnWidth / 2)
        shareBtn.rippleColor = .clear
        shareBtn.rippleBackgroundColor = UIColor.init(white: 0.7, alpha: 0.4)
        shareBtn.touchUpAnimationTime = 1.0
        shareBtn.imageEdgeInsets = UIEdgeInsets.init(top: 9, left: 9, bottom: 9, right: 9)
        shareBtn.translatesAutoresizingMaskIntoConstraints = false
        self.addConstraint(NSLayoutConstraint.init(item: shareBtn, attribute: .right, relatedBy: .equal, toItem: moreBtn, attribute: .left, multiplier: 1, constant: -5))
        self.addConstraint(NSLayoutConstraint.init(item: shareBtn, attribute: .centerY, relatedBy: .equal, toItem: moreBtn, attribute: .centerY, multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint.init(item: shareBtn, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: 44))
        self.addConstraint(NSLayoutConstraint.init(item: shareBtn, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 44))
        shareBtn.addTarget(self, action: #selector(share_action(sender:)), for: .touchUpInside)
        
        timeSlider = SWTimeSlider.init()
        self.addSubview(timeSlider)
        timeSlider.maximumValue = 1.0
        timeSlider.minimumValue = 0.0
        timeSlider.value = 0.0
        timeSlider.setThumbImage(sliderImg, for: .normal)
        timeSlider.minimumTrackTintColor = UIColor.red
        timeSlider.tintColor = UIColor.red
        
        timeSlider.addTarget(self, action: #selector(progressSliderTouchBegan(sender:)),
                             for: UIControl.Event.touchDown)
        timeSlider.addTarget(self, action: #selector(progressSliderValueChanged(sender:)),
                             for: UIControl.Event.valueChanged)
        timeSlider.addTarget(self, action: #selector(progressSliderTouchEnded(sender:)),
                             for: [UIControl.Event.touchUpInside,UIControl.Event.touchCancel, UIControl.Event.touchUpOutside])
        
        currentTimeLabel = UILabel.init()
        self.addSubview(currentTimeLabel)
        currentTimeLabel.textColor = UIColor.white
        currentTimeLabel.font = UIFont.systemFont(ofSize: 10)
        currentTimeLabel.text = "--:--"
        currentTimeLabel.textAlignment = .right
        
        totalTimeLabel = UILabel.init()
        self.addSubview(totalTimeLabel)
        totalTimeLabel.textColor = UIColor.white
        totalTimeLabel.font = UIFont.systemFont(ofSize: 10)
        totalTimeLabel.text = "--:--"
        totalTimeLabel.textAlignment = .left
        
        titleLabel = UILabel.init()
        self.addSubview(titleLabel)
        titleLabel.textColor = UIColor.white
        titleLabel.font = UIFont.systemFont(ofSize: 15)
        titleLabel.text = "Episode Title BunnyAuto Application is Greate"
        titleLabel.textAlignment = .left
        
        
        layoutControlViews()
        layoutTimeSlider()
        layoutTimeLabel()
        layoutTitleLabel()
        
        /// 初始化隐藏控件: initial hidden the control views
        displayControl(isDisplaying: isControlDisplaying, type: EpisodeMode, times: .zero)
        
        if isControlDisplaying == true {
            createTimer()
        }
    }
    
    func layoutControlViews() {
        if fullBtn != nil {
            for const in self.constraints {
                UIView.animate(withDuration: 0.3) {
                    if const.firstItem as? UIButton == self.fullBtn {
                        self.removeConstraint(const)
                    }
                    self.layoutIfNeeded()
                }
            }
        }
        
        if moreBtn != nil {
            for const in self.constraints {
                UIView.animate(withDuration: 0.3) {
                    if const.firstItem as? UIButton == self.moreBtn {
                        self.removeConstraint(const)
                    }
                    self.layoutIfNeeded()
                }
            }
        }
        
        
        // fullBtn: 关闭系统的自定义视图布局
        fullBtn.translatesAutoresizingMaskIntoConstraints = false
        
        if isLandscape == true && UIDevice.modelScreen == "1"{
            
            /// 横平时根据是否是全面屏进行控件布局: layout views when landscape
            //fullBtn layout
            self.addConstraint(NSLayoutConstraint.init(item: fullBtn, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1, constant: -70))
            self.addConstraint(NSLayoutConstraint.init(item: fullBtn, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: -10))
            self.addConstraint(NSLayoutConstraint.init(item: fullBtn, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: 44))
            self.addConstraint(NSLayoutConstraint.init(item: fullBtn, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 44))
        }
        else {
            //fullBtn layout
            self.addConstraint(NSLayoutConstraint.init(item: fullBtn, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1, constant: -10))
            self.addConstraint(NSLayoutConstraint.init(item: fullBtn, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: -10))
            self.addConstraint(NSLayoutConstraint.init(item: fullBtn, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: 44))
            self.addConstraint(NSLayoutConstraint.init(item: fullBtn, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 44))
        }
        
        
        moreBtn.translatesAutoresizingMaskIntoConstraints = false
        if isLandscape == true && UIDevice.modelScreen == "1" {
            //moreBtn layout
            self.addConstraint(NSLayoutConstraint.init(item: moreBtn, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1, constant: -70))
            self.addConstraint(NSLayoutConstraint.init(item: moreBtn, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 5))
            self.addConstraint(NSLayoutConstraint.init(item: moreBtn, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: 44))
            self.addConstraint(NSLayoutConstraint.init(item: moreBtn, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 44))
        }
        else {
            //moreBtn layout
            self.addConstraint(NSLayoutConstraint.init(item: moreBtn, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1, constant: 0))
            self.addConstraint(NSLayoutConstraint.init(item: moreBtn, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 5))
            self.addConstraint(NSLayoutConstraint.init(item: moreBtn, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: 44))
            self.addConstraint(NSLayoutConstraint.init(item: moreBtn, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 44))
        }
    }
    
    func layoutTimeLabel() {
        if currentTimeLabel != nil {
            for const in self.constraints {
                UIView.animate(withDuration: 0.3) {
                    if const.firstItem as? UILabel == self.currentTimeLabel {
                        self.removeConstraint(const)
                    }
                    self.layoutIfNeeded()
                }
            }
        }
        
        if totalTimeLabel != nil {
            for const in self.constraints {
                UIView.animate(withDuration: 0.3) {
                    if const.firstItem as? UILabel == self.totalTimeLabel {
                        self.removeConstraint(const)
                    }
                    self.layoutIfNeeded()
                }
            }
        }
        
        currentTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        let height = NSLayoutConstraint.init(item: currentTimeLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 30)
        if isLandscape == true && UIDevice.modelScreen == "1" {
            let left = NSLayoutConstraint.init(item: currentTimeLabel, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: 20)
            let right = NSLayoutConstraint.init(item: currentTimeLabel, attribute: .right, relatedBy: .equal, toItem: timeSlider, attribute: .left, multiplier: 1, constant: -20)
            let center_Y = NSLayoutConstraint.init(item: currentTimeLabel, attribute: .centerY, relatedBy: .equal, toItem: fullBtn, attribute: .centerY, multiplier: 1, constant: 0)
            let constraints = [height, left, right, center_Y]
            self.addConstraints(constraints)
        }
        else {
            let left = NSLayoutConstraint.init(item: currentTimeLabel, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: 20)
            let center_Y = NSLayoutConstraint.init(item: currentTimeLabel, attribute: .centerY, relatedBy: .equal, toItem: fullBtn, attribute: .centerY, multiplier: 1, constant: 0)
            let constraints = [height, left, center_Y]
            self.addConstraints(constraints)
        }
        
        totalTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        let totalheight = NSLayoutConstraint.init(item: totalTimeLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 30)
        if isLandscape == true && UIDevice.modelScreen == "1" {
            if UIDevice.modelScreen == "1" {
                let left = NSLayoutConstraint.init(item: totalTimeLabel, attribute: .left, relatedBy: .equal, toItem: timeSlider, attribute: .right, multiplier: 1, constant: 20)
                let right = NSLayoutConstraint.init(item: totalTimeLabel, attribute: .right, relatedBy: .equal, toItem: fullBtn, attribute: .left, multiplier: 1, constant: -10)
                let center_Y = NSLayoutConstraint.init(item: totalTimeLabel, attribute: .centerY, relatedBy: .equal, toItem: fullBtn, attribute: .centerY, multiplier: 1, constant: 0)
                let constraints = [totalheight, left, right, center_Y]
                self.addConstraints(constraints)
            }
            else {
                let left = NSLayoutConstraint.init(item: totalTimeLabel, attribute: .left, relatedBy: .equal, toItem: timeSlider, attribute: .right, multiplier: 1, constant: 20)
                let right = NSLayoutConstraint.init(item: totalTimeLabel, attribute: .right, relatedBy: .equal, toItem: fullBtn, attribute: .left, multiplier: 1, constant: -10)
                let center_Y = NSLayoutConstraint.init(item: totalTimeLabel, attribute: .centerY, relatedBy: .equal, toItem: fullBtn, attribute: .centerY, multiplier: 1, constant: 0)
                let constraints = [totalheight, left, right, center_Y]
                self.addConstraints(constraints)
            }
        }
        else {
            let right = NSLayoutConstraint.init(item: totalTimeLabel, attribute: .right, relatedBy: .equal, toItem: fullBtn, attribute: .left, multiplier: 1, constant: -10)
            let center_Y = NSLayoutConstraint.init(item: totalTimeLabel, attribute: .centerY, relatedBy: .equal, toItem: fullBtn, attribute: .centerY, multiplier: 1, constant: 0)
            let constraints = [totalheight, right, center_Y]
            self.addConstraints(constraints)
        }
    }
    
    func layoutTitleLabel() {
        if titleLabel != nil {
            for const in self.constraints {
                UIView.animate(withDuration: 0.3) {
                    if const.firstItem as? UILabel == self.titleLabel {
                        self.removeConstraint(const)
                    }
                    self.layoutIfNeeded()
                }
            }
        }
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        let height = NSLayoutConstraint.init(item: titleLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 30)
        if isLandscape == true && UIDevice.modelScreen == "1" {
            let left = NSLayoutConstraint.init(item: titleLabel, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: 80)
            let right = NSLayoutConstraint.init(item: titleLabel, attribute: .right, relatedBy: .equal, toItem: shareBtn, attribute: .left, multiplier: 1, constant: -20)
            let center_Y = NSLayoutConstraint.init(item: titleLabel, attribute: .centerY, relatedBy: .equal, toItem: shareBtn, attribute: .centerY, multiplier: 1, constant: 0)
            let constraints = [height, left, right, center_Y]
            self.addConstraints(constraints)
        }
        else {
            let left = NSLayoutConstraint.init(item: titleLabel, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: 20)
            let right = NSLayoutConstraint.init(item: titleLabel, attribute: .right, relatedBy: .equal, toItem: shareBtn, attribute: .left, multiplier: 1, constant: -20)
            let center_Y = NSLayoutConstraint.init(item: titleLabel, attribute: .centerY, relatedBy: .equal, toItem: dismissBtn, attribute: .centerY, multiplier: 1, constant: 0)
            let constraints = [height, left, right, center_Y]
            self.addConstraints(constraints)
        }
    }
    
    func layoutTimeSlider() {
        if timeSlider != nil {
            for const in self.constraints {
                UIView.animate(withDuration: 0.3) {
                    if const.firstItem as? SWTimeSlider == self.timeSlider {
                        self.removeConstraint(const)
                    }
                    self.layoutIfNeeded()
                }
            }
            timeSlider.translatesAutoresizingMaskIntoConstraints = false
            let height = NSLayoutConstraint.init(item: timeSlider, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 30)
            if isLandscape == true {
                if UIDevice.modelScreen == "1" {
                    /// TODO: 需要区分是否是全面屏
                    let left = NSLayoutConstraint.init(item: timeSlider, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: 130)
                    let right = NSLayoutConstraint.init(item: timeSlider, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1, constant: -180)
                    let bottom = NSLayoutConstraint.init(item: timeSlider, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: -16)
                    let constraints = [height, left, right, bottom]
                    self.addConstraints(constraints)
                }
                else {
                    /// TODO: 需要区分是否是全面屏
                    let left = NSLayoutConstraint.init(item: timeSlider, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: 70)
                    let right = NSLayoutConstraint.init(item: timeSlider, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1, constant: -120)
                    let bottom = NSLayoutConstraint.init(item: timeSlider, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: -16)
                    let constraints = [height, left, right, bottom]
                    self.addConstraints(constraints)
                }
            }
            else {
                let left = NSLayoutConstraint.init(item: timeSlider, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: 0)
                let right = NSLayoutConstraint.init(item: timeSlider, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1, constant: 0)
                let bottom = NSLayoutConstraint.init(item: timeSlider, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 14)
                let constraints = [height, left, right, bottom]
                self.addConstraints(constraints)
                
                /// 另一种布局方式
//                timeSlider.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0).isActive = true
//                timeSlider.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0).isActive = true
//                timeSlider.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
//                timeSlider.heightAnchor.constraint(equalToConstant: 30).isActive = true
            }
        }
    }
    
    @objc func change_screen_action(sender: UIButton) {
        self.countDownSeconds = kCountDownSeconds
        self.isLandscape = !self.isLandscape
        if self.isLandscape == true {
            SWScreenDirection = SWScreenDirectionEnum.left
            delegate.sw_player_rotate_action(angle: (Double.pi/2))
            screenControlSettings(angle: (Double.pi/2))
        }
        else {
            SWScreenDirection = SWScreenDirectionEnum.portrait
            delegate.sw_player_rotate_action(angle: -(Double.pi/2))
            screenControlSettings(angle: -(Double.pi/2))
        }
        layoutControlViews()
        layoutTimeSlider()
        layoutTimeLabel()
        layoutTitleLabel()
    }
    
    @objc func play_action(sender: UIButton) {
        if self.isEnd == true {
            delegate.sw_play_action(isPlaying: self.isPlaying, isEnd: self.isEnd)
            isEnd = false
        }
        else {
            delegate.sw_play_action(isPlaying: self.isPlaying, isEnd: self.isEnd)
            isPlaying = !isPlaying
            if isPlaying == true {
                self.playerBtn.setImage(pauseImg, for: .normal)
            }
            else {
                self.playerBtn.setImage(playImg, for: .normal)
            }
        }
    }
    
    @objc func previous_action(sender: UIButton) {
        print("前一个")
        self.countDownSeconds = kCountDownSeconds
        isEnd = false
        delegate.sw_previous_action(sender: sender)
        self.countDownSeconds = kCountDownSeconds
    }
    @objc func next_action(sender: UIButton) {
        print("下一个")
        isEnd = false
        delegate.sw_next_action(sender: sender)
        self.countDownSeconds = kCountDownSeconds
    }
    @objc func dismiss_action(sender: UIButton) {
        print("dismiss控制器")
        delegate.sw_dismiss_action()
        if self.timer != nil {
            self.timer.invalidate()
        }
    }
    @objc func more_action(sender: UIButton) {
        print("more function")
        delegate.sw_more_function_action(sender: sender)
    }
    @objc func share_action(sender: UIButton) {
        print("share function")
        delegate.sw_share_action(sender: sender)
    }

    @objc func progressSliderTouchBegan(sender: UISlider) {
        print("SliderTouchBegan== \(sender.value)")
        isEnd = false
        sliderDelegate.sw_player_slider_touch_Began(sender: sender)
    }
    @objc func progressSliderValueChanged(sender: UISlider) {
        print("SliderValueChanged== \(sender.value)")
        isEnd = false
        sliderDelegate.sw_player_slider_value_chnaged(sender: sender)
    }
    @objc func progressSliderTouchEnded(sender: UISlider) {
        print("SliderTouchEnded== \(sender.value)")
        isEnd = false
        sliderDelegate.sw_player_slider_touch_end(sender: sender)
    }
    
    func screenControlSettings(angle: Double) {
        if SWScreenDirection == .portrait {
            self.fullBtn.setImage(fullImg, for: .normal)
            self.fullBtn.imageView?.tintColor = .white
            self.dismissBtn.isHidden = false
        }
        else {
            self.fullBtn.setImage(unfullImg, for: .normal)
            self.fullBtn.imageView?.tintColor = .white
            self.dismissBtn.isHidden = true
        }
    }
    
    func displayControl(isDisplaying: Bool, type: SWEpisodeModeEnum, times: SWTapTimes) {
        switch type {
        case .normal:
            self.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.0)
            if isControlDisplaying == false {   // 如果判断状态为未显示,就隐藏控件
                self.fullBtn.isHidden = true
                self.playerBtn.isHidden = true
                self.previousBtn.isHidden = true
                self.nextBtn.isHidden = true
                self.dismissBtn.isHidden = true
                self.moreBtn.isHidden = true
                self.shareBtn.isHidden = true
                self.currentTimeLabel.isHidden = true
                self.totalTimeLabel.isHidden = true
                self.titleLabel.isHidden = true
                
                if isLandscape == true && (times == .one || times == .zero) {
                    self.timeSlider.isHidden = true
                }
                else {
                    self.timeSlider.isHidden = false
                    self.timeSlider.tintColor = UIColor.clear
                }
            }
            else {  // 如果判断状态为未显示,就不隐藏控件
                self.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.4)
                self.fullBtn.isHidden = false
                self.playerBtn.isHidden = false
                self.previousBtn.isHidden = false
                self.nextBtn.isHidden = false
                self.moreBtn.isHidden = false
                self.shareBtn.isHidden = false
                self.timeSlider.tintColor = UIColor.red
                self.currentTimeLabel.isHidden = false
                self.totalTimeLabel.isHidden = false
                
                if isLandscape == true {
                    self.titleLabel.isHidden = false
                    self.dismissBtn.isHidden = true
                    self.timeSlider.isHidden = false
                    timeSlider.setThumbImage(sliderImg, for: .normal)
                }
                else {
                    self.titleLabel.isHidden = true
                    self.dismissBtn.isHidden = false
                    self.timeSlider.isHidden = false
                    timeSlider.setThumbImage(sliderImg, for: .normal)
                }
            }
            /// 如果需要始终隐藏某个控件,在这里设置.isHidden = true
        case .live:
            print("live")
            self.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.0)
            if isControlDisplaying == false {   // 如果判断状态为未显示,就隐藏控件
                self.fullBtn.isHidden = true
                self.playerBtn.isHidden = true
                self.previousBtn.isHidden = true
                self.nextBtn.isHidden = true
                self.dismissBtn.isHidden = true
                self.moreBtn.isHidden = true
                self.shareBtn.isHidden = true
                self.currentTimeLabel.isHidden = true
                self.totalTimeLabel.isHidden = true
                self.titleLabel.isHidden = true
                
                if isLandscape == true && (times == .one || times == .zero) {
                    self.timeSlider.isHidden = true
                }
                else {
                    self.timeSlider.isHidden = true
                    self.timeSlider.tintColor = UIColor.clear
                }
            }
            else {  // 如果判断状态为未显示,就不隐藏控件
                self.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.4)
                self.fullBtn.isHidden = false
                self.playerBtn.isHidden = false
                self.previousBtn.isHidden = false
                self.nextBtn.isHidden = false
                self.moreBtn.isHidden = false
                self.shareBtn.isHidden = false
                self.timeSlider.tintColor = UIColor.red
                self.currentTimeLabel.isHidden = true
                self.totalTimeLabel.isHidden = true
                
                if isLandscape == true {
                    self.titleLabel.isHidden = false
                    self.dismissBtn.isHidden = true
                    self.timeSlider.isHidden = false
                    timeSlider.setThumbImage(sliderImg, for: .normal)
                }
                else {
                    self.titleLabel.isHidden = true
                    self.dismissBtn.isHidden = false
                    self.timeSlider.isHidden = false
                    timeSlider.setThumbImage(sliderImg, for: .normal)
                }
            }
            /// 如果需要始终隐藏某个控件,在这里设置.isHidden = true

            
        case .ad:
            print("live")
        default:
            print("unknown")
        }
    }
}

/// 屏幕方向设置判断
extension SWMaskView {
    func addNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(didChanged) , name: UIDevice.orientationDidChangeNotification, object: nil)
        UIDevice.current.beginGeneratingDeviceOrientationNotifications()
    }
    @objc func didChanged() -> Bool {
        let device = UIDevice.current
        switch device.orientation {
        case UIDeviceOrientation.faceUp:
            print("屏幕朝上平躺")
        case UIDeviceOrientation.faceDown:
            print("屏幕朝下平躺")
        case UIDeviceOrientation.unknown:
            print("未知方向")
        case UIDeviceOrientation.landscapeLeft:
            print("屏幕向左横置")
            SWScreenDirection = SWScreenDirectionEnum.left
            self.isLandscape = true
            change_screen_direction()
        case UIDeviceOrientation.landscapeRight:
            print("屏幕向右横置")
            SWScreenDirection = SWScreenDirectionEnum.right
            self.isLandscape = true
            change_screen_direction()
        case UIDeviceOrientation.portrait:
            print("屏幕直立")
            SWScreenDirection = SWScreenDirectionEnum.portrait
            self.isLandscape = false
            change_screen_direction()
        case UIDeviceOrientation.portraitUpsideDown:
            print("屏幕直立,上下颠倒")
        default:
            print("无法识别")
            break;
        }
        return true
    }
    
    func change_screen_direction() {
        if self.isLandscape == true {
            if SWScreenDirection == .left {
                delegate.sw_player_rotate_action(angle: (Double.pi/2))
                screenControlSettings(angle: (Double.pi/2))
            }
            else {
                delegate.sw_player_rotate_action(angle: -(Double.pi/2))
                screenControlSettings(angle: -(Double.pi/2))
            }
        }
        else {
            delegate.sw_player_rotate_action(angle: -(Double.pi/2))
            screenControlSettings(angle: -(Double.pi/2))
        }
        self.displayControl(isDisplaying: isControlDisplaying, type: EpisodeMode, times: .zero)
        if isControlDisplaying == true {
            createTimer()
        }
        layoutControlViews()
        layoutTimeSlider()
        layoutTimeLabel()
        layoutTitleLabel()
    }
}

/// 播放状态进行中status引起的改变
extension SWMaskView {
    func statusDidChanged(status: Status) {
        
        if status == .end {
            isEnd = true
        }
        
        switch status {
        case .paused:
            if isPlaying == true {
                print("paused")
                self.playerBtn.setImage(playImg, for: .normal)
                isPlaying = false
            }
        case .playing:
            if isPlaying == false {
                print("playing")
                self.playerBtn.setImage(pauseImg, for: .normal)
                isPlaying = true
            }
        case .end:
            if isPlaying == true {
                print("paused")
                self.playerBtn.setImage(playImg, for: .normal)
                isPlaying = false
            }
        default:
            break
        }
    }
}

extension SWMaskView {
    func createTimer() {
        if timer != nil {
            timer.invalidate()
        }
        self.countDownSeconds = kCountDownSeconds
        self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.timerManager), userInfo: nil, repeats: true)
        if isControlDisplaying == true {
            self.displayControl(isDisplaying: isControlDisplaying, type: EpisodeMode, times: .zero)
        }
        else if isControlDisplaying == false && tapTime != .zero && tapTime != .one {
            self.displayControl(isDisplaying: isControlDisplaying, type: EpisodeMode, times: .two)
        }
    }
    //创建定时器管理者
    @objc func timerManager() {
        if self.countDownSeconds == 0 {
            isControlDisplaying = false
            if isControlDisplaying == false && isEnd == false {
                self.displayControl(isDisplaying: isControlDisplaying, type: EpisodeMode, times: .zero)
            }
            timer.invalidate()
        }else{
            self.countDownSeconds = self.countDownSeconds - 1
        }
    }
}
