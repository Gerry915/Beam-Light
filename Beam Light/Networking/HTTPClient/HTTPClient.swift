//
//  HTTPClient.swift
//  Beam Light
//
//  Created by Gerry Gao on 5/6/2022.
//

import Foundation

protocol HTTPClient {
	
	associatedtype ModelType where ModelType:Codable
	
	func fetch(endpoint: Endpoint) async -> Result<ModelType, NetworkError>
	
}

extension HTTPClient {
	
	func fetch(endpoint: Endpoint) async -> Result<ModelType, NetworkError> {
		
		// 1
		guard let request = try? endpoint.composeRequest() else {
			return .failure(NetworkError.badRequest(error: "Cannot compose request"))
		}
		
		// 2
		guard let (data, response) = try? await URLSession.shared.data(for: request) else {
			return .failure(NetworkError.badURL("Cannot send Request"))
		}
		
		// 3
		guard let response = response as? HTTPURLResponse else {
			return .failure(NetworkError.badRequest(error: "No response"))
		}
		
		switch response.statusCode {
		case 200...299:
			guard let data = try? JSONDecoder().decode(ModelType.self, from: data) else {
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
