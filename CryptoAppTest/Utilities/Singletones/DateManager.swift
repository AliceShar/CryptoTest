//
//  DateManager.swift
//  CryptoAppTest
//
//  Created by Alice Sharova on 31.10.2024.
//

import Foundation

public class DateManager {
    
    // MARK: - Singltone
    public static let shared = DateManager()
    
    // MARK: - Init
    private init() {}
    
    func getCurrentDateInString() -> String {
        let date = Date()
        return date.fromParametersFormattedString()
    }
    
    func getMonthDateAgoInString() -> String {
        let date = Date()
        if let monthDateAgo = date.monthAgo() {
            return monthDateAgo.fromParametersFormattedString()
        }
        return ""
    }
    
}
