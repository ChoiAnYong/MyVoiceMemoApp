//
//  OnboardingContent.swift
//  MyVoiceMemoApp
//
//  Created by 최안용 on 2/14/24.
//

import Foundation

struct OnboardingContent: Hashable {
    var imageName: String
    var title: String
    var subTitle: String
    
    init(imageName: String, title: String, subTitle: String) {
        self.imageName = imageName
        self.title = title
        self.subTitle = subTitle
    }
}
