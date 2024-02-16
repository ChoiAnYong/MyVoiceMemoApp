//
//  Todo.swift
//  MyVoiceMemoApp
//
//  Created by 최안용 on 2/16/24.
//

import Foundation

struct Todo: Hashable {
    var title: String
    var day: Date
    var time: Date
    var seleted: Bool
    
    var convertedDayAndTime: String {
        String("\(day.formattedDay) - \(time.formattedTime)에 알림")
    }
}
