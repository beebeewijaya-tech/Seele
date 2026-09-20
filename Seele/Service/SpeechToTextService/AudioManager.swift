
//
//  AudioManager.swift
//  Seele
//
//  Created by Bee Wijaya on 20/09/26.
//

import Foundation
import AVFoundation


class AudioManager {
    private let audioEngine = AVAudioEngine()
    private var audioTapInstalled = false
    
    
    func setupAudioSession() async throws {
        let audioSession = AVAudioSession.sharedInstance()
        try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
        try await audioSession.activate()
    }
    
    
    func requestAudioPermission() async -> Bool {
        await withCheckedContinuation { continuation in
            AVAudioApplication.requestRecordPermission { granted in
                continuation.resume(returning: granted)
            }
        }
    }
    
    func startAudioStream(onBuffer: @escaping (AVReadOnlyAudioPCMBuffer) -> Void) throws {
        guard !audioTapInstalled else { return }
        
        try audioEngine.inputNode.installAudioTap(
            onBus: 0,
            bufferSize: 4096,
            format: audioEngine.inputNode.inputFormat(forBus: 0)
        ) { buffer, _ in
            onBuffer(buffer)
        }
        
        audioEngine.prepare()
        try audioEngine.start()
        audioTapInstalled = true
    }
    
    
    func stopAudioStream() {
        guard audioTapInstalled else { return }
        
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)
        audioTapInstalled = false
    }
}
