//
//  CustomError.swift
//  CryptoAppTest
//
//  Created by Alice Sharova on 31.10.2024.
//

import Foundation

public enum CustomError: Error {

    case httpError(Int?, String?)
    case conflict(Int?, String?)
    case retry
    case resourceNotFound
    case unprocessable(Int?, String?)
    case unauthorized(Int?, String?)
    case forbidden(Int?, String?)
    
    init(statusCode: Int?, message: String? = nil) {
        
        switch statusCode {
        case 401:
            self = .unauthorized(statusCode, message)
        case 403:
            self = .forbidden(statusCode, message)
        case 404:
            self = .resourceNotFound
        case 409:
            self = .conflict(statusCode, message)
        case 422:
            self = .unprocessable(statusCode, message)
        case 449:
            self = .retry
        default:
            self = .httpError(statusCode, message)
        }
    }
}
