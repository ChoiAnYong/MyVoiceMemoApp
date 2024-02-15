//
//  TodoView.swift
//  MyVoiceMemoApp
//
//  Created by 최안용 on 2/15/24.
//

import SwiftUI

struct TodoView: View {
    @StateObject private var todoViewModel: TodoViewModel = TodoViewModel()
    
    var body: some View {
        VStack {
            TitleView()
            
            TodoTitleView(todoViewModel: todoViewModel)
                .padding(.leading, 20)
            
            SelectTimeView(todoViewModel: todoViewModel)
            
            SelectDayView(todoViewModel: todoViewModel)
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
        .padding(.leading, 20)
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
        VStack {
            Text("날짜")
                .font(.system(size: 16, weight: .medium))
                
        }
    }
}

#Preview {
    TodoView()
}
