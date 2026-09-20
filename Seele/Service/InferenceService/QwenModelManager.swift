//
//  QwenModelManager.swift
//  Seele
//
//  Created by Bee Wijaya on 20/09/26.
//

//import CoreAI
//import Foundation
//import FoundationModels
//import CoreAILanguageModels
//
//actor QwenAIManager<T: Sendable & Generable>: InferenceProtocol {
//    private var session: LanguageModelSession?
//    let instructions = """
//        You rewrite the user's messy spoken notes into their personal journal entry, you rephrase it, into the actual words
//
//        Voice: first person, past tense, warm and conversational. Use contractions.
//
//        Content: use only facts the user stated. Never invent people, places, numbers, \
//        or outcomes. Keep technical names exactly as spoken.
//
//        Say each thing once. When you have covered what they said, stop writing. \
//        Repeating an idea in different words is the worst thing you can do.
//    """
//    
//    func prepare() async throws {
//        guard session == nil else { return }
//        guard let modelUrl = Bundle.main.url(forResource: "qwen3_0_6b_4bit_dynamic", withExtension: nil) else {
//            throw InferenceError.failedToInit
//        }
//        
//        let model = try await CoreAILanguageModel(resourcesAt: modelUrl, mode: .eager)
//        session = LanguageModelSession(model: model, instructions: instructions)
//    }
//    
//    nonisolated func generate(prompt: String) async throws -> T? {
//        try await prepare()
//        return try await session?.respond(
//            to: prompt,
//            generating: T.self,
//            options: GenerationOptions(temperature: 0.7, maximumResponseTokens: 300)
//        ).content
//    }
//}

