//
//  TodoView.swift
//  MyVoiceMemoApp
//
//  Created by 최안용 on 2/15/24.
//

import SwiftUI

struct TodoView: View {
    @EnvironmentObject private var pathModel: PathModel
    @StateObject private var todoViewModel: TodoViewModel = TodoViewModel()
    
    var body: some View {
        VStack {
            CustomNavigationBar(
                leftBtnAction: {
                    pathModel.paths.removeLast()
                },
                rightBtnAction: {
                    
                },
                rightBtnType: .create
            )
            
            TitleView()
                .padding(.bottom, 20)
            
            TodoTitleView(todoViewModel: todoViewModel)
                .padding(.leading, 30)
            
            SelectTimeView(todoViewModel: todoViewModel)
                .padding(.bottom, 20)
            
            SelectDayView(todoViewModel: todoViewModel)
                .padding(.leading, 30)
            
            Spacer()
        }
    }
}

// MARK: - 타이틀 뷰
private struct TitleView: View {
    var body: some View {
        HStack {
            Text("To do list를\n추가해 보세요.")
                .font(.system(size: 26, weight: .bold))
            
            Spacer()
        }
        .padding(.leading, 30)
    }
}

// MARK: - Todo 타이틀 뷰
private struct TodoTitleView: View {
    @ObservedObject var todoViewModel: TodoViewModel
    
    fileprivate init(todoViewModel: TodoViewModel) {
        self.todoViewModel = todoViewModel
    }
    
    fileprivate var body: some View {
        TextField("제목을 입력하세요.", text: $todoViewModel.title)
    }
}

// MARK: - 시간 선택 뷰
private struct SelectTimeView: View {
    @ObservedObject var todoViewModel: TodoViewModel

    fileprivate init(todoViewModel: TodoViewModel) {
        self.todoViewModel = todoViewModel
    }
    
    fileprivate var body: some View {
        VStack {
            Rectangle()
                .fill(Color.customCoolGray)
                .frame(height: 1)
            
            DatePicker(
                "",
                selection: $todoViewModel.time,
                displayedComponents: .hourAndMinute
            )
            .datePickerStyle(WheelDatePickerStyle())
            .labelsHidden()
            .frame(maxWidth: .infinity, alignment: .center)
            
            Rectangle()
                .fill(Color.customCoolGray)
                .frame(height: 1)

        }
    }
}

// MARK: - 날짜 선택 뷰
private struct SelectDayView: View {
    @ObservedObject var todoViewModel: TodoViewModel
    
    fileprivate init(todoViewModel: TodoViewModel) {
        self.todoViewModel = todoViewModel
    }
    
    fileprivate var body: some View {
        VStack(spacing: 10) {
            HStack {
                Text("날짜")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.customIconGray)
                Spacer()
            }
                        
            HStack {
                Button(action: {
                    todoViewModel.isDisplayCalender.toggle()
                }, label: {
                    Text("\(todoViewModel.day.formattedDay)")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.customGreen)
                })
             
                .popover(isPresented: $todoViewModel.isDisplayCalender) {
                    DatePicker(
                        "",
                        selection: $todoViewModel.day,
                        displayedComponents: .date
                    )
                    .labelsHidden()
                    .datePickerStyle(GraphicalDatePickerStyle())
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding()
                    .onChange(of: todoViewModel.day) { _ in
                        todoViewModel.setIsDisplayCalender(false)
                    }
                }
                
                Spacer()
            }
        }
    }
}

#Preview {
    TodoView()
}
