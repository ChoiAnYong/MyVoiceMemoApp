//
//  OnboardingViewModel.swift
//  MyVoiceMemoApp
//
//  Created by 최안용 on 2/14/24.
//

import Foundation

final class OnboardingViewModel: ObservableObject {
    @Published var onboardingContents: [OnboardingContent]
    
    init(
        onboardingContents: [OnboardingContent] = [
            .init(
                imageName: "onboarding_1",
                title: "오늘의 할일",
                subTitle: "To do list로 언제 어디서든 해야할일을 한눈에"
            ),
            .init(
                imageName: "onboarding_2",
                title: "똑똑한 나만의 기록장",
                subTitle: "메모장으로 생각나는 기록은 언제든지"
            ),
            .init(
                imageName: "onboarding_3",
                title: "하나라도 놓치지 않도록",
                subTitle: "음성메모 기능으로 놓치고 싶지 않은 기록까지"
            ),
            .init(
                imageName: "onboarding_4",
                title: "정확한 시간의 경과",
                subTitle: "타이머 기능으로 원하는 시간을 확인"
            )
        ]
    ){
        self.onboardingContents = onboardingContents
    }
}
