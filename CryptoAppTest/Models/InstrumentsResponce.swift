//
//  InstrumentsResponce.swift
//  CryptoAppTest
//
//  Created by Alice Sharova on 31.10.2024.
//

import Foundation

struct InstrumentsResponce: Decodable {
    let data: [Instrument]
}

struct Instrument: Decodable {
    let id: String
    let symbol: String
}
