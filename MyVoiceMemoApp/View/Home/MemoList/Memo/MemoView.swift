//
//  MemoView.swift
//  MyVoiceMemoApp
//
//  Created by 최안용 on 2/15/24.
//

import SwiftUI

struct MemoView: View {
    @EnvironmentObject private var pathModel: PathModel
    @EnvironmentObject private var memoListViewModel: MemoListViewModel
    @StateObject  var memoViewModel: MemoViewModel
    @State var isCreateMode: Bool = true
    
    var body: some View {
        ZStack {
            VStack {
                CustomNavigationBar()
                TitleView(memoViewModel: memoViewModel, isCreateMode: $isCreateMode)
                MemoInputView(memoViewModel: memoViewModel)
                
                if !isCreateMode {
                    DeleteBtnView(memoViewModel: memoViewModel)
                }
                
                
            }
        }
    }
}

// MARK: - 타이틀 뷰
private struct TitleView: View {
    @ObservedObject private var memoViewModel: MemoViewModel
    @FocusState private var isTitleFieldFocused: Bool
    @Binding private var isCreateMode: Bool
    
    fileprivate init(
        memoViewModel: MemoViewModel,
        isCreateMode: Binding<Bool>
    ) {
        self.memoViewModel = memoViewModel
        self._isCreateMode = isCreateMode
    }
    
    fileprivate var body: some View {
        TextField("제목을 입력하세요", text: $memoViewModel.memo.title)
            .font(.system(size: 26, weight: .bold))
            .foregroundColor(.customBlack)
            .padding(.horizontal, 32)
            .padding(.top, 30)
            .focused($isTitleFieldFocused)
            .onAppear {
                if isCreateMode {
                    isTitleFieldFocused = true
                }
            }
    }
}

// MARK: - 메모 입력 뷰
private struct MemoInputView: View {
    @ObservedObject private var memoViewModel: MemoViewModel
    
    fileprivate init(memoViewModel: MemoViewModel) {
        self.memoViewModel = memoViewModel
    }
    
    fileprivate var body: some View {
        ZStack(alignment: .topLeading, content: {
            TextEditor(text: $memoViewModel.memo.content)
                .font(.system(size: 18, weight: .regular))
                .foregroundColor(.customBlack)
            
            if memoViewModel.memo.content.isEmpty {
                Text("메모를 입력하세요.")
                    .font(.system(size: 18, weight: .regular))
                    .foregroundColor(.customGray1)
                    .allowsHitTesting(false)
                    .padding(.top, 10)
                    .padding(.leading, 5)
            }
        })
        .padding(.horizontal, 32)
    }
}


// MARK: - 삭제 버튼 뷰
private struct DeleteBtnView: View {
    @EnvironmentObject private var memoListViewModel: MemoListViewModel
    @EnvironmentObject private var pathModel: PathModel
    @ObservedObject private var memoViewModel: MemoViewModel
    
    fileprivate init(memoViewModel: MemoViewModel) {
        self.memoViewModel = memoViewModel
    }
    
    var body: some View {
        VStack {
            Spacer()
            
            HStack {
                Spacer()
                
                Button(action: {
                }, label: {
                    Image("trash")
                        .resizable()
                        .frame(width: 40, height: 40)
                })
            }
            .padding(.trailing, 20)
        }
    }
}

#Preview {
    MemoView(memoViewModel: .init(memo: .init(title: "", content: "", date: Date())))
}
