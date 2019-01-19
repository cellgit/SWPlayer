//
//  IndexOperation.swift
//  SWPlayer
//
//  Created by 刘宏立 on 2019/1/13.
//  Copyright © 2019 lhl. All rights reserved.
//

import UIKit

enum OperationModeEnum {
    case next
    case previous
    case none
}

struct IndexOperation {
    /// first index
    public var minIndex: Int = 0
    /// last index
    public var maxIndex: Int = 0
    /// index before changed
    public var index: Int = 0
    /// temp index var, record index
    private var tempIndex: Int = 0
    /// change mode: next, previous, none
    public var mode: OperationModeEnum = .none
    /// index after changed
    public var indexOperated: Int {
        mutating get {
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
    }
}
