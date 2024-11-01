//
//  AuthTextField.swift
//  CryptoAppTest
//
//  Created by Alice Sharova on 30.10.2024.
//

import SwiftUI

struct AuthTextField: View {
    
    @Binding var text: String
    var focused: FocusState<Bool>.Binding
    var placeholder: String
    var placeholderImage: String
    var title: String
    var keyboardType: UIKeyboardType
    var isSecure: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            
            Text(title)
                .font(.subheadline)
                .foregroundStyle(Color.accentColor)
            
            HStack(spacing: 0) {
                Image(systemName: placeholderImage)
                    .foregroundStyle(Color.accentColor)
             
                hybridTextField()
                    .padding()
                    .font(.subheadline)
                    .textFieldStyle(.plain)
                    .foregroundStyle(Color.secondaryColor)
                    .keyboardType(keyboardType)
                    .focused(focused)
            }
        }
        .overlay(alignment: .bottom) {
            Rectangle().frame(height: 1)
                .foregroundColor(focused.wrappedValue ? Color.secondaryColor : Color.lightGray)
                .shadow(color: Color.secondaryColor, radius: focused.wrappedValue ? 5 : 0)
        }
    }
}

extension AuthTextField {
    
   private func hybridTextField() -> some View {
        if isSecure {
           return AnyView(SecureField(placeholder, text: $text, prompt: Text(placeholder).foregroundStyle(Color.secondaryColor)))
        } else {
           return AnyView(TextField(placeholder, text: $text, prompt: Text(placeholder).foregroundStyle(Color.secondaryColor)))
        }
        
    }
}
//
//#Preview {
//    @FocusState var isFocused: Bool
//    
//    return  AuthTextField(text: .constant("AlShar777"), focused: $isFocused, placeholder: "Username", placeholderImage: "Username", title: "Username", keyboardType: .emailAddress, isSecure: false)
//}
