//
//  ProvidersViewModel.swift
//  CryptoAppTest
//
//  Created by Alice Sharova on 30.10.2024.
//

import Foundation
import AlertToast
import SwiftUI
import Combine

final class ProvidersViewModel: ObservableObject {
    
    var providersManager: ProvidersManager
    var socketClient: SocketClient
    var networkMonitor: NetworkMonitor
    
    private let userStorage: UserStorage = UserStorage.shared
    private var previousSelectedCurrency: Instrument? = nil
    private var cancellables: Set<AnyCancellable> = []
    
    @Published var cannotSelectCurrency: Bool = false
    @Published var providersIsLoading: Bool = true
    @Published var pricesIsLoading: Bool = true
    @Published var marketDataIsLoading: Bool = false
    @Published var alertIsShown: Bool = false
    @Published private(set) var alertToast = AlertToast(displayMode: .hud, type: .regular)
    @Published private(set) var providers: [Instrument]? = nil {
        didSet {
            if selectedCurrency == nil {
                selectedCurrency = providers?.first
            }
        }
    }
    @Published private(set) var historicalPricesOfObject: [CandleStick] = []
    
    @Published var selectedCurrency: Instrument? = nil {
        didSet {
            if selectedCurrency != nil {
                getHistoricalPrices()
            }
            if selectedCurrency?.id != previousSelectedCurrency?.id || previousSelectedCurrency == nil {
                previousSelectedCurrency = oldValue
            }
        }
    }
    
    @Published var recievedCurrencyData: MarketDataResponce? = nil
    
    init(providersManager: ProvidersManager, socketClient: SocketClient, networkMonitor: NetworkMonitor) {
        self.providersManager = providersManager
        self.socketClient = socketClient
        self.networkMonitor = networkMonitor
    }
    
    func connectSocket() {
        socketClient.connectTo()
        socketClient.observeMarketData { [weak self] marketData in
            guard let marketData = marketData else { return }
            self?.recievedCurrencyData = marketData
            self?.marketDataIsLoading = false
        }
    }
    
    func getProviders() {
        Task {
            await MainActor.run {
                providersIsLoading = true
            }
            
            do {
                let providers = try await providersManager.getInstruments()
                await MainActor.run {
                    self.providers = providers.data
                }
                getHistoricalPrices()
                
            } catch let error as CustomError {
                switch error {
                case .unauthorized(_, _):
                    await refreshTokenAndRetry()
                    
                default:
                    showToast(error.localizedDescription)
                }
            } catch {
                    showToast(error.localizedDescription)
            }

            await MainActor.run {
                providersIsLoading = false
            }
        }
    }
    
    func getMarketData() {
        marketDataIsLoading = true
        guard let selectedCurrency = selectedCurrency else { return }
        
        if let previousCurrency = previousSelectedCurrency, previousCurrency.id != selectedCurrency.id {
            let unsubscribePreviousCurrency = MarketDataRequest(instrumentId: previousCurrency.id, subscribe: false)
            socketClient.sendCurrency(currency: unsubscribePreviousCurrency)
        }
        
        let newSelectedCurrency = MarketDataRequest(instrumentId: selectedCurrency.id, subscribe: true)
        socketClient.sendCurrency(currency: newSelectedCurrency)
    }
    
    func configureObservers() {
        $marketDataIsLoading
            .combineLatest(networkMonitor.$isConnected)
            .map { $0 || !$1 }
            .sink { [weak self] cannotSelectCurrency in
                self?.cannotSelectCurrency = cannotSelectCurrency
            }
            .store(in: &cancellables)
        
        networkMonitor.$isConnected
            .sink { [weak self] bool in
                if self?.providers == nil {
                    self?.getProviders()
                }
            }
            .store(in: &cancellables)
    }
    
    func unsubscribeFromObservers() {
            cancellables.removeAll()
    }
    
    private func getHistoricalPrices() {
        guard let selectedCurrency = selectedCurrency else {
            showToast("You should select currency")
            return
        }
        Task {
            await MainActor.run {
                pricesIsLoading = true
            }
            
            do {
                let prices = try await providersManager.getHistoricalPrices(for: selectedCurrency.id)
                await MainActor.run {
                    historicalPricesOfObject = prices.data.map({CandleStick(open: $0.o, high: $0.h, low: $0.l, close: $0.c, volume: $0.v, date: $0.t.parseDate())})
                    getMarketData()
                }
                
            } catch let error as CustomError {
                switch error {
                case .unauthorized(_, _):
                    await refreshTokenAndRetry()
                    
                default:
                    showToast(error.localizedDescription)
                }
                print(error.localizedDescription)
            } catch {
                showToast(error.localizedDescription)
            }

            await MainActor.run {
                pricesIsLoading = false
            }
        }
    }
    private func showToast(_ message: String) {
        Task { @MainActor in
            alertIsShown.toggle()
            alertToast = createToast(text: message)
        }
    }

    private func refreshTokenAndRetry() async {
        guard let _ = userStorage.getUserAccessToken() else {
            signOut()
            socketClient.disconnect()
            return
        }
        do {
            let refreshToken = userStorage.getUserRefreshToken() ?? ""
            userStorage.setUserAccessToken(for: refreshToken)
            userStorage.deleteUserRefreshToken()
            _ = try await providersManager.getInstruments()
        } catch {
          signOut()
          socketClient.disconnect()
        }
    }
    
    private func signOut() {
        userStorage.deleteUserIsLoggedIn()
    }
    
    private func createToast(text: String) -> AlertToast {
        AlertToast(displayMode: .hud, type: .regular, subTitle: text, style: .style(backgroundColor: Color.accentColor, subTitleColor: Color.primaryColor, titleFont: .caption))
    }
}
