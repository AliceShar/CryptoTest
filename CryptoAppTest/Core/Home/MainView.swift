//
//  MainView.swift
//  CryptoAppTest
//
//  Created by Alice Sharova on 30.10.2024.
//

import SwiftUI

struct MainView: View {
    
    @AppStorage("3ts8nkXQqr") private var isUserLoggedIn: Bool?
    
    @StateObject private var authVM: LoginViewModel
    @StateObject private var providersVM: ProvidersViewModel
    
    init(authManager: AuthManager, providersManager: ProvidersManager, socketClient: SocketClient) {
        _authVM = StateObject(wrappedValue: LoginViewModel(authManager: authManager))
        _providersVM = StateObject(wrappedValue: ProvidersViewModel(providersManager: providersManager, socketClient: socketClient))
    }
    
    var body: some View {
        ZStack {
            Color.primaryColor.ignoresSafeArea()
            
        if isUserLoggedIn != nil && isUserLoggedIn == true {
                HomeView()
            }
            else {
                LoginView()
            }
            
        }
        .environmentObject(authVM)
        .environmentObject(providersVM)
    }
}

//#Preview {
//    MainView()
//}
