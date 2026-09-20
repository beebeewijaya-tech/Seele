//
//  RecordingViewModel.swift
//  Seele
//
//  Created by Bee Wijaya on 20/09/26.
//

import SwiftUI

enum RecordingState: Equatable {
    case idle
    case recording
    case processing
    case error(String)
}


@Observable
class RecordingViewModel {
    private(set) var state: RecordingState = .idle
    private var audioManager = AudioManager()
    private var transcriptionManager = TranscriptionManager()
    private(set) var currentText = ""
    private(set) var result: [String] = []
    private var inferenceManager: any InferenceProtocol<Inference>
    
    init(inferenceManager: any InferenceProtocol<Inference> = FoundationModelManager()) {
        self.inferenceManager = inferenceManager
    }
    
    
    // MARK: - props
    private(set) var journal: Inference?
    
    
    // MARK: - Outside function
    
    var lottieState: LottieState {
        switch state {
        case .recording: .hearing
        case .processing: .loading
        default: .normal
        }
    }

    func setState(_ s: RecordingState) {
        self.state = s
    }
    
    func requestPermission() async -> Bool {
        let audioPermission = await audioManager.requestAudioPermission()
        let transcriptionPermission = await transcriptionManager.requestTranscribePermission()
        
        return audioPermission && transcriptionPermission
    }
    
    func toggleRecording() async {
        do {
            if state == .idle {
                await startRecording()
            } else {
                try await stopRecording()
            }
        } catch {
            state = .error(error.localizedDescription)
        }
    }
    
    
    func getCurrentOrResultText() -> String {
        let res = result.joined()

        if res != "" || currentText != "" {
            return res + currentText
        }
        
        return ""
    }
    
    func inference() async {
        state = .processing
        do {
            let res = result.joined()
            journal = try await inferenceManager.generate(prompt: res)
            state = .idle
            result.removeAll()
            print(journal)
        } catch {
            print(error)
        }
    }
    
    
    // MARK: - Internal function
    
    private func startRecording() async {
        guard state == .idle else { return }
        setState(.recording)
        
        guard await requestPermission() else {
            state = .error("Failed to get permission!")
            return
        }
        
        do {
            try await inferenceManager.prepare()
            try await audioManager.setupAudioSession()
            try transcriptionManager.startTranscription { [weak self] result in
                guard let self = self else { return }
                
                switch result {
                case .success(let (value, isFinal)):
                    if isFinal {
                        self.result.append(value + " ")
                        currentText = ""
                        state = .idle
                    } else {
                        self.currentText = value
                    }
                case .failure(let err):
                    state = .error(err.localizedDescription)
                    break
                }
            }
            
            try audioManager.startAudioStream { [weak self] buffer in
                guard let self = self else { return }
                self.transcriptionManager.processAudioBuffer(buffer)
            }
        } catch {
            state = .error(error.localizedDescription)
        }
    }
    
    
    private func stopRecording() async throws {
        try await audioManager.stopAudioStream()
        transcriptionManager.stopTranscription()
        state = .idle
    }
}
