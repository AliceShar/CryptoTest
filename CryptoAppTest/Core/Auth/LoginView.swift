//
//  LoginView.swift
//  CryptoAppTest
//
//  Created by Alice Sharova on 30.10.2024.
//

import SwiftUI
import AlertToast

struct LoginView: View {
    
    @EnvironmentObject var authVM: LoginViewModel
    @FocusState private var emailFocused: Bool
    @FocusState private var passwordFocused: Bool
    
    var body: some View {
        ZStack {
            Color.primaryColor.ignoresSafeArea()
            
            GeometryReader { geo in
                ScrollView(showsIndicators: false) {
                    VStack {
                        
                        Text("Sign In")
                            .withDefaultTextFormatting(textSixe: .large, isBold: true)
                            .padding(.top, 50)
                        
                        singInSection
                       
                    }
                    .padding()
                    .frame(minHeight: geo.size.height)
                }
                .onTapGesture {
                    UIApplication.shared.endEditing()
                }
                .frame(width: geo.size.width)
            }
        }
        .toolbar(.hidden, for: .navigationBar)
        .onDisappear {
            authVM.clearTextfields()
        }
        .toast(
            isPresenting: $authVM.alertIsShown,
            duration: 2,
            offsetY: CGFloat(signOf: 0, magnitudeOf: -10)
        ){
            authVM.alertToast
        }
    }
}

extension LoginView {
    
    private var singInSection: some View {
        VStack {
            AuthTextField(text: $authVM.email, focused: $emailFocused, placeholder: "Type your email", placeholderImage: "person", title: "Email", keyboardType: .emailAddress, isSecure: false)
                .padding(.bottom)

            AuthTextField(text: $authVM.password, focused: $passwordFocused, placeholder: "Type your password", placeholderImage: "lock", title: "Password", keyboardType: .default, isSecure: true)
            
            PrimaryButton(title: "Sign In", action: {
                authVM.signIn()
            }, isLoading: $authVM.isLoading)
            .padding(.top, 40)
           
        }
        .padding([.top, .bottom], 60)
    }
}


#Preview {
    LoginView()
}
