//
//  TodoListViewModel.swift
//  MyVoiceMemoApp
//
//  Created by 최안용 on 2/15/24.
//

import Foundation

final class TodoListViewModel: ObservableObject {
    @Published var todos: [Todo]
    @Published var removeTodos: [Todo]
    @Published var isEditMode: Bool
    
    var removeToodCount: Int {
        return removeTodos.count
    }
    
    var navigationBtnType: NavigationBarType {
        isEditMode ? .complete : .edit
    }
    
    init(
        todos: [Todo] = [],
        removeTodos: [Todo] = [],
        isEditMode: Bool = false
    ) {
        self.todos = todos
        self.removeTodos = removeTodos
        self.isEditMode = isEditMode
    }
}

extension TodoListViewModel {
    func addTodo(_ todo: Todo) {
        todos.append(todo)
    }
    
    func seletedBoxTapped(_ todo: Todo) {
        if let index = todos.firstIndex(where: { $0 == todo }) {
            todos[index].seleted.toggle()
        }
    }
}
