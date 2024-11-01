//
//  DefaultTextModifier.swift
//  CryptoAppTest
//
//  Created by Alice Sharova on 30.10.2024.
//

import Foundation
import SwiftUI

struct DefaultTextViewModifier: ViewModifier {
    
    let size: TextSize
    let bold: Bool
    let color: Color
    
    func body(content: Content) -> some View {
        content
            .foregroundStyle(color)
            .font(selectFont(for: size))
            .bold(bold)
    }
    
    private func selectFont(for size: TextSize) -> Font {
        switch size {
        case .large:
            return .largeTitle
        case .headline:
            return .headline
        case .subheadline:
            return .subheadline
        }
    }
    
}
