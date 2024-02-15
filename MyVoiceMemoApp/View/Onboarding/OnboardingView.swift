//
//  OnboardingView.swift
//  MyVoiceMemoApp
//
//  Created by 최안용 on 2/14/24.
//

import SwiftUI

struct OnboardingView: View {
    @StateObject private var onboardingViewModel = OnboardingViewModel()
    var body: some View {
        OnboardingContentView(onboardingViewModel: onboardingViewModel)
    }
}

// MARK: - 온보딩 컨텐츠 뷰
private struct OnboardingContentView: View {
    @ObservedObject private var onboardingViewModel: OnboardingViewModel
    
    fileprivate init(onboardingViewModel: OnboardingViewModel) {
        self.onboardingViewModel = onboardingViewModel
    }
    
    fileprivate var body: some View {
        VStack {
            OnboardingCellListView(onboardingViewModel: onboardingViewModel)
            
            Spacer()
            
            OnboardingButtonView()

            Spacer()
                .frame(height: 73)
            
        }
        .edgesIgnoringSafeArea(.top)
    }
}

// MARK: - 온보딩 셀 리스트 뷰
private struct OnboardingCellListView: View {
    @ObservedObject private var onboardingViewModel: OnboardingViewModel
    @State private var pageIndex: Int
    
    fileprivate init(
        onboardingViewModel: OnboardingViewModel,
        pageIndex: Int = 0
    ) {
        self.onboardingViewModel = onboardingViewModel
        self.pageIndex = pageIndex
    }
    
    fileprivate var body: some View {
        TabView(selection: $pageIndex) {
            ForEach(Array(onboardingViewModel.onboardingContents.enumerated()), id: \.element)
            { index, onboardingContent in
                OnboardingCellView(onboardingContent: onboardingContent)
                    .tag(index)
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main
            .bounds.height/1.3)
        .background {
            pageIndex % 2 == 0 ? Color.customSky : Color.customBackgroundGreen
        }
        
    }
}


// MARK: - 온보딩 셀 뷰
private struct OnboardingCellView: View {
    private var onboardingContent: OnboardingContent
    
    init(onboardingContent: OnboardingContent) {
        self.onboardingContent = onboardingContent
    }
    
    fileprivate var body: some View {
        VStack(spacing: 0) {
            Spacer()
                .frame(height: 50)
            
            Image(onboardingContent.imageName)
                .resizable()
                .scaledToFit()
            
            HStack {
                Spacer()
                
                VStack {
                    Spacer()
                        .frame(height: 46)
                    
                    Text(onboardingContent.title)
                        .font(.system(size: 16, weight: .bold))
                    
                    Spacer()
                        .frame(height: 4)
                    
                    Text(onboardingContent.subTitle)
                        .font(.system(size: 16))
                }
                Spacer()
                    
            }
            .background(Color.customWhite)
            .cornerRadius(0)
            .shadow(radius: 2)
        }
    }
}


// MARK: - 온보딩 버튼 뷰
private struct OnboardingButtonView: View {
    var body: some View {
        Button(action: {
            
        }, label: {
            HStack {
                Text("시작하기")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.customGreen)
                
                Image("startHome")
            }
        })
    }
}

#Preview {
    OnboardingView()
}
