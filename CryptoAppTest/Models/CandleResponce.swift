//
//  CandleResponse.swift
//  CryptoAppTest
//
//  Created by Alice Sharova on 31.10.2024.
//

import Foundation

struct CandleDataResponce: Decodable {
    let data: [Candle]
}

struct Candle: Decodable {
    let t: String
    let o: Double
    let h: Double
    let l: Double
    let c: Double
    let v: Int
}
