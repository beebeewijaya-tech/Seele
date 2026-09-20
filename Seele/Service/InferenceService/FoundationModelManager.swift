//
//  FoundationModelManager.swift
//  Seele
//
//  Created by Bee Wijaya on 20/09/26.
//

import Foundation
import FoundationModels

//@Generable
//struct Topic {
//    @Guide(description: "topics of what the actual speaker talking about, to elaborate what is this journal topics", .minimumCount(3), .maximumCount(7))
//    var topics: [String]
//}

actor FoundationModelManager<T: Sendable & Generable>: InferenceProtocol {
    private var session: LanguageModelSession?
    
    func prepare() async throws {
        let s = await LanguageModelSession(model: SystemLanguageModel.default, instructions: instructions)
        session = s
    }

    nonisolated func generate(prompt: String) async throws -> T? {
        guard let session = await session else { throw InferenceError.failedToInit }
//        
//        let topic = try await session.respond(
//                to: "Classify these voice notes as technical, study, or personal:\n\(prompt)",
//                generating: Topic.self,
//                options: GenerationOptions(samplingMode: .greedy)
//            ).content
//        
//        let topics = topic.topics.joined(separator: ", ")

        return try await session.respond(
            to: """
            Here is a transcript of me talking today. Write my journal entry.
            Notes:
            \(prompt)
            """,
            generating: T.self,
            options: GenerationOptions(temperature: 0.8)
        ).content
    }
}
