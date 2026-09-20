//
//  InferenceManager.swift
//  Seele
//
//  Created by Bee Wijaya on 20/09/26.
//

import CoreAI
import Foundation
import FoundationModels
import CoreAILanguageModels


protocol InferenceProtocol<T> {
    associatedtype T
    
    func generate(prompt: String) async throws -> T?
}


enum InferenceError: Error {
    case failedToInit
    case failedToInfer(Error)
}


@Generable
struct Inference: Sendable {
    @Guide(description: "Journal response rephrases with a better word and clearer")
    var journal: String
}

actor InferenceManager<T: Sendable & Generable>: InferenceProtocol {
    private var session: LanguageModelSession?
    
    func prepare() async throws {
        print("hello world, tt")

        guard session == nil else { return }
        
        print("hello world, tt2")

        guard let modelUrl = Bundle.main.url(forResource: "qwen3_0_6b_4bit_dynamic", withExtension: nil) else {
            print("hello world, model not fuoun")
            throw InferenceError.failedToInit
        }
        
        let model = try await CoreAILanguageModel(resourcesAt: modelUrl, mode: .eager)
        session = LanguageModelSession(model: model, instructions: "Write journal based on the prompt i gave you, care about the language to use not too stiff language")
    }
    
    nonisolated func generate(prompt: String) async throws -> T? {
        try await prepare()
        return try await session?.respond(
            to: prompt,
            generating: T.self
        ).content
    }
}
