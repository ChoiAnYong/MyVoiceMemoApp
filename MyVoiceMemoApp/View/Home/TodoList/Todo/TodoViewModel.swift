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
    
    init(title: String = "",
         day: Date = Date(),
         time: Date = Date(),
         isDisplayCalender: Bool = false
    ) {
        self.title = title
        self.day = day
        self.time = time
        self.isDisplayCalender = isDisplayCalender
    }
}

extension TodoViewModel {
    func setIsDisplayCalender(_ isDisplay: Bool) {
        self.isDisplayCalender = isDisplay
    }
}
