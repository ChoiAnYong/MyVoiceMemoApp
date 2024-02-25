//
//  TimerView.swift
//  MyVoiceMemoApp
//
//  Created by 최안용 on 2/15/24.
//

import SwiftUI

struct TimerView: View {
    @StateObject var timerViewModel = TimerViewModel()
    
    var body: some View {
        if timerViewModel.isDisplaySetTimeView {
            TimerSettingView(timerViewModel: timerViewModel)
        } else {
            TimerOperationView(timerViewModel: timerViewModel)
        }
    }
}

// MARK: - 타이틀뷰
private struct TitleView: View {
    fileprivate  var body: some View {
        VStack {
            Spacer()
                .frame(height: 30)
            HStack {
                Text("타이머")
                    .font(.system(size: 26, weight: .bold))
                Spacer()
            }
            .padding(.horizontal, 30)
        }
    }
}

// MARK: - 타이머 설정 뷰
private struct TimerSettingView: View {
    @ObservedObject private var timerViewModel: TimerViewModel
    
    fileprivate init(timerViewModel: TimerViewModel) {
        self.timerViewModel = timerViewModel
    }
    
    fileprivate var body: some View {
        VStack {
            TitleView()
            TimerPickerView(timerViewModel: timerViewModel)
            TimerSettingBtnView(timerViewModel: timerViewModel)
                .padding(.top, 21)
            Spacer()
        }
    }
}

// MARK: - 타이머 피커 뷰
private struct TimerPickerView:View {
    @ObservedObject private var timerViewModel: TimerViewModel
    
    fileprivate init(timerViewModel: TimerViewModel) {
        self.timerViewModel = timerViewModel
    }
    
    fileprivate var body: some View {
        VStack {
            Spacer()
                .frame(height: 100)
            
            Rectangle()
                .fill(Color.customGray0)
                .frame(height: 1)
            
            HStack {
                Picker("시간", selection: $timerViewModel.time.hours) {
                    ForEach(0..<24) { hour in
                        Text("\(hour)시")
                    }
                }
                
                Text(":")
                
                Picker("분", selection: $timerViewModel.time.minutes) {
                    ForEach(0..<60) { minute in
                        Text("\(minute)분")
                    }
                }
                
                Text(":")
                
                Picker("초", selection: $timerViewModel.time.seconds) {
                    ForEach(0..<60) { second in
                        Text("\(second)초")
                    }
                }
            }
            .labelsHidden()
            .pickerStyle(.wheel)
            .padding(.horizontal, 20)
            
            Rectangle()
                .fill(Color.customGray0)
                .frame(height: 1)
        }
    }
}

// MARK: - 타이머 설정 버튼 뷰
private struct TimerSettingBtnView: View {
    @ObservedObject private var timerViewModel: TimerViewModel
    
    fileprivate init(timerViewModel: TimerViewModel) {
        self.timerViewModel = timerViewModel
    }
    
    fileprivate var body: some View {
        Button(action: {
            timerViewModel.settingBtnTapped()
        }, label: {
            Text("설정하기")
                .font(.system(size: 18, weight: .bold))
                .foregroundStyle(.customGreen)
        })
    }
}

// MARK: - 타이머 작동 뷰
private struct TimerOperationView: View {
    @ObservedObject private var timerViewModel: TimerViewModel
    
    fileprivate init(timerViewModel: TimerViewModel) {
        self.timerViewModel = timerViewModel
    }
    
    fileprivate var body: some View {
        VStack {
            ZStack {
                VStack {
                    Text("\(timerViewModel.timeRemaining.formattedTimeString)")
                        .font(.system(size: 28))
                    
                    
                    HStack(alignment: .bottom) {
                        Image(systemName: "bell.fill")
                        
                        Text("\(timerViewModel.time.convertedSeconds.formattedSettingTime)")
                            .font(.system(size: 16))
                            .padding(.top, 10)
                    }
                }
                .foregroundColor(.customIconGray)
                
                Circle()
                    .stroke(Color.customOrange, lineWidth: 6)
                    .frame(width: 320)
            }
            
            Spacer()
                .frame(height: 46)
            
            HStack {
                Button(action: {
                    timerViewModel.cancelBtnTapped()
                }, label: {
                    Text("취소")
                        .font(.system(size: 16))
                        .foregroundColor(.customIconGray)
                        .padding(.vertical, 25)
                        .padding(.horizontal, 22)
                        .background(
                            Circle()
                                .fill(Color.customGray2.opacity(0.2))
                        )
                })
                
                Spacer()
                
                Button(action: {
                    timerViewModel.pauseOrRestartBtnTapped()
                }, label: {
                    Text(timerViewModel.isPaused ? "계속 진행" : "일시 정지")
                        .font(.system(size: 16))
                        .foregroundColor(.customIconGray)
                        .padding(.vertical, 25)
                        .padding(.horizontal, 7)
                        .background(
                            Circle()
                                .fill(Color(red: 1, green: 0.75, blue: 0.52).opacity(0.3))
                        )
                })
            }
        }
        .padding(.horizontal, 20)
    }
}

#Preview {
    TimerView()
}
