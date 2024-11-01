//
//  SocketClientProtocol.swift
//  CryptoAppTest
//
//  Created by Alice Sharova on 01.11.2024.
//

import Foundation

protocol SocketClientProtocol {
    func connectTo()
    func sendCurrency(currency: MarketDataRequest)
    func observeMarketData(completionHandler: @escaping (MarketDataResponce?) -> ())
}
