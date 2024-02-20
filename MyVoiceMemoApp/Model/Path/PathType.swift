//
//  PathType.swift
//  MyVoiceMemoApp
//
//  Created by 최안용 on 2/15/24.
//

import Foundation

enum PathType: Hashable {
    case homeView
    case todoView
    case memoView(isCreatMode: Bool, memo: Memo?)
}
