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
        let calendar = Calendar.current
        
        // day1의 날짜 구성 요소 가져오기
        let day1Components = calendar.dateComponents(in: .current, from: day1)
        
        // day2의 시간 구성 요소 가져오기
        let day2Components = calendar.dateComponents(in: .current, from: day2)
        
        // day1의 날짜와 day2의 시간을 결합하여 새로운 날짜 생성
        var combinedComponents = DateComponents()
        combinedComponents.year = day1Components.year
        combinedComponents.month = day1Components.month
        combinedComponents.day = day1Components.day
        combinedComponents.hour = day2Components.hour
        combinedComponents.minute = day2Components.minute
        combinedComponents.second = day2Components.second
        
        // 새로운 날짜 생성
        let combinedDate = calendar.date(from: combinedComponents)
        
        return combinedDate!
    }
}
