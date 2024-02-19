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
