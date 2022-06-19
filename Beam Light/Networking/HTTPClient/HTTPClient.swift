//
//  HTTPClient.swift
//  Beam Light
//
//  Created by Gerry Gao on 5/6/2022.
//

import Foundation

protocol HTTPClient {
	func execute<T: Codable>(endpoint: Endpoint) async -> Result<T, NetworkError>
}

extension HTTPClient {
	
	func execute<T: Codable>(endpoint: Endpoint) async -> Result<T, NetworkError> {
		
		guard let request = try? endpoint.composeRequest() else {
			return .failure(NetworkError.badRequest(error: "Cannot compose request"))
		}
		
		guard let (data, response) = try? await URLSession.shared.data(for: request) else {
			return .failure(NetworkError.badURL("Cannot send Request"))
		}
		
		guard let response = response as? HTTPURLResponse else {
			return .failure(NetworkError.badRequest(error: "No response"))
		}
		
		switch response.statusCode {
		case 200...299:
			guard let data = try? JSONDecoder().decode(T.self, from: data) else {
				return .failure(.invalidJSON("InvalidJSON"))
			}
			return .success(data)
		case 401:
			return .failure(.unauthorized(error: "Unauthorized"))
		case 404:
			return .failure(.noResponse("404"))
		case 500:
			return .failure(.serverError(error: "500"))
		default:
			return .failure(.unknown(error: "Unknown Error"))
		}
	}
}
