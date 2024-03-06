//
//  MemoListView.swift
//  MyVoiceMemoApp
//
//  Created by 최안용 on 2/15/24.
//

import SwiftUI

struct MemoListView: View {
    @EnvironmentObject private var pathModel: PathModel
    @EnvironmentObject private var memoListViewModel: MemoListViewModel
    @EnvironmentObject private var homeViewModel: HomeViewModel
    
    var body: some View {
        WriteBtnView (
            content: {
                VStack {
                    if !memoListViewModel.memos.isEmpty {
                        CustomNavigationBar(
                            isDisplayLeftBtn: false,
                            rightBtnAction: {
                                memoListViewModel.navigationRightBtnTapped()
                            },
                            rightBtnType: memoListViewModel.navigationBarRightBtnMode
                        )
                    } else {
                        Spacer()
                            .frame(height: 30)
                    }
                    
                    TitleView()
                    
                    if memoListViewModel.memos.isEmpty {
                        BeginningView()
                    } else {
                        MemoCellListView()
                    }
                }
            },
            action: {
                pathModel.paths.append(.memoView(isCreatMode: true, memo: nil))
            }
        )
        .alert(
            "메모 \(memoListViewModel.removeMemoCount)개 삭제하시겠습니까?",
            isPresented: $memoListViewModel.isDisplayRemoveAlert
        ) {
            Button("삭제", role: .destructive) {
                memoListViewModel.removeBtnTapped()
            }
            Button("취소", role: .cancel) {}
        }
        .onChange(of: memoListViewModel.memos.count, initial: true) { oldValue, newValue in
            homeViewModel.setMemosCount(newValue)
        }
    }
}

// MARK: - 타이틀 뷰
private struct TitleView: View {
    @EnvironmentObject private var memoListViewModel: MemoListViewModel
    
    fileprivate var body: some View {
        HStack {
            if memoListViewModel.memos.isEmpty {
                Text("메모를\n추가해보세요")
            } else {
                Text("메모 \(memoListViewModel.memos.count)개가\n있습니다.")
            }
            Spacer()
        }
        .font(.system(size: 30, weight: .bold))
        .padding(.horizontal, 30)
        .padding(.top, 30)
    }
}

// MARK: - 초기 뷰
private struct BeginningView: View {
    fileprivate var body: some View {
        VStack(spacing: 8) {
            Spacer()
            
            Image("pencil")
            Text("\"퇴근 9시간 전 메모\"")
            Text("\"기획서 작성 후 퇴근하기 메모\"")
            Text("\"밀린 집안일 하기 메모\"")
            
            Spacer()
        }
        .font(.system(size: 14, weight: .regular))
        .foregroundColor(.customGray2)
    }
}

// MARK: - 메모 셀 리스트 뷰
private struct MemoCellListView: View {
    @EnvironmentObject private var memoListViewModel: MemoListViewModel
    
    var body: some View {
        VStack {
            HStack {
                Text("메모 목록")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.customBlack)
                
                Spacer()
            }
            .padding(.top, 23)
            .padding(.horizontal, 30)
            
            ScrollView(.vertical) {
                Rectangle()
                    .fill(Color.customGray0)
                    .frame(height: 1)
                
                ForEach(memoListViewModel.memos, id: \.self) { memo in
                    MemoCellView(memo: memo)
                }
            }
            
        }
    }
}

// MARK: - 메모 셀 뷰
private struct MemoCellView: View {
    @EnvironmentObject private var memoListViewModel: MemoListViewModel
    @EnvironmentObject private var pathModel: PathModel
    @State private var isRemoveSeleted: Bool
    private var memo: Memo
    
    fileprivate init(
        isRemoveSeleted: Bool = false,
        memo: Memo
    ){
        _isRemoveSeleted = State(initialValue: isRemoveSeleted)
        self.memo = memo
    }
    
    fileprivate var body: some View {
        Button(action: {
            pathModel.paths.append(.memoView(isCreatMode: false, memo: memo))
        }, label: {
            VStack {
                HStack {
                    VStack(alignment: .leading) {
                        Text(memo.title)
                            .font(.system(size: 16, weight: .regular))
                            .lineLimit(1)
                            .foregroundColor(.customBlack)
                        
                        Text(memo.convertedDate)
                            .font(.system(size: 12, weight: .regular))
                            .foregroundColor(.customIconGray)
                    }
                    
                    Spacer()
                    
                    if memoListViewModel.isEditMode {
                        Button(action: {
                            isRemoveSeleted.toggle()
                            memoListViewModel.memoRemoveSelectedBoxTapped(memo)
                        }, label: {
                            isRemoveSeleted ? Image("selectedBox") : Image("unSelectedBox")
                        })
                    }
                }
                .padding(.horizontal, 30)
        
                Rectangle()
                    .fill(Color.customGray0)
                    .frame(height: 1)
            }
        })
    }
}

#Preview {
    MemoListView()
        .environmentObject(PathModel())
        .environmentObject(MemoListViewModel(memos: [.init(title: "메모", content: "dklsjfdl", date: Date())]))
        .environmentObject(HomeViewModel())
}
