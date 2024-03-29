//
//  VoiceViewModel.swift
//  MyVoiceMemoApp
//
//  Created by 최안용 on 2/15/24.
//

import AVFoundation
import UIKit

final class VoiceViewModel: NSObject, AVAudioPlayerDelegate, ObservableObject {
    @Published var isDisplayRemoveVoiceRecorderAlert: Bool
    @Published var isDisplayAlert: Bool
    @Published var alertMessage: String
    
    // 음성 녹음 관련
    var audioRecorder: AVAudioRecorder?
    @Published var isRecording: Bool
    
    
    // 음성 재생 관련
    var audioPlayer: AVAudioPlayer?
    @Published var isPlaying: Bool
    @Published var isPaused: Bool
    @Published var playedTime: TimeInterval
    private var progressTimer: Timer?
    
    var recordedFiles: [URL]
    var nextAvailableNumber: Int
    
    @Published var selectedRecordedFile: URL?
    
    init(
        isDisplayRemoveVoiceRecorderAlert: Bool = false,
        isDisplayAlert: Bool = false,
        alertMessage: String = "",
        isRecording: Bool = false,
        isPlaying: Bool = false,
        isPaused: Bool = false,
        playedTime: TimeInterval = 0,
        recordedFiles: [URL] = [],
        selectedRecordedFile: URL? = nil,
        nextAvailableNumber: Int = 1
    ) {
        self.isDisplayRemoveVoiceRecorderAlert = isDisplayRemoveVoiceRecorderAlert
        self.isDisplayAlert = isDisplayAlert
        self.alertMessage = alertMessage
        self.isRecording = isRecording
        self.isPlaying = isPlaying
        self.isPaused = isPaused
        self.playedTime = playedTime
        self.recordedFiles = recordedFiles
        self.selectedRecordedFile = selectedRecordedFile
        self.nextAvailableNumber = nextAvailableNumber
        
        super.init()
        self.loadRecordedFiles()
    }
}

extension VoiceViewModel {
    func voiceRecordCellTapped(_ recordedFile: URL) {
        if selectedRecordedFile != recordedFile {
            stopPlaying()
            selectedRecordedFile = recordedFile
        }
    }
    
    func removeBtnTapped() {
        setIsDisplayRemoveVoiceRecorderAlert(true)
    }
    
    func removeSelectedVoiceRecord() {
        guard let fileToRemove = selectedRecordedFile,
              let indexToRemove = recordedFiles.firstIndex(of: fileToRemove) else {
            displayAlert(message: "선택된 음성메모 파일을 찾을 수 없습니다.")
            return
        }
        
        do {
            try FileManager.default.removeItem(at: fileToRemove)
            recordedFiles.remove(at: indexToRemove)
            selectedRecordedFile = nil
            stopPlaying()
            displayAlert(message: "선택된 음성메모 파일을 성공적으로 삭제했습니다.")
        } catch {
            displayAlert(message: "선택된 음성메모 삭제 중 오류가 발생했습니다.")
        }
    }
    
    private func setIsDisplayRemoveVoiceRecorderAlert(_ isDisplay: Bool) {
        DispatchQueue.main.async {
            self.isDisplayRemoveVoiceRecorderAlert = isDisplay
        }
    }
    
    private func setErrorAlertMessage(_ message: String) {
        DispatchQueue.main.async {
            self.alertMessage = message
        }
    }
    
    private func setIsDisplayErrorAlert(_ isDisplay: Bool) {
        DispatchQueue.main.async {
            self.isDisplayAlert = isDisplay
        }
    }
    
    private func displayAlert(message: String) {
        setErrorAlertMessage(message)
        setIsDisplayErrorAlert(true)
    }
}

// MARK: - 녹음 관련
extension VoiceViewModel {
    
    // 마이크 권한 요청
    func requestMicrophoneAccess(completion: @escaping (Bool) -> Void) {
        switch AVAudioApplication.shared.recordPermission {
        case .undetermined:
            AVAudioApplication.requestRecordPermission { allowed in
                completion(allowed)
            }
        case .denied:
            guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else { return }
            UIApplication.shared.open(settingsURL)
        case .granted:
            completion(true)
        @unknown default:
            displayAlert(message: "마이크 권한 설정 중 오류가 발생했습니다.")
        }
    }
    
    func recordBtnTapped() {
        selectedRecordedFile = nil
        
        if isPlaying {
            stopPlaying()
            startRecording()
        } else if isRecording {
            stopRecording()
        } else {
            startRecording()
        }
    }
    
    private func startRecording() {
        requestMicrophoneAccess { [weak self] allowed in
            guard let self = self else { return }
            guard AVAudioApplication.shared.recordPermission == .granted else {
                    // 마이크 권한이 허용되지 않은 경우에 대한 처리
                    displayAlert(message: "마이크 권한이 필요합니다.")
                    return
                }
            let audioSession = AVAudioSession.sharedInstance()
            trackDeletedFileNumber()
            let fileURL = getDocumentsDirectory()
                .appendingPathComponent("새로운 녹음 \(nextAvailableNumber).m4a")
            
            let settings = [
                AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                AVSampleRateKey: 12000,
                AVNumberOfChannelsKey: 1,
                AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
            ]
            
            do {
                try audioSession.setCategory(.playAndRecord)
                try audioSession.setActive(true)
                self.audioRecorder = try AVAudioRecorder(url: fileURL, settings: settings)
                self.audioRecorder?.record()
                self.isRecording = true
            } catch {
                displayAlert(message: "음성메모 녹음 중 오류가 발생했습니다.")
            }
        }
    }
    
    private func stopRecording() {
        audioRecorder?.stop()
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setActive(false)
        } catch {
            displayAlert(message: "음성메모 녹음 중지 중 오류가 발생했습니다.")
        }
        self.recordedFiles.append(self.audioRecorder!.url)
        self.isRecording = false
    }
    
    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    // 삭제된 파일 숫자 추적
    func trackDeletedFileNumber() {
        let existingNumbers = recordedFiles.compactMap { url -> Int? in
            let filename = url.lastPathComponent
            if let numberString = filename.components(separatedBy: " ").last?.replacingOccurrences(of: ".m4a", with: ""),
               let number = Int(numberString) {
                return number
            }
            return nil
        }
        
        if let maxNumber = existingNumbers.max() {
            nextAvailableNumber = maxNumber + 1
        }
    }
}

// MARK: - 재생 관련
extension VoiceViewModel {
    func startPlaying(recordingURL: URL) {
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.playAndRecord,
                                         options: [.allowAirPlay, .allowBluetooth, .defaultToSpeaker])
            try audioSession.setActive(true)
            print(audioSession.currentRoute)
            audioPlayer = try AVAudioPlayer(contentsOf: recordingURL)
            audioPlayer?.delegate = self
            audioPlayer?.play()
            self.isPlaying = true
            self.isPaused = false
            self.progressTimer = Timer.scheduledTimer(
                withTimeInterval: 0.1,
                repeats: true
            ) { _ in
                self.updateCurrentTime()
            }
        } catch {
            displayAlert(message: "음성메모 재생 중 오류가 발생했습니다.")
        }
    }
    
    private func updateCurrentTime() {
        self.playedTime = audioPlayer?.currentTime ?? 0
    }
    
    private func stopPlaying() {
        audioPlayer?.stop()
        playedTime = 0
        self.progressTimer?.invalidate()
        self.isPlaying = false
        self.isPaused = false
    }
    
    func pausePlaying() {
        audioPlayer?.pause()
        self.isPaused = true
    }
    
    func resumePlaying() {
        audioPlayer?.play()
        self.isPaused = false
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        self.isPlaying = false
        self.isPaused = false
    }
    
    func getFileInfo(for url: URL) -> (Date?, TimeInterval?) {
        let fileManager = FileManager.default
        var creationDate: Date?
        var duration: TimeInterval?
        
        do {
            let fileAttributes = try fileManager.attributesOfItem(atPath: url.path)
            creationDate = fileAttributes[.creationDate] as? Date
        } catch {
            displayAlert(message: "선택된 음성메모 파일 정보를 불러올 수 없습니다.")
        }
        
        do {
            let audioPlayer = try AVAudioPlayer(contentsOf: url)
            duration = audioPlayer.duration
        } catch {
            displayAlert(message: "선택된 음성메모 파일의 재생 시간을 불러올 수 없습니다.")
        }
        
        return (creationDate, duration)
    }
}

extension VoiceViewModel {
    func loadRecordedFiles() {
        // 1. 문서 디렉토리 경로를 가져옵니다.
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        do {
            // 2. 문서 디렉토리 내의 모든 파일을 가져옵니다.
            let files = try FileManager.default.contentsOfDirectory(at: documentsDirectory, includingPropertiesForKeys: nil)
            recordedFiles = files// m4a 확장자를 가진 파일만을 필터링합니다.
                .filter { $0.pathExtension == "m4a" }
                .sorted { (url1, url2) -> Bool in
                    // 파일 이름에서 숫자를 추출하여 비교
                    if let number1 = Int(url1.lastPathComponent.split(separator: " ").last ?? ""),
                       let number2 = Int(url2.lastPathComponent.split(separator: " ").last ?? "") {
                        return number1 < number2
                    } else {
                        // 숫자를 추출할 수 없는 경우, 파일 이름을 기준으로 비교
                        return url1.lastPathComponent < url2.lastPathComponent
                    }
                }
        } catch {
            // 4. 파일을 로드하는 과정에서 오류가 발생한 경우 오류 메시지를 출력합니다.
            print("Failed to load recorded files: \(error)")
        }
    }
}

