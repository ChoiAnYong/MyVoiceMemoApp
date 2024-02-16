//
//  TodoListView.swift
//  MyVoiceMemoApp
//
//  Created by 최안용 on 2/15/24.
//

import SwiftUI

struct TodoListView: View {
    @EnvironmentObject private var todoListViewModel: TodoListViewModel
    @EnvironmentObject private var pathModel: PathModel
    @EnvironmentObject private var homeViewModel: HomeViewModel
    
    var body: some View {
        VStack {
            
            
            CustomNavigationBar()
            
            TitleView()
                .padding(.horizontal, 30)
                .padding(.top, 29)
            
            if todoListViewModel.todos.isEmpty {
                BeginningView()
            } else {
                TodoCellView(todo: todoListViewModel.todos.first!)
                    .padding(.horizontal, 30)
            }
            
            
            
            Spacer()
            
                        
            WriteBtnView()
                
        }
    }
}


// MARK: - 타이틀 뷰
fileprivate struct TitleView: View {
    @EnvironmentObject var todoListViewModel: TodoListViewModel
    var body: some View {
        HStack {
            if todoListViewModel.todos.isEmpty {
                Text("To do list를\n추가해 보세요.")
                    .font(.system(size: 30, weight: .bold))
                    .foregroundColor(.customBlack)
            } else {
                Text("To do list \(todoListViewModel.todos.count)개가\n 있습니다.")
                    .font(.system(size: 30, weight: .bold))
                    .foregroundColor(.customBlack)
            }
            Spacer()
        }
    }
}

// MARK: - 초기 뷰
fileprivate struct BeginningView: View {
    var body: some View {
        VStack(spacing: 8) {
            Spacer()
            
            Image("pencil")
            
            Text("\"매일 아침 8시 운동가라고 알려줘\"")
            Text("\"내일 8시 수강 신청하라고 알려줘\"")
            Text("\"1시 반 점심약속 리마인드 해줘\"")
            
            Spacer()
        }
        .font(.system(size: 14, weight: .regular))
        .foregroundColor(.customGray2)
    }
}


// MARK: - todo cell list 뷰

// MARK: - todo cell 뷰
fileprivate struct TodoCellView: View {
    @EnvironmentObject var todoListViewModel: TodoListViewModel
    private var todo: Todo
    
    fileprivate init(todo: Todo) {
        self.todo = todo
    }
    
    var body: some View {
        HStack {
            VStack(alignment:.leading, spacing: 4) {
                HStack {
                    Text(todo.title)
                        .font(.system(size: 16, weight: .regular))
                        .foregroundColor(.customBlack)
                }
                Text(todo.convertedDayAndTime)
                    .font(.system(size: 12, weight: .regular))
                    .foregroundColor(.customIconGray)
            }
            
            Spacer()
            
            Button(action: {
                
            }, label: {
                Image(todo.seleted ? "unSelectedBox" : "selectedBox")
            })
        }
    }
}

// MARK: - 쓰기 버튼 뷰
fileprivate struct WriteBtnView: View {
    @EnvironmentObject private var pathModel: PathModel
    
    var body: some View {
        Button(action: {
            pathModel.paths.append(.todoView)
        }, label: {
            Image("writeBtn")
        })
    }
}

#Preview {
    TodoListView()
        .environmentObject(PathModel())
        .environmentObject(TodoListViewModel(todos: [.init(title: "미팅잡기", day: Date(), time: Date(), seleted: true)]))
}
