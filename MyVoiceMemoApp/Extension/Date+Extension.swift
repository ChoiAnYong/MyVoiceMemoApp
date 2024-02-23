//
//  Date+Extension.swift
//  MyVoiceMemoApp
//
//  Created by 최안용 on 2/15/24.
//

import Foundation

extension Date {
    var formattedTime: String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.dateFormat = "a hh:mm"
        return dateFormatter.string(from: self)
    }
    
    var formattedDay: String {
        let now = Date()
        let calendar = Calendar.current
        
        let nowDay = calendar.startOfDay(for: now)
        let recordDay = calendar.startOfDay(for: self)
        let difference = calendar.dateComponents([.day], from: nowDay, to: recordDay).day!
        
        if difference == 0 {
            return "오늘"
        } else {
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "ko_KR")
            dateFormatter.dateFormat = "M월 d일 EEEE"
            return dateFormatter.string(from: self)
        }
    }
    
    var formattedVoiceTime: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yyyy.M.d"
        return formatter.string(from: self)
    }
}
