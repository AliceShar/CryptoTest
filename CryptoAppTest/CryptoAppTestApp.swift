//
//  CryptoAppTestApp.swift
//  CryptoAppTest
//
//  Created by Alice Sharova on 29.10.2024.
//

import SwiftUI

@main
struct CryptoAppTestApp: App {

    let authManager = AuthManager()
    let providersManager = ProvidersManager()
    let socketClient = SocketClient()
    
    var body: some Scene {
        WindowGroup {
            MainView(authManager: authManager, providersManager: providersManager, socketClient: socketClient)
        }
    }
}
