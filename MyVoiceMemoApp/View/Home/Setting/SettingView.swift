//
//  SettingView.swift
//  MyVoiceMemoApp
//
//  Created by 최안용 on 2/15/24.
//

import SwiftUI

struct SettingView: View {
    @EnvironmentObject private var homeViewModel: HomeViewModel
    
    var body: some View {
        VStack {
            TitleView()
            
            Spacer()
                .frame(height: 55)
            
            TotalTabCountView()
            
            Spacer()
                .frame(height: 56)
            
            TabListView()
            
            Spacer()
        }
    }
}

// MARK: - 타이틀뷰
private struct TitleView: View {
    fileprivate var body: some View {
        VStack {
            Spacer()
                .frame(height: 30)
            HStack {
                Text("설정")
                    .font(.system(size: 26, weight: .bold))
                Spacer()
            }
            .padding(.horizontal, 30)
        }
    }
}

// MARK: - 총 탭 카운트 뷰
private struct TotalTabCountView: View {
    @EnvironmentObject private var homeViewModel: HomeViewModel
    
    fileprivate var body: some View {
        HStack {
            TabCountView(title: "To do", count: homeViewModel.todosCount)
            
            Spacer()
                .frame(width: 90)
            
            TabCountView(title: "메모", count: homeViewModel.memosCount)
            
            Spacer()
                .frame(width: 90)
            
            
            TabCountView(title: "음성메모", count: homeViewModel.voiceRecordersCount)
            
        }
        .padding(.horizontal, 40)
    }
}

// MARK: - 탭 카운트 뷰
private struct TabCountView: View {
    private var title: String
    private var count: Int
    
    fileprivate init(title: String, count: Int) {
        self.title = title
        self.count = count
    }
    
    fileprivate var body: some View {
        VStack(spacing: 10) {
            Text(title)
                .font(.system(size: 14))
                .foregroundColor(.customBlack)
            Text("\(count)")
                .font(.system(size: 30, weight: .medium))
                .foregroundColor(.customBlack)
        }
    }
}

// MARK: - 탭 리스트 뷰
private struct TabListView: View {
    @EnvironmentObject private var homeViewModel: HomeViewModel
    
    var body: some View {
        VStack {
            Rectangle()
                .fill(Color.customGray0)
                .frame(height: 1)
            
            TabCellView(
                title: "To do 리스트",
                action: { homeViewModel.changeSelectedTab(.todoList) }
            )
            
            TabCellView(
                title: "메모",
                action: { homeViewModel.changeSelectedTab(.memo) }
            )

            TabCellView(
                title: "음성메모",
                action: { homeViewModel.changeSelectedTab(.voice) }
            )
            
            TabCellView(
                title: "타이머",
                action: { homeViewModel.changeSelectedTab(.timer) }
            )
                        
            Rectangle()
                .fill(Color.customGray0)
                .frame(height: 1)
        }
    }
}

// MARK: - 탭 셀 뷰
private struct TabCellView: View {
    private var title: String
    private var action: () -> Void
    
    fileprivate init(title: String, action: @escaping () -> Void) {
        self.title = title
        self.action = action
    }
    
    var body: some View {
        Button(
            action: action
            , label: {
                HStack {
                    Text(title)
                        .font(.system(size: 14))
                        .foregroundColor(.customBlack)
                    Spacer()
                    Image("arrowRight")
                }
            }
        )
        .padding(.horizontal, 30)
        .padding(.vertical, 15)
    }
}

#Preview {
    SettingView()
        .environmentObject(HomeViewModel())
}
