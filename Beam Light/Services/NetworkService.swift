//
//  NetworkService.swift
//  Beam Light
//
//  Created by Gerry Gao on 16/2/2022.
//

import Foundation

protocol NetworkServiceable {
    func makeRequest<T: Codable>(with endPoint: Endpoint, completion: @escaping (Result<T, NetworkError>) -> Void)
}

extension NetworkServiceable {
    func makeRequest<T: Codable>(with endPoint: Endpoint, completion: @escaping (Result<T, NetworkError>) -> Void) {

        let url = endPoint.buildURL()
        
        var request = URLRequest(url: url)
        
        
        request.httpMethod = endPoint.method.rawValue
        request.allHTTPHeaderFields = endPoint.headers
        
        if let body = endPoint.body {
            request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
        }
        
        let session = URLSession.shared
        
        session.dataTask(with: request) { data, response, error in
            guard let response = response as? HTTPURLResponse else {
                completion(.failure(.noResponse("No response")))
                return
            }
            
            switch response.statusCode {
            case 200...299:
                print("good")
                //Decode
                if let data = data {
                    do {
                        let result = try JSONDecoder().decode(T.self, from: data)
                        completion(.success(result))
                    } catch let error {
                        completion(.failure(.invalidJSON(error.localizedDescription, error: error)))
                    }
                }
            case 400...:
                print("Error with status Code: \(response.statusCode)")
            default:
                completion(.failure(.unknown(code: response.statusCode, error: "error response")))
            }
        }.resume()
    }
}
