//
//  HomeView.swift
//  MyVoiceMemoApp
//
//  Created by 최안용 on 2/15/24.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var pathModel: PathModel
    @StateObject private var homeViewModel = HomeViewModel()
    
    var body: some View {
        TabView(selection: $homeViewModel.selectedTab) {
            TodoListView()
                .tabItem {
                    Image(homeViewModel.selectedTab == .todoList ? "todoIcon_selected" : "todoIcon")
                }
                .tag(Tab.todoList)
            
            MemoView()
                .tabItem {
                    Image(homeViewModel.selectedTab == .memo ? "memoIcon_selected" : "memoIcon")
                }
                .tag(Tab.memo)
            
            VoiceView()
                .tabItem {
                    Image(homeViewModel.selectedTab == .voice ? "recordIcon_selected" : "recordIcon")
                }
                .tag(Tab.voice)
            
            TimerView()
                .tabItem {
                    Image(homeViewModel.selectedTab == .timer ? "timerIcon_selected" : "timerIcon")
                }
                .tag(Tab.timer)
            
            SettingView()
                .tabItem {
                    Image(homeViewModel.selectedTab == .setting ? "settingIcon_selected" : "settingIcon")
                }
                .tag(Tab.setting)
        }
        
    }
}

#Preview {
    HomeView()
        .environmentObject(PathModel())
}
