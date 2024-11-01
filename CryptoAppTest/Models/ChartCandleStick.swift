//
//  ChartCandleStick.swift
//  CryptoAppTest
//
//  Created by Alice Sharova on 31.10.2024.
//

import Foundation

struct CandleStick: Identifiable {
    var id = UUID().uuidString
    var open: Double
    var high: Double
    var low: Double
    var close: Double
    var volume: Int
    var date: Date? = nil
}
