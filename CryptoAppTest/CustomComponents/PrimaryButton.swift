//
//  PrimaryButton.swift
//  CryptoAppTest
//
//  Created by Alice Sharova on 30.10.2024.
//

import SwiftUI

struct PrimaryButton: View {
    let title: String
    var action: () -> Void
    @Binding var isLoading: Bool
    var isDestructive: Bool = false
    
    var body: some View {
        Button {
            action()
        } label: {
            Text(title).opacity(isLoading ? 0 : 100)
                .foregroundStyle(Color.primaryColor)
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .font(.headline)
                .multilineTextAlignment(.center)
        }
        .buttonStyle(MyButtonStyle(isDestructive: isDestructive))
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .overlay {
            if isLoading {
                ProgressView()
                    .tint(Color.primaryColor)
            }
        }

    }
}

fileprivate struct MyButtonStyle: ButtonStyle {
    
    let isDestructive: Bool

  func makeBody(configuration: Self.Configuration) -> some View {
    configuration.label
          .background(isDestructive ? (configuration.isPressed ? Color.redColor : Color.redColor) :
            (configuration.isPressed ? Color.secondaryColor : Color.accentColor))
  }
}


#Preview {
    PrimaryButton(title: "Button", action: {}, isLoading: .constant(false), isDestructive: true)
}
