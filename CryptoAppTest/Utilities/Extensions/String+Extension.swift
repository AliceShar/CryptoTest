//
//  String+Extension.swift
//  CryptoAppTest
//
//  Created by Alice Sharova on 31.10.2024.
//

import Foundation

extension String {
    
    func parseDate() -> Date {
        let formatter = ISO8601DateFormatter()
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        return formatter.date(from: self) ?? Date()
    }
    
    func parseToDateString() -> String {
        let isoFormatter = DateFormatter()
        isoFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSSZ"
        isoFormatter.timeZone = TimeZone(secondsFromGMT: 0)
  
        guard let date = isoFormatter.date(from: self) else {
            return self
        }
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "MMM d, h:mm a"
        outputFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        
        return outputFormatter.string(from: date)
    }
    
}
