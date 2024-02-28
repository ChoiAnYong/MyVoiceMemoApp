//
//  MemoListViewModel.swift
//  MyVoiceMemoApp
//
//  Created by 최안용 on 2/15/24.
//

import Foundation
import CoreData

final class MemoListViewModel: ObservableObject {
    private var memoRepository: MemoRepository
    @Published var memos: [Memo]
    @Published var removeMemos: [Memo]
    @Published var isEditMode: Bool
    @Published var isDisplayRemoveAlert: Bool
    
    var removeMemoCount: Int {
        return removeMemos.count
    }
    
    var navigationBarRightBtnMode: NavigationBarType {
        isEditMode ? .complete : .edit
    }
    
    init(
        memoRepository: MemoRepository = MemoRepository(),
        memos: [Memo] = [],
        removeMemos: [Memo] = [],
        isEditMode: Bool = false,
        isDisplayRemoveAlert: Bool = false
    ) {
        self.memoRepository = memoRepository
        self.memos = memos
        self.removeMemos = removeMemos
        self.isEditMode = isEditMode
        self.isDisplayRemoveAlert = isDisplayRemoveAlert
        self.memos = memoRepository.getMemos()
    }
}

extension MemoListViewModel {
        
    func add(_ memo: Memo) {
        memoRepository.add(memo)
        memos = memoRepository.getMemos()
    }
    
    func updateMemo(_ memo: Memo) {
        memoRepository.update(memo)
        memos = memoRepository.getMemos()
    }
    
    func removeMemo(_ memo: Memo) {
        memoRepository.remove(memo)
        memos = memoRepository.getMemos()
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
        memoRepository.selectedMemoRemove(removeMemos)
        removeMemos.removeAll()
        memos = memoRepository.getMemos()
        isEditMode = false
    }
}
