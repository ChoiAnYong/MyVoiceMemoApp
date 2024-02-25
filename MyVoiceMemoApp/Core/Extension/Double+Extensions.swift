//
//  Double+Extensions.swift
//  MyVoiceMemoApp
//
//  Created by 최안용 on 2/23/24.
//

import Foundation

extension Double {
    var formattedTimeInterval: String {
        let totalSecond = Int(self)
        let seconds = totalSecond % 60
        let minutes = (totalSecond / 60) % 60
        
        return String(format: "%02d:%02d", minutes, seconds)
    }
}
