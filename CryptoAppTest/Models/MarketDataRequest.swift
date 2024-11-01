//
//  MarketDataRequest.swift
//  CryptoAppTest
//
//  Created by Alice Sharova on 01.11.2024.
//

import Foundation

struct MarketDataRequest: Codable {
    let type: String
        let id: String
        let instrumentId: String
        let provider: String
        let subscribe: Bool
        let kinds: [String]
    
    func toString() -> String? {
        guard let json = try? JSONEncoder().encode(self),
              let jsonString = String(data: json, encoding: .utf8) else {
            return nil
        }
        return jsonString
    }
    
    init(type: String = "l1-subscription", id: String = "1", instrumentId: String, provider: String = "simulation", subscribe: Bool, kinds: [String] = ["last"]) {
        self.type = type
        self.id = id
        self.instrumentId = instrumentId
        self.provider = provider
        self.subscribe = subscribe
        self.kinds = kinds
    }
}
