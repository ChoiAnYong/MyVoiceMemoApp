//
//  Memo.swift
//  MyVoiceMemoApp
//
//  Created by 최안용 on 2/19/24.
//

import Foundation

struct Memo: Hashable {
    var title: String
    var content: String
    var date: Date
    var id = UUID()
    
    var convertedDate: String {
        String("\(date.formattedDay) - \(date.formattedTime)")
    }
}
