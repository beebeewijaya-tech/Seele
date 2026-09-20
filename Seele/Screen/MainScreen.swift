//
//  MainScreen.swift
//  Seele
//
//  Created by Bee Wijaya on 20/09/26.
//

import SwiftUI


struct MainScreen: View {
    // MARK: - ViewModel
    @State private var recordingVM: RecordingViewModel = RecordingViewModel()
    
    
    var body: some View {
        NavigationStack {
            TabView {
                Tab("Home", systemImage: "bubble.fill") {
                    HomeScreen()
                }
                
                Tab("Journals", systemImage: "book.pages") {
                    
                }
            }
            .environment(recordingVM)
        }
    }
}

#Preview {
    MainScreen()
}
