//
//  TodoViewModel.swift
//  MyVoiceMemoApp
//
//  Created by 최안용 on 2/15/24.
//

import Foundation

final class TodoViewModel: ObservableObject {
    @Published var title: String
    @Published var day: Date
    @Published var time: Date
    @Published var isDisplayCalender: Bool
    @Published var date: Date
    
    init(title: String = "",
         day: Date = Date(),
         time: Date = Date(),
         isDisplayCalender: Bool = false,
         date: Date = Date()
    ) {
        self.title = title
        self.day = day
        self.time = time
        self.isDisplayCalender = isDisplayCalender
        self.date = date
    }
}

extension TodoViewModel {
    func setIsDisplayCalender(_ isDisplay: Bool) {
        self.isDisplayCalender = isDisplay
    }
    
    func combineDates(_ day1: Date, _ day2: Date) -> Date {
        // 한국 시간대 생성
        let timeZone = TimeZone(identifier: "Asia/Seoul")!
        let calendar = Calendar.current
        
        // day1과 day2의 년/월/일/시/분 정보 가져오기
        let day1Components = calendar.dateComponents(in: timeZone, from: day1)
        let day2Components = calendar.dateComponents(in: timeZone, from: day2)
        
        // day1의 년/월/일 정보와 day2의 시/분 정보를 조합하여 day3 생성
        var combinedComponents = DateComponents()
        combinedComponents.year = day1Components.year
        combinedComponents.month = day1Components.month
        combinedComponents.day = day1Components.day
        combinedComponents.hour = day2Components.hour
        combinedComponents.minute = day2Components.minute
        
        // day3 생성
        if let result = calendar.date(from: combinedComponents) {
            return result
        } else {
            fatalError("Failed to combine dates.")
        }
    }
}
