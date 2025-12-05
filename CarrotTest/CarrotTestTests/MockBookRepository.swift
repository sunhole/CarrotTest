//
//  MockBookRepository.swift
//  CarrotTestTests
//
//  Created by vision on 12/5/25.
//

import XCTest
import Foundation
@testable import CarrotTest

final class MockBookRepository: BookRepository {
    
    var searchResult: Result<SearchBooksResponse, NetworkError>?
    var detailResult: Result<BookDetailResponse, NetworkError>?
    
    func searchBooks(query: String, page: Int, completion: @escaping (Result<SearchBooksResponse, NetworkError>) -> Void) {
        if let result = searchResult {
            completion(result)
        }
    }
    
    func fetchBookDetail(isbn13: String, completion: @escaping (Result<BookDetailResponse, NetworkError>) -> Void) {
        if let result = detailResult {
            completion(result)
        }
    }
    
}
