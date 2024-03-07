//
//  VoiceView.swift
//  MyVoiceMemoApp
//
//  Created by 최안용 on 2/15/24.
//

import SwiftUI

struct VoiceView: View {
    @StateObject private var voiceViewModel = VoiceViewModel()
    @EnvironmentObject private var homeViewModel: HomeViewModel
    
    var body: some View {
        ZStack {
            VStack {
                TitleView()
                
                if voiceViewModel.recordedFiles.isEmpty {
                    BeginningView()
                } else {
                    RecordedFileCellListView(voiceViewModel: voiceViewModel)
                }
            }
            RecordingBtnView(voiceViewModel: voiceViewModel)
        }
        .alert(
            "선택된 음성메모를 삭제하시겠습니까?",
            isPresented: $voiceViewModel.isDisplayRemoveVoiceRecorderAlert
        ) {
            Button("삭제", role: .destructive) {
                voiceViewModel.removeSelectedVoiceRecord()
            }
            Button("취소", role: .cancel) {}
        }
        .alert(
            voiceViewModel.alertMessage,
            isPresented: $voiceViewModel.isDisplayAlert
        ) {
            Button("확인", role: .cancel) { }
        }
        .onChange(of: voiceViewModel.recordedFiles.count, initial: true) { oldValue, newValue in
            homeViewModel.setVoiceRecordersCount(newValue)
        }
        .onDisappear {
            self.voiceViewModel.selectedRecordedFile = nil
        }
    }
}

// MARK: - 타이틀 뷰
private struct TitleView: View {
    var body: some View {
        VStack {
            Spacer()
                .frame(height: 30)
            
            HStack {
                Text("음성메모")
                    .font(.system(size: 26, weight: .bold))
                Spacer()
            }
            .padding(.horizontal,30)
        }
    }
}

// MARK: - 음성 메모 초기 뷰
private struct BeginningView: View {
    var body: some View {
        VStack(spacing: 8) {
            Spacer()
            
            Image("pencil")
            Text("현재 등록된 음성메모가 없습니다.")
            Text("하단의 녹음버튼을 눌러 음성메모를 시작해주세요.")
            
            Spacer()
        }
        .font(.system(size: 14, weight: .regular))
        .foregroundColor(.customGray2)
    }
}

// MARK: - 음성 메모 셀 리스트 뷰
private struct RecordedFileCellListView: View {
    @ObservedObject private var voiceViewModel: VoiceViewModel
    
    fileprivate init(voiceViewModel: VoiceViewModel) {
        self.voiceViewModel = voiceViewModel
    }
    
    var body: some View {
        ScrollView(.vertical) {
            VStack {
                Rectangle()
                    .fill(Color.customGray0)
                    .frame(height: 1)
                
                ForEach(voiceViewModel.recordedFiles, id: \.self) { recordedFile in
                    RecordedFileCellView(voiceViewModel: voiceViewModel, recordedFile: recordedFile)
                }
            }
        }
    }
}


// MARK: - 음성 메모 셀 뷰
private struct RecordedFileCellView: View {
    @ObservedObject private var voiceViewModel: VoiceViewModel
    private var recordedFile: URL
    private var creationDate: Date?
    private var duration: TimeInterval?
    private var progressBarValue: Float {
        if voiceViewModel.selectedRecordedFile == recordedFile
            && (voiceViewModel.isPlaying || voiceViewModel.isPaused) {
            return Float(voiceViewModel.playedTime) / Float(duration ?? 1)
        } else {
            return 0
        }
    }
    
    fileprivate init(
        voiceViewModel: VoiceViewModel,
        recordedFile: URL
    ) {
        self.voiceViewModel = voiceViewModel
        self.recordedFile = recordedFile
        (self.creationDate, self.duration) = voiceViewModel.getFileInfo(for: recordedFile)
    }
    
    var body: some View {
        VStack {
            Button(action: {
                voiceViewModel.voiceRecordCellTapped(recordedFile)
            }, label: {
                VStack {
                    HStack {
                        
                        Text(recordedFile.lastPathComponent.replacingOccurrences(of: ".m4a", with: ""))
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.customBlack)
                        Spacer()
                    }
                    
                    HStack {
                        if let creationDate = creationDate {
                            Text(creationDate.formattedVoiceTime)
                                .font(.system(size: 12, weight: .regular))
                                .foregroundColor(.customIconGray)
                        }
                        
                        Spacer()
                        
                        if let duration = duration {
                            Text(duration.formattedTimeInterval)
                                .font(.system(size: 12, weight: .regular))
                                .foregroundColor(.customIconGray)
                        }
                    }
                }
            })
            .padding(.horizontal, 30)
            
            if voiceViewModel.selectedRecordedFile == recordedFile {
                VStack {
                    ProgressBar(progress: progressBarValue)
                        .frame(height: 2)
                    
                    Spacer()
                        .frame(height: 5)
                    
                    HStack {
                        Text(voiceViewModel.playedTime.formattedTimeInterval)
                            .font(.system(size: 10, weight: .medium))
                            .foregroundColor(.customIconGray)
                        
                        Spacer()
                        
                        if let duration = duration {
                            Text(duration.formattedTimeInterval)
                                .font(.system(size: 10, weight: .medium))
                                .foregroundColor(.customIconGray)
                        }
                    }
                    
                    Spacer()
                        .frame(height: 10)
                    
                    HStack {
                        Spacer()
                        
                        Button(action: {
                            if voiceViewModel.isPaused {
                                voiceViewModel.resumePlaying()
                            } else {
                                voiceViewModel.startPlaying(recordingURL: recordedFile)
                            }
                        }, label: {
                            Image("play")
                                .renderingMode(.template)
                                .resizable()
                                .frame(width: 20, height: 20)
                                .foregroundColor(.customBlack)
                        })
                        
                        Spacer()
                            .frame(width: 20)
                        
                        Button(action: {
                            if voiceViewModel.isPlaying {
                                voiceViewModel.pausePlaying()
                            }
                        }, label: {
                            Image("pause")
                                .renderingMode(.template)
                                .resizable()
                                .frame(width: 20, height: 20)
                                .foregroundColor(.customBlack)
                        })
                        
                        Spacer()
                        
                        Button(action: {
                            voiceViewModel.removeBtnTapped()
                        }, label: {
                            Image("trash")
                                .renderingMode(.template)
                                .resizable()
                                .frame(width: 30, height: 30)
                                .foregroundColor(.customBlack)
                        })
                    }
                }
                .padding(.horizontal, 30)
            }
            
            Rectangle()
                .fill(Color.customGray0)
                .frame(height: 1)
        }
    }
}

// MARK: - 녹음 버튼 뷰
private struct RecordingBtnView: View {
    @ObservedObject private var voiceViewModel: VoiceViewModel
    @State private var isAnimation: Bool
    
    fileprivate init(
        voiceViewModel: VoiceViewModel,
        isAnimation: Bool = false
    ) {
        self.voiceViewModel = voiceViewModel
        self.isAnimation = isAnimation
    }
    
    var body: some View {
        VStack {
            Spacer()
            
            HStack {
                Spacer()
                
                Button(action: {
                    voiceViewModel.recordBtnTapped()
                    
                }, label: {
                    if voiceViewModel.isRecording {
                        Image("mic_recording")
                            .scaleEffect(isAnimation ? 1.5 : 1)
                            .onAppear {
                                withAnimation(.linear(duration: 0.7).repeatForever()) {
                                    isAnimation.toggle()
                                }
                            }
                            .onDisappear {
                                isAnimation = false
                            }
                            
                    } else {
                        Image("mic")
                    }
                })
            }
        }
        .padding(.trailing, 20)
        .padding(.bottom, 50)
    }
}

// MARK: - 프로그래스 바
private struct ProgressBar: View {
    private var progress: Float
    
    fileprivate init(progress: Float) {
        self.progress = progress
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .fill(Color.customGray2)
                
                Rectangle()
                    .fill(Color.customGreen)
                    .frame(width: CGFloat(self.progress) * geometry.size.width)
            }
        }
    }
}

#Preview {
    VoiceView()
}
