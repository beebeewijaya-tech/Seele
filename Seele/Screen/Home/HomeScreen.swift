//
//  HomeScreen.swift
//  Seele
//
//  Created by Bee Wijaya on 16/09/26.
//

import SwiftUI


struct HomeScreen: View {
    // MARK: - View Model
    @Environment(RecordingViewModel.self) private var recordingVM
    
    
    var body: some View {
        ZStack {
            Color("Primary")
                .ignoresSafeArea(.all)
            
            VStack {
                Spacer()
                AppLottie(animation: "seele-seal", animationType: recordingVM.state == .recording ? .hearing : .normal)
                
                Spacer()
                Button {
                    Task {
                        await recordingVM.toggleRecording()
                    }
                } label: {
                    ZStack {
                        Circle()
                            .fill(.red)
                            .frame(width: 120)
                        
                        Circle()
                            .fill(.white)
                            .frame(width: 110)
                        
                        Circle()
                            .fill(.red)
                            .frame(width: 100)
                        
                        if recordingVM.state == .recording {
                            Image(systemName: "pause.fill")
                                .foregroundStyle(.white)
                                .frame(width: 50)
                        }
                    }
                }
                .disabled(recordingVM.state == .processing)
            }
            .padding(.bottom, 20)
        }
    }
}

#Preview {
    HomeScreen()
        .environment(RecordingViewModel())
}
