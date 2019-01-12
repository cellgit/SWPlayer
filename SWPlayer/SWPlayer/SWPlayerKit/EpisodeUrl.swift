//
//  EpisodeUrl.swift
//  SWPlayer
//
//  Created by liuhongli on 2019/1/12.
//  Copyright © 2019年 lhl. All rights reserved.
//

import Foundation

var PlayingEpisodeUrl: String = ""


let ApiEpisodeUrl0 = "http://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4"
let ApiEpisodeUrl1 = "http://221.228.226.23/11/t/j/v/b/tjvbwspwhqdmgouolposcsfafpedmb/sh.yinyuetai.com/691201536EE4912BF7E4F1E2C67B8119.mp4"
let ApiEpisodeUrl2 = "http://221.228.226.5/14/z/w/y/y/zwyyobhyqvmwslabxyoaixvyubmekc/sh.yinyuetai.com/4599015ED06F94848EBF877EAAE13886.mp4"
let ApiEpisodeUrl3 = "http://221.228.226.5/15/t/s/h/v/tshvhsxwkbjlipfohhamjkraxuknsc/sh.yinyuetai.com/88DC015DB03C829C2126EEBBB5A887CB.mp4"
let ApiEpisodeUrl4 = "http://vjs.zencdn.net/v/oceans.mp4"






// 定义协议
protocol OperationIndexProtocol {
    var operatedIndex: Int {get}
}
enum OperationModeEnum {
    case next
    case previous
    case none
}
var MinIndex: Int = 0
var MaxIndex: Int = 4
/// 定义索引
class OperationIndex: OperationIndexProtocol {
    /// 当前播放的索引
    var index: Int = 0
    private var tempIndex: Int = 0
    var mode: OperationModeEnum = .none
    // 实现协议中定义的属性
    // 变换后的索引
    var operatedIndex: Int {
        get {
            switch mode {
            case .next:
                if index < MaxIndex {
                    tempIndex = index + 1
                }
            case .previous:
                if index > MinIndex {
                    tempIndex = index - 1
                }
            default:
                tempIndex = index - 0
            }
            return tempIndex
        }
        set {
            index = index + 0
        }
    }
}




