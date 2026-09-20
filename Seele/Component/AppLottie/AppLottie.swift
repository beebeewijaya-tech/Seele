//
//  AppLottie.swift
//  Seele
//
//  Created by Bee Wijaya on 16/09/26.
//


import SwiftUI
import Lottie

enum LottieState {
    case normal, hearing, loading

    /// Frames, not progress — seele-seal.json grows when segments are added
    /// and progress ratios silently point somewhere else when it does.
    var mode: LottiePlaybackMode.PlaybackMode {
        switch self {
        case .normal:
            return .fromFrame(0, toFrame: 210, loopMode: .loop)
        case .hearing:
            return .fromFrame(252, toFrame: 420, loopMode: .loop)
        case .loading:
            return .fromFrame(420, toFrame: 600, loopMode: .loop)
        }
    }
}

struct AppLottie: View {
    var animation: String
    var animationType: LottieState = .normal
    
    var body: some View {
        LottieView(animation: .named(animation))
            .playing(animationType.mode)
    }
}

#Preview {
    AppLottie(animation: "seele-seal")
}
