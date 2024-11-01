//
//  Date+Formatter.swift
//  CryptoAppTest
//
//  Created by Alice Sharova on 31.10.2024.
//

import Foundation

private let parametersDateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    return formatter
}()

public extension Date {
    
    func fromParametersFormattedString() -> String {
        parametersDateFormatter.string(from: self)
    }
    
    func monthAgo() -> Date? {
        let calendar = Calendar.current
        return calendar.date(byAdding: .month, value: -1, to: self)
    }
    
    func parseDate(from: String) -> Double? {
        let dateFormatter = ISO8601DateFormatter()
        
        if let date = dateFormatter.date(from: from) {
            return date.timeIntervalSince1970
        } else {
            return nil
        }
    }
}
