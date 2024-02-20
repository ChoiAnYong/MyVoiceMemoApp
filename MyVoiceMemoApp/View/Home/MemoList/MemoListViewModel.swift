//
//  MemoListViewModel.swift
//  MyVoiceMemoApp
//
//  Created by 최안용 on 2/15/24.
//

import Foundation

final class MemoListViewModel: ObservableObject {
    @Published var memos: [Memo]
    @Published var removeMemos: [Memo]
    @Published var isEditMode: Bool
    @Published var isDisplayRemoveAlert: Bool
    
    init(
        memos: [Memo] = [],
        removeMemos: [Memo] = [],
        isEditMode: Bool = false,
        isDisplayRemoveAlert: Bool = false
    ) {
        self.memos = memos
        self.removeMemos = removeMemos
        self.isEditMode = isEditMode
        self.isDisplayRemoveAlert = isDisplayRemoveAlert
    }
}

extension MemoListViewModel {
    func add(_ memo: Memo) {
        memos.append(memo)
    }
    
    func updateMemo(_ memo: Memo) {
        if let index = memos.firstIndex(where: { $0.id == memo.id }) {
            memos[index] = memo
        }
    }
    
    func removeMemo(_ memo: Memo) {
        if let index = memos.firstIndex(where: { $0.id == memo.id }) {
            memos.remove(at: index)
        }
    }
    
    func navigationRightBtnTapped() {
        if isEditMode {
            if removeMemos.isEmpty {
                isEditMode = false
            } else {
                setIsDisplayRemoveAlert(true)
            }
        } else {
            isEditMode = true
        }
    }
    
    func setIsDisplayRemoveAlert(_ isDisplay: Bool) {
        isDisplayRemoveAlert = isDisplay
    }
    
    func memoRemoveSelectedBoxTapped(_ memo: Memo) {
        if let index = removeMemos.firstIndex(of: memo) {
            removeMemos.remove(at: index)
        } else {
            removeMemos.append(memo)
        }
    }
    
    func removeBtnTapped() {
        memos.removeAll() { memo in
            removeMemos.contains(memo)
        }
        removeMemos.removeAll()
        isEditMode = false
    }
}
