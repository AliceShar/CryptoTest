//
//  View+Extension.swift
//  CryptoAppTest
//
//  Created by Alice Sharova on 30.10.2024.
//

import Foundation
import SwiftUI

extension View {
    
    func withDefaultTextFormatting(textSixe: TextSize, isBold: Bool, color: Color = Color.accentColor) -> some View {
        modifier(DefaultTextViewModifier(size: textSixe, bold: isBold, color: color))
    }
}
