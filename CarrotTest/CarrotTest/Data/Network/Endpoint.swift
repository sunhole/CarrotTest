//
//  Endpoint.swift
//  CarrotTest
//
//  Created by vision on 12/1/25.
//

import Foundation

enum ITBookEndpoint {
    case search(query: String, page: Int?)
    case bookDetaul(isbn13: String)
}

extension ITBookEndpoint {
    private static let baseURLString = "https://api.itbook.store"
    
    private var path: String {
        switch self {
        case let .search(query, page):
            if let page = page {
                return "/1.0/search/\(query)/\(page)"
            } else {
                return "/1.0/search/\(query)"
            }
        case let .bookDetaul(isbn13):
            return "/1.0/books/\(isbn13)"
        }
    }
    
    private var method: HTTPMethod {
        return .get
    }
    
    func makeURLRequest() throws -> URLRequest {
        guard var components = URLComponents(string: Self.baseURLString) else {
            throw NetworkError.invalidURL
        }
        components.path = path
        
        guard let url = components.url else {
            throw NetworkError.invalidURL
        }
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        return request
    }
    
}
