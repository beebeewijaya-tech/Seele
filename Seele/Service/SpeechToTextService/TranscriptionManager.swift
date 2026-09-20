//
//  TranscriptionManager.swift
//  Seele
//
//  Created by Bee Wijaya on 20/09/26.
//

import AVFoundation
import Foundation
import Speech


enum TranscriptionError: Error {
    case failedToInitialized
    case failedToTranscribe(String)
}

class TranscriptionManager {
    var recognizer: SFSpeechRecognizer?
    var request: SFSpeechAudioBufferRecognitionRequest?
    var task: SFSpeechRecognitionTask?
    var permission: Bool = false
    
    func requestTranscribePermission() async -> Bool {
        let status = await withCheckedContinuation { continuation in
            SFSpeechRecognizer.requestAuthorization { status in
                continuation.resume(returning: status)
            }
        }
        
        return status == .authorized
    }
    
    
    func startTranscription(onResult: @escaping (Result<(String, Bool), Error>) -> Void) throws {
        if recognizer == nil {
            recognizer = SFSpeechRecognizer()
        }
        
        guard let recognizer, recognizer.isAvailable else {
            throw TranscriptionError.failedToInitialized
        }
        
        request = SFSpeechAudioBufferRecognitionRequest()
        request?.shouldReportPartialResults = true
        request?.addsPunctuation = true
        // Biases recognition toward vocabulary it otherwise mangles. Each entry below
        // was actually misheard in a real recording — the mishearing is in the comment.
        request?.contextualStrings = [
            // project + product names
            "Seele",
            "CoreAI"
            "Core AI",
            "Qwen",
            "Lottie",
            "SwiftUI",
            "Swift",
            "Xcode",
            "Foundation Models",
            "FoundationModels",
            "SystemLanguageModel",
            "LanguageModelSession",
            "AVFoundation",
            "SFSpeechRecognizer",
            "SpeechAnalyzer",
            "Apple Intelligence",
            "Neural Engine",
            "Mac Catalyst",
            "LLM",
            "on-device",
            "inference",
            "transcription",
            "speech to text",
            "guided generation",
            "Generable",
            "import error",
            "memory leak",
            "simulator",
            "microcontroller",
            "ViewModel",
        ]
        
        self.task = recognizer.recognitionTask(with: request!) { res, err in
            if err != nil {
                onResult(.failure(err!))
                return
            }
            
            guard let res else { return }
            onResult(.success((res.bestTranscription.formattedString, res.isFinal)))
        }
    }
    
    func processAudioBuffer(_ buffer: AVReadOnlyAudioPCMBuffer) {
        request?.append(AVAudioPCMBuffer(copying: buffer))
    }
    
    func stopTranscription() {
        request?.endAudio()
    }
}
