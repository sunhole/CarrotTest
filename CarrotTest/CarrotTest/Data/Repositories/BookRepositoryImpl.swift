//
//  BookRepositoryImpl.swift
//  CarrotTest
//
//  Created by vision on 12/2/25.
//

import Foundation

final class BookRepositoryImpl: BookRepository {
    private let apiClient: APIClient
    
    init(apiClient: APIClient = .shared) {
        self.apiClient = apiClient
    }
    
    func searchBooks(query: String, page: Int, completion: @escaping (Result<SearchBooksResponse, NetworkError>) -> Void) {
        apiClient.request(endpoint: .search(query: query, page: page), completion: { result in
            completion(result)
        })
    }
    
    func fetchBookDetail(isbn13: String, completion: @escaping (Result<BookDetailResponse, NetworkError>) -> Void) {
        apiClient.request(endpoint: .bookDetaul(isbn13: isbn13), completion: { result in
            completion(result)
        })
    }
}
