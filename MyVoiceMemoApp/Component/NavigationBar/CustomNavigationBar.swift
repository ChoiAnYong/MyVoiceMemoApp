//
//  CustomNavigationBar.swift
//  MyVoiceMemoApp
//
//  Created by 최안용 on 2/16/24.
//

import SwiftUI

struct CustomNavigationBar: View {
    let isDisplayLeftBtn: Bool
    let isDisplayRightBtn: Bool
    let leftBtnAction: () -> Void
    let rightBtnAction: () -> Void
    let rightBtnType: NavigationBarType
    
    init(
        isDisplayLeftBtn: Bool = true,
        isDisplayRightBtn: Bool = true,
        leftBtnAction: @escaping () -> Void = {},
        rightBtnAction: @escaping () -> Void = {},
        rightBtnType: NavigationBarType = .edit
    ) {
        self.isDisplayLeftBtn = isDisplayLeftBtn
        self.isDisplayRightBtn = isDisplayRightBtn
        self.leftBtnAction = leftBtnAction
        self.rightBtnAction = rightBtnAction
        self.rightBtnType = rightBtnType
    }
    
    
    
    var body: some View {
        HStack {
            if isDisplayLeftBtn {
                Button(action: leftBtnAction,
                       label: {
                    Image("leftArrow")
                })
            }
            
            Spacer()
            
            if isDisplayRightBtn {
                Button(action: rightBtnAction, label: {
                    if rightBtnType == .close {
                        Image("close")
                    } else {
                        Text(rightBtnType.rawValue)
                            .foregroundColor(.customBlack)
                    }
                })
            }
        }
        .padding(.horizontal, 32)
        .frame(height: 22)
    }
}

#Preview {
    CustomNavigationBar()
}
