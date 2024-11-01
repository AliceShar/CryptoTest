//
//  ProvidersManager.swift
//  CryptoAppTest
//
//  Created by Alice Sharova on 30.10.2024.
//

import Foundation
import Alamofire

actor ProvidersManager {
    
    private let baseURL = "https://platform.fintacharts.com"
    private let userStorage: UserStorage = UserStorage.shared
    private let dateManager: DateManager = DateManager.shared
    
    private func makeRequest<T: Decodable>(url: String) async throws -> T {
        return try await withCheckedThrowingContinuation { continuation in
            AF.request(url, method: .get, headers: ["Authorization": "Bearer \(userStorage.getUserAccessToken() ?? "")"])
                .validate()
                .responseDecodable(of: T.self) { response in
                    switch response.result {
                    case .success(let decodedResponse):
                        continuation.resume(returning: decodedResponse)
                    case .failure(let error):
                        if let httpResponse = response.response {
                            let customError = CustomError(statusCode: httpResponse.statusCode, message: error.localizedDescription)
                            continuation.resume(throwing: customError)
                        } else {
                            continuation.resume(throwing: error)
                        }
                    }
                }
        }
    }
    
    func getInstruments() async throws -> InstrumentsResponce {
        let url = baseURL + "/api/instruments/v1/instruments?provider=simulation&kind=forex"
        return try await makeRequest(url: url)
    }
    
    func getHistoricalPrices(for currencyId: String) async throws -> CandleDataResponce {
        let url = baseURL + "/api/bars/v1/bars/date-range?instrumentId=\(currencyId)&provider=simulation&interval=1&periodicity=day&startDate=\(dateManager.getMonthDateAgoInString())&endDate=\(dateManager.getCurrentDateInString())"
        return try await makeRequest(url: url)
    }
}
