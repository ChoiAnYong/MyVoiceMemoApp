//
//  TodoListViewModel.swift
//  MyVoiceMemoApp
//
//  Created by 최안용 on 2/15/24.
//

import Foundation

final class TodoListViewModel: ObservableObject {
    private var todoRepository: TodoRepository
    @Published var todos: [Todo]
    @Published var removeTodos: [Todo]
    @Published var isEditMode: Bool
    @Published var isDisplayRemoveTodoAlert: Bool
    
    var removeToodCount: Int {
        return removeTodos.count
    }
    
    var navigationBtnType: NavigationBarType {
        isEditMode ? .complete : .edit
    }
    
    init(
        todos: [Todo] = [],
        removeTodos: [Todo] = [],
        isEditMode: Bool = false,
        isDisplayRemoveTodoAlert: Bool = false,
        todoRepository: TodoRepository = TodoRepository()
    ) {
        self.todos = todos
        self.removeTodos = removeTodos
        self.isEditMode = isEditMode
        self.isDisplayRemoveTodoAlert = isDisplayRemoveTodoAlert
        self.todoRepository = todoRepository
        self.todos = todoRepository.getTodos()
    }
}

extension TodoListViewModel {
    func addTodo(_ todo: Todo) {
        todoRepository.add(todo)
        todos = todoRepository.getTodos()
    }
    
    func seletedBoxTapped(_ todo: Todo) {
        if let index = todos.firstIndex(where: { $0 == todo }) {
            todos[index].seleted.toggle()
            todoRepository.update(todos[index])
        }
    }
    
    func navigationRightBtnTapped() {
        if isEditMode {
            if removeTodos.isEmpty {
                isEditMode = false
            } else {
                setIsDisplayRemoveAlert(true)
            }
        } else {
            isEditMode = true
        }
    }
    
    func setIsDisplayRemoveAlert(_ isDisplay: Bool) {
        isDisplayRemoveTodoAlert = isDisplay
    }
    
    func todoRemoveSelectedBoxTapped(_ todo: Todo) {
        if let index = removeTodos.firstIndex(of: todo) {
            removeTodos.remove(at: index)
        } else {
            removeTodos.append(todo)
        }
    }
    
    func removeBtnTapped() {
        todoRepository.selectedTodoRemove(removeTodos)
        removeTodos.removeAll()
        todos = todoRepository.getTodos()
        isEditMode = false
    }
}
