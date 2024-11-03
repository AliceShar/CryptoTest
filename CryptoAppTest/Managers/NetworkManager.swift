//
//  NetworkManager.swift
//  CryptoAppTest
//
//  Created by Alice Sharova on 03.11.2024.
//

import Foundation
import Network

final class NetworkMonitor: ObservableObject {
    
    private var monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "Monitor")
     
    @Published var isConnected = true
     
    init() {
        monitor.pathUpdateHandler =  { [weak self] path in
            DispatchQueue.main.async {
                self?.isConnected = path.status == .satisfied ? true : false
            }
        }
        monitor.start(queue: queue)
    }
    
    func stopNetworkMonitoring() {
        monitor.cancel()
    }
}
