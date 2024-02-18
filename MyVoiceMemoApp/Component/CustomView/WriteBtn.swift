//
//  WriteBtn.swift
//  MyVoiceMemoApp
//
//  Created by 최안용 on 2/18/24.
//

import SwiftUI

public struct WriteBtnView<Content: View>: View {
    let action: () -> Void
    let content: Content
    
    public init(
        @ViewBuilder content: () -> Content,
        action: @escaping () -> Void
    ) {
        self.content = content()
        self.action = action
    }
    
    public var body: some View {
        ZStack {
            content
            
            VStack {
                Spacer()
                
                HStack {
                    Spacer()
                    
                    Button(
                        action: action,
                        label: { Image("writeBtn") }
                    )
                }
            }
            .padding(.trailing, 20)
            .padding(.bottom, 50)
        }
    }
}
