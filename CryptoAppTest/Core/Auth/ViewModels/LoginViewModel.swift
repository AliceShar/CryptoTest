//
//  LoginVM.swift
//  CryptoAppTest
//
//  Created by Alice Sharova on 30.10.2024.
//

import Foundation
import AlertToast
import SwiftUI

final class LoginViewModel: ObservableObject {
    
    // MARK: - Managers
    var authManager: AuthManager
    
    // MARK: - Singletone
    private let userStorage: UserStorage = UserStorage.shared

    // MARK: Published properties
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var alertIsShown: Bool = false
    @Published private(set) var userIsLoggedIn = false
    @Published var isLoading: Bool = false
    @Published private(set) var alertToast = AlertToast(displayMode: .hud, type: .regular)
    
    // MARK: - Init
    init(authManager: AuthManager) {
        self.authManager = authManager
    }
    
    // MARK: - Functions
    func signIn() {
           guard !email.isEmpty, !password.isEmpty else {
               alertIsShown.toggle()
               alertToast = createToast(text: "Fields must not be empty")
               return
           }
        Task {
            await MainActor.run {
                isLoading = true
            }
               do {
                   let loginRequest = LoginRequest(email: email, password: password)
                   let tokenResponse = try await authManager.login(request: loginRequest)
                   
                   if let accessToken = tokenResponse.accessToken, let refreshToken = tokenResponse.refreshToken {
                       userStorage.setUserAccessToken(for: accessToken)
                       userStorage.setUserRefreshToken(for: refreshToken)
                       userStorage.setUserIsLoggedIn()
                   } else {
                       await MainActor.run {
                           showToast("Error getting data")
                       }
                   }
                   
               } catch let error {
                   await MainActor.run {
                       showToast(error.localizedDescription)
                   }
               }
               await MainActor.run {
                   isLoading = false
               }
           }
       }
    
    private func showToast(_ message: String) {
        Task { @MainActor in
            alertIsShown.toggle()
            alertToast = createToast(text: message)
        }
    }
    
    func clearTextfields() {
        if !email.isEmpty || !password.isEmpty {
            email = ""
            password = ""
        }
    }
    
    private func createToast(text: String) -> AlertToast {
        AlertToast(displayMode: .hud, type: .regular, subTitle: text, style: .style(backgroundColor: Color.accentColor, subTitleColor: Color.primaryColor, titleFont: .caption))
    }
    
}
