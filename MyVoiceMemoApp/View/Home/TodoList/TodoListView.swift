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
        WriteBtnView(
            content: {
                VStack {
                    if !todoListViewModel.todos.isEmpty {
                        CustomNavigationBar(
                            isDisplayLeftBtn: false,
                            rightBtnAction: {
                                todoListViewModel.navigationRightBtnTapped()
                            },
                            rightBtnType: todoListViewModel.navigationBtnType
                        )
                    } else {
                        Spacer()
                            .frame(height: 30)
                    }
                    
                    TitleView()
                    
                    if todoListViewModel.todos.isEmpty {
                        BeginningView()
                        
                    } else {
                        TodoCellListView()
                    }
                }
            }, action: { pathModel.paths.append(.todoView) }
        )
        .alert(
            "To do list \(todoListViewModel.removeToodCount)개 삭제하시겠습니까?",
            isPresented: $todoListViewModel.isDisplayRemoveTodoAlert
        ) {
            Button("삭제", role: .destructive) {
                todoListViewModel.removeBtnTapped()
            }
            
            Button("취소", role: .cancel) { }
        }
        .onChange(
            of: todoListViewModel.todos,
            perform: { todos in
                homeViewModel.setTodosCount(todos.count)
        })
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
        .padding(.leading, 30)
        .padding(.top, 30)
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
fileprivate struct TodoCellListView: View {
    @EnvironmentObject var todoListViewModel: TodoListViewModel
    
    var body: some View {
        VStack {
            HStack {
                Text("할일 목록")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.customBlack)
                Spacer()
            }
            .padding(.horizontal, 30)
            .padding(.top, 23)
        }
        
        ScrollView(.vertical) {
            VStack {
                Rectangle()
                    .fill(Color.customGray0)
                    .frame(height: 1)
                
                ForEach(todoListViewModel.todos, id: \.self) { todo in
                    TodoCellView(todo: todo)
                }
            }
        }
    }
}

// MARK: - todo cell 뷰
fileprivate struct TodoCellView: View {
    @EnvironmentObject var todoListViewModel: TodoListViewModel
    @State private var isRemoveSeleted: Bool
    private var todo: Todo
    
    fileprivate init(
        todo: Todo,
        isRemoveSeleted: Bool = false
    ) {
        self.todo = todo
        _isRemoveSeleted = State(initialValue: isRemoveSeleted)
        self.todo = todo
    }
    
    var body: some View {
        VStack {
            HStack {
                
                if !todoListViewModel.isEditMode {
                    Button(action: {
                        todoListViewModel.seletedBoxTapped(todo)
                    }, label: {
                        Image(todo.seleted ? "selectedBox" : "unSelectedBox")
                    })
                }
                
                VStack(alignment:.leading, spacing: 4) {
                    HStack {
                        Text(todo.title)
                            .font(.system(size: 16, weight: .regular))
                            .foregroundColor(todo.seleted ? .customIconGray : .customBlack)
                            .strikethrough(todo.seleted)
                    }
                    Text(todo.convertedDayAndTime)
                        .font(.system(size: 12, weight: .regular))
                        .foregroundColor(.customIconGray)
                }
                
                Spacer()
                
                if todoListViewModel.isEditMode {
                    Button(action: {
                        isRemoveSeleted.toggle()
                        todoListViewModel.todoRemoveSelectedBoxTapped(todo)
                    }, label: {
                        Image(isRemoveSeleted ? "selectedBox" : "unSelectedBox")
                    })
                    .padding(.trailing, 10)
                }                
            }
            .padding(.horizontal, 30)
            
            Rectangle()
                .fill(Color.customGray0)
                .frame(height: 1)
        }
    }
}

// MARK: - 쓰기 버튼 뷰
//fileprivate struct WriteBtnView: View {
//    @EnvironmentObject private var pathModel: PathModel
//    
//    var body: some View {
//        Button(action: {
//            pathModel.paths.append(.todoView)
//        }, label: {
//            Image("writeBtn")
//        })
//    }
//}

#Preview {
    TodoListView()
        .environmentObject(PathModel())
        .environmentObject(TodoListViewModel(todos: [.init(title: "dsf", day: Date(), time: Date(), seleted: false)]))
}
