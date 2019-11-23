//
//  CMTime.swift
//  Podcast
//
//  Created by Seif Yousry on 11/20/19.
//  Copyright © 2019 Seif Yousry. All rights reserved.
//

import AVKit

extension CMTime {
    func toDisplayString () -> String {
        
        if CMTimeGetSeconds(self).isNaN {
            return "--:--"
        }
        
        let totalSeconds = Int(CMTimeGetSeconds(self))
        //            self.currentTimeLabel.text = String(totalSeconds)
        let seconds = totalSeconds % 60
        let minutes = totalSeconds % (60 * 60) / 60
        let hours = totalSeconds / 60 / 60
        let timeFormatString = String(format: "%02d: %02d: %02d", hours, minutes, seconds)
        return timeFormatString
    }
}
