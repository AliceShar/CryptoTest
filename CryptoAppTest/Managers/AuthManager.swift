//
//  AuthManager.swift
//  CryptoAppTest
//
//  Created by Alice Sharova on 30.10.2024.
//

import Foundation
import Alamofire

actor AuthManager {
    
    private var baseURL = "https://platform.fintacharts.com"
    
    func login(request: LoginRequest) async throws -> TokenResponce {
        let url = baseURL + "/identity/realms/fintatech/protocol/openid-connect/token"
        
        return try await withCheckedThrowingContinuation { continuation in
            AF.request(url, method: .post, parameters: request.parameters(), encoding: URLEncoding.default)
                .validate()
                .responseDecodable(of: TokenResponce.self) { response in
                    switch response.result {
                    case .success(let tokenResponse):
                        continuation.resume(returning: tokenResponse)
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
}
