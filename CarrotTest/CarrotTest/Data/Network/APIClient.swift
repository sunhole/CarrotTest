//
//  APIClient.swift
//  CarrotTest
//
//  Created by vision on 12/1/25.
//

import Foundation

final class APIClient {

    static let shared = APIClient()
    private init() {
        
    }
    private let session = URLSession.shared
    
    func request<T: Decodable>(
        endpoint: ITBookEndpoint,
        completion: @escaping (Result<T, NetworkError>) -> Void
    ) {
        guard let request = try? endpoint.makeURLRequest() else {
            completion(.failure(.invalidURL))
            return
        }
        
        session.dataTask(with: request) { data, respone, error in
            if let error = error {
                completion(.failure(.requestFailed(error)))
                return
            }
            
            guard let httpRespone = respone as? HTTPURLResponse, (200..<300).contains(httpRespone.statusCode) else {
                completion(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            
            do {
                let decoded = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decoded))
            } catch {
                completion(.failure(.decodingError(error)))
            }
            
        }.resume()
    }
}
