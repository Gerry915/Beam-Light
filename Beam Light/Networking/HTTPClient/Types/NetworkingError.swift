//
//  NetworkingError.swift
//  Beam Light
//
//  Created by Gerry Gao on 16/2/2022.
//

public enum NetworkError: Error {
    case badURL(_ error: String)
    case apiError(error: String)
    case invalidJSON(_ message: String)
    case unauthorized(error: String)
    case badRequest(error: String)
    case serverError(error: String)
    case noResponse(_ error: String)
    case unableToParseData(_ error: String)
    case unknown(error: String)
}
