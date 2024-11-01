//
//  LoginRequest.swift
//  CryptoAppTest
//
//  Created by Alice Sharova on 30.10.2024.
//

import Foundation

public struct LoginRequest {
    let email: String
    let password: String
    
    public init(email: String, password: String) {
        self.email = email
        self.password = password
    }
    
    func parameters() -> [String: Any] {
        [
            "username": email,
            "password": password,
            "client_id": "app-cli",
            "grant_type": "password"
        ]
    }
}
