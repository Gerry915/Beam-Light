//
//  NetworkingError.swift
//  Beam Light
//
//  Created by Gerry Gao on 16/2/2022.
//

public enum NetworkError: Error {
    case badURL(_ error: String)
    case apiError(code: Int, error: String)
    case invalidJSON(_ message: String, error: Error)
    case unauthorized(code: Int, error: String)
    case badRequest(code: Int, error: String)
    case serverError(code: Int, error: String)
    case noResponse(_ error: String)
    case unableToParseData(_ error: String)
    case unknown(code: Int, error: String)
}
