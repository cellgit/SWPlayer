//
//  SWPlayerMode.swift
//  SWPlayer
//
//  Created by 刘宏立 on 2019/1/8.
//  Copyright © 2019 lhl. All rights reserved.
//

import UIKit

/// episode type: default is normal episode
var EpisodeMode = SWEpisodeModeEnum.normal

enum SWEpisodeModeEnum {
    case normal
    case live
    case ad
    case unknown
}
