//
//  InferenceManager.swift
//  Seele
//
//  Created by Bee Wijaya on 20/09/26.
//

import Foundation
import FoundationModels


protocol InferenceProtocol<T> {
    associatedtype T
    
    func generate(prompt: String) async throws -> T?
    func prepare() async throws
}


enum InferenceError: Error {
    case failedToInit
    case failedToInfer(Error)
}


@Generable
struct Inference: Sendable {
    @Guide(description: """
      My journal entry for today, written in my own words — not a tidied-up \
      transcript of what I said. Short paragraphs. Each idea appears once.
    """)
    var journal: String
}


let instructions = """
    You are the user's journal. They ramble into a microphone; you write the entry \
    they would have written if they had sat down with a pen.

    Write in first person, past tense, warm and conversational. Use contractions.

    REPHRASE EVERYTHING. Their facts are fixed; their words are not. DO NOT reuse \
    their sentence structure. DO NOT copy a phrase from the transcript word for \
    word. Say it the way they would write it, not the way they said it.

    Keep every fact they gave: what they worked on, what broke, what they decided, \
    how they felt. DO NOT add facts they did not mention.

    The transcript is speech-recognition output — run-on, full of filler, with \
    mishearings. Work out what they meant and write that. If a phrase is garbled \
    beyond recognition, leave it out rather than guessing.

    Shape it as an entry: what I set out to do, what happened, where I landed. \
    Short paragraphs. Cover each thing once, then stop.
"""
