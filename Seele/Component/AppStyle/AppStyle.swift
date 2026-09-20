//
//  AppStyle.swift
//  Seele
//
//  Created by Bee Wijaya on 16/09/26.
//

import SwiftUI

enum AppStyle {
    case primary, secondary, tertiary
    
    var background: Color {
        switch self {
        case .primary:
            return Color("Primary")
        case .secondary:
            return Color("Secondary")
        case .tertiary:
            return Color("Tertiary")
        }
    }
    
    var foreground: Color {
        switch self {
        case .primary:
            return Color("TextPrimary")
        default:
            return Color("TextSecondary")
        }
    }
}

