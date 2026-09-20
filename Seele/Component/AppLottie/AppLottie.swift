//
//  AppLottie.swift
//  Seele
//
//  Created by Bee Wijaya on 16/09/26.
//


import SwiftUI
import Lottie

enum LottieState {
    case normal, hearing
    
    var mode: LottiePlaybackMode.PlaybackMode {
        switch self {
        case .normal:
            return .fromProgress(0, toProgress: 0.5, loopMode: .loop)
        case .hearing:
            return .fromProgress(0.6, toProgress: 1, loopMode: .loop)
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
