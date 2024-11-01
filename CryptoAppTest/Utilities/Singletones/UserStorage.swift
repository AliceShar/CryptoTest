//
//  UserStorage.swift
//  CryptoAppTest
//
//  Created by Alice Sharova on 30.10.2024.
//

import Foundation

public class UserStorage {
    
    // MARK: - Singltone
    public static let shared = UserStorage()
    
    // MARK: - Init
    private init() {}
    
    private let userDefaults = UserDefaults.standard
    
    // MARK: - Functions
    func setUserAccessToken(for token: String) -> Void {
        userDefaults.setValue(token, forKey: UserDefaultsKey.accessToken)
    }
    func setUserRefreshToken(for token: String) -> Void {
        userDefaults.setValue(token, forKey: UserDefaultsKey.refreshToken)
    }
    func deleteUserRefreshToken() -> Void {
        userDefaults.removeObject(forKey: UserDefaultsKey.refreshToken)
    }
    func setUserIsLoggedIn() -> Void {
        userDefaults.setValue(true, forKey: UserDefaultsKey.isUserLoggedIn)
    }
    func deleteUserIsLoggedIn() -> Void {
        userDefaults.setValue(false, forKey: UserDefaultsKey.isUserLoggedIn)
    }
    func getUserAccessToken() -> String? {
        userDefaults.string(forKey: UserDefaultsKey.accessToken)
    }
    func getUserRefreshToken() -> String? {
        userDefaults.string(forKey: UserDefaultsKey.refreshToken)
    }
}

private extension UserStorage {
    
    private enum UserDefaultsKey {
        static let accessToken = "cxLqqifpi6"
        static let refreshToken = "JaApt7rGDv"
        static let isUserLoggedIn = "3ts8nkXQqr"
    }
}
