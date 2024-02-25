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
        TitleView()
    }
}

// MARK: - 타이틀뷰
private struct TitleView: View {
    fileprivate var body: some View {
        VStack {
            Spacer()
                .frame(height: 30)
            HStack {
                Text("타이머")
                    .font(.system(size: 26, weight: .bold))
                Spacer()
            }
            .padding(.horizontal, 30)
        }
    }
}

// MARK: - 탭 카운트 뷰
private struct TabCountView: View {
    @EnvironmentObject private var homeViewModel: HomeViewModel
    
    fileprivate var body: some View {
        /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Hello, world!@*/Text("Hello, world!")/*@END_MENU_TOKEN@*/
    }
}

private struct

#Preview {
    SettingView()
        .environmentObject(HomeViewModel())
}
