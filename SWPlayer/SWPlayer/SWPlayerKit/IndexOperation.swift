//
//  IndexOperation.swift
//  SWPlayer
//
//  Created by 刘宏立 on 2019/1/13.
//  Copyright © 2019 lhl. All rights reserved.
//

import UIKit

// 定义协议
protocol IndexOperationProtocol {
    var indexOperated: Int {get}
}
enum OperationModeEnum {
    case next
    case previous
    case none
}

/// 定义索引
class IndexOperation: IndexOperationProtocol {
    var minIndex: Int = 0
    var maxIndex: Int = 0
    /// 当前播放的索引
    var index: Int = 0
    private var tempIndex: Int = 0
    var mode: OperationModeEnum = .none
    // 实现协议中定义的属性
    // 变换后的索引
    var indexOperated: Int {
        get {
            switch mode {
            case .next:
                if index < maxIndex {
                    tempIndex = index + 1
                }
            case .previous:
                if index > minIndex {
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
