//
//  SWPlayer.swift
//  SWPlayer
//
//  Created by liuhongli on 2018/12/28.
//  Copyright © 2018年 liuhongli. All rights reserved.
//

import UIKit
import AVFoundation

enum Status {
    case unknown        // 初始状态: initial status
    case buffering      // 加载中: loading
    case playing        // 播放中: playing
    case paused         // 暂停: paused
    case end            // 播放到末尾: end
    case error          // 播放出错: error
}

class SWPlayer: NSObject {
    
    private let player = AVPlayer()
    var currentItem: AVPlayerItem?
    private(set) var duration: TimeInterval = 0
    private var observerContext = "SWPlayer.KVO.Context"
    private var timeObserver: Any?
    
    var statusDidChangeHandler: ((Status) -> Void)?
    var playedDurationDidChangeHandler: ((TimeInterval, TimeInterval) -> Void)?
    
    private(set) var playedDuration: TimeInterval = 0 {
        didSet {
            playedDurationDidChangeHandler?(playedDuration, duration)
        }
    }
    
    private(set) var status = Status.unknown {
        didSet {
            guard status != oldValue else {
                return
            }
            statusDidChangeHandler?(status)
        }
    }
    
    override init() {
        super.init()
        
        addNotifications()
        addPlayerObservers()
    }
    
}

extension SWPlayer {
    func replace(with url: URL) {
        currentItem = AVPlayerItem(url: url)
        addItemObservers()
        player.replaceCurrentItem(with: currentItem)
        
        let bfrPgs = bufferingProgress(currentItem!)
        print("bfrPgsbfrPgsbfrPgs ===== \(bfrPgs)")
        
    }
    func stop() {
        removeItemObservers()
        currentItem = nil
        player.replaceCurrentItem(with: nil)
        
        status = .unknown
    }
    func play() {
        player.play()
    }
    func pause() {
        player.pause()
    }
    func seek(to time: TimeInterval) {
        player.seek(to: CMTime(seconds: time, preferredTimescale: CMTimeScale(NSEC_PER_SEC)))
    }
    func bind(to playerLayer: AVPlayerLayer) {
        playerLayer.player = player
    }
}

extension SWPlayer {
    /// 计算缓冲进度
    func bufferingProgress(_ item: AVPlayerItem) -> TimeInterval {
        let loadedTimeRanges = item.loadedTimeRanges
        let timeRange = loadedTimeRanges.first?.timeRangeValue
        let start = timeRange?.start.seconds ?? 0
        let during = timeRange?.duration.seconds ?? 0
        let loaded = start + during
        return loaded
    }
}

extension SWPlayer {
    private func addNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(onNotificationPlayDidEnd(_:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
    }
    private func removeNotifications() {
        NotificationCenter.default.removeObserver(self)
    }
    private func addPlayerObservers() {
        timeObserver = player.addPeriodicTimeObserver(forInterval: CMTime(seconds: 0.1, preferredTimescale: CMTimeScale(NSEC_PER_SEC)), queue: DispatchQueue.main, using: { [unowned self] (time) in
            self.updateStatus()
            
            guard let total = self.currentItem?.duration.seconds else {
                return
            }
            if total.isNaN || total.isZero {
                return
            }
            self.duration = total
            self.playedDuration = time.seconds
        })
        player.addObserver(self, forKeyPath: "rate", options: [.new], context: &observerContext)
        player.addObserver(self, forKeyPath: "status", options: [.new], context: &observerContext)
        if #available(iOS 10, *) {
            player.addObserver(self, forKeyPath: "timeControlStatus", options: .new, context: &observerContext)
        }
    }
    
    private func removePlayerObservers() {
        guard let timeObserver = timeObserver else {
            return
        }
        player.removeTimeObserver(timeObserver)
        player.removeObserver(self, forKeyPath: "rate", context: &observerContext)
        player.removeObserver(self, forKeyPath: "status", context: &observerContext)
        if #available(iOS 10, *) {
            player.removeObserver(self, forKeyPath: "timeControlStatus", context: &observerContext)
        }
    }
    private func addItemObservers() {
        currentItem?.addObserver(self, forKeyPath: "status", options: .new, context: &observerContext)
        currentItem?.addObserver(self, forKeyPath: "playbackLikelyToKeepUp", options: .new, context: &observerContext)
        currentItem?.addObserver(self, forKeyPath: "isPlaybackBufferEmpty", options: .new, context: &observerContext)
        currentItem?.addObserver(self, forKeyPath: "isPlaybackBufferFull", options: .new, context: &observerContext)
        
        /// 加载进度progress of loaded
        currentItem?.addObserver(self, forKeyPath: "loadedTimeRanges", options: .new, context: &observerContext)
    }
    private func removeItemObservers() {
        currentItem?.removeObserver(self, forKeyPath: "status")
        currentItem?.removeObserver(self, forKeyPath: "playbackLikelyToKeepUp")
        currentItem?.removeObserver(self, forKeyPath: "isPlaybackBufferEmpty")
        currentItem?.removeObserver(self, forKeyPath: "isPlaybackBufferFull")
        currentItem?.removeObserver(self, forKeyPath: "loadedTimeRanges")
    }
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard context == &observerContext else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
            return
        }
        updateStatus()
        
        if keyPath == "status" {
//            updateStatus()
        }else if keyPath == "loadedTimeRanges"{
            let bfrPgs = self.bufferingProgress(self.currentItem!)
            print("bfrPgsbfrPgsbfrPgs ===== \(bfrPgs)")
        }
    }
}

extension SWPlayer {
    @objc private func onNotificationPlayDidEnd(_ notification: Notification) {
        guard (notification.object as? AVPlayerItem) == self.currentItem && self.currentItem != nil else {
            return
        }
        status = .end
    }
    private func updateStatus() {
        DispatchQueue.main.async {
            guard let currentItem = self.currentItem else {
                return
            }
            if self.player.error != nil || currentItem.error != nil {
                self.status = .error
                print("play error")
                return
            }
            if #available(iOS 10, *) {
                switch self.player.timeControlStatus {
                case .playing:
                    self.status = .playing
//                    print("play playing")
                case .paused:
                    self.status = .paused
                    print("play paused")
                case .waitingToPlayAtSpecifiedRate:
                    self.status = .buffering
                    print("play buffering")
                }
            } else {
                if self.player.rate != 0 {
                    if currentItem.isPlaybackLikelyToKeepUp {
                        self.status = .playing
//                        print("play playing")
                    } else {
                        self.status = .buffering
                        print("play buffering")
                    }
                } else {
                    self.status = .paused
                    print("play paused")
                }
            }
        }
    }
}
