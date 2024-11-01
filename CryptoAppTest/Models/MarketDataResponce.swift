//
//  MarketDataResponce.swift
//  CryptoAppTest
//
//  Created by Alice Sharova on 01.11.2024.
//

import Foundation

struct MarketDataResponce: Codable {
    let type: String
    let instrumentId: String
    let provider: String
    let last: LastPrice
    
    struct LastPrice: Codable {
        let timestamp: String
        let price: Double
        let volume: Int
        let change: Double
        let changePct: Double
    }
    
    static func getMarketDataResponce(from text: String) -> MarketDataResponce? {
        guard let data = text.data(using: .utf8),
              let marketResponce = try? JSONDecoder().decode(MarketDataResponce.self, from: data)
        else {
            return nil
        }
        return marketResponce
    }
}
