//
//  SocketClient.swift
//  CryptoAppTest
//
//  Created by Alice Sharova on 29.10.2024.
//

import Foundation
import Starscream

final class SocketClient: WebSocketDelegate, SocketClientProtocol {
    
    typealias EventsHandlerCallback = (MarketDataResponce?) -> Void

    // MARK: - Private properties

    private var eventsQueue: DispatchQueue = .main
    private var eventsHandlerCallback: EventsHandlerCallback?
    private var socket: WebSocket?
    private let baseUrlString: String = "wss://platform.fintacharts.com"
    private let userStorage: UserStorage = UserStorage.shared
    private var isConnected: Bool = false
    
    // MARK: - Public methods

    func disconnect() {
        socket?.disconnect()
    }

    func setEventsHandler(callback: @escaping EventsHandlerCallback) {
        eventsHandlerCallback = callback
    }
    
    func connectTo() {
        guard let accessToken = userStorage.getUserAccessToken() else {
            return
        }
        
        let urlString = baseUrlString + "/api/streaming/ws/v1/realtime?token=\(accessToken)"
        
        guard let url = URL(string: urlString) else {
            return
        }
        
        var request = URLRequest(url: url)
        request.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        request.timeoutInterval = 5
        
        socket = WebSocket(request: request)
        socket?.delegate = self
        socket?.connect()
    }
    
    func sendCurrency(currency: MarketDataRequest) {
        guard let jsonString = currency.toString() else { return }
                
        socket?.write(string: jsonString)
    }
    
    func observeMarketData(completionHandler: @escaping (MarketDataResponce?) -> ()) {
        self.eventsHandlerCallback = completionHandler
    }

    // MARK: - WebSocketDelegate methods

    func didReceive(event: Starscream.WebSocketEvent, client: any Starscream.WebSocketClient) {
        switch event {
        case .connected(_):
            isConnected = true
        case .disconnected(_, _):
            isConnected = false
        case .text(let string):
            guard let marketDataMessage = MarketDataResponce.getMarketDataResponce(from: string) else { return }
            eventsHandlerCallback?(marketDataMessage)
        case .binary(_):
            break
        case .pong(_):
            break
        case .ping(_):
            break
        case .error(_):
            isConnected = false
        case .viabilityChanged(_):
            break
        case .reconnectSuggested(let bool):
            if bool {
                connectTo()
            }
        case .cancelled:
            isConnected = false
        case .peerClosed:
            break
        }
    }
    
    deinit {
        disconnect()
    }
}
