//
//  AppButton.swift
//  Seele
//
//  Created by Bee Wijaya on 16/09/26.
//

import SwiftUI


struct AppButton: View {
    var label: String
    var style: AppStyle = .primary
    var action: () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            VStack {
                Text(label)
                    .foregroundStyle(style.foreground)
                    .font(.body)
                    .bold()
            }
            .padding()
            .frame(maxWidth: .infinity)
            .frame(height: 60)
            .background(style.background)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .shadow(color: style.background.opacity(0.5), radius: 10, x: 0, y: 2)
        }
    }
}

#Preview {
    VStack {
        AppButton(label: "Submit") {
            
        }
    }
    .padding()
}
