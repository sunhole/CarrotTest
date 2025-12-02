//
//  BookRepository.swift
//  CarrotTest
//
//  Created by vision on 12/2/25.
//

import Foundation

protocol BookRepository {
    func searchBooks(query: String, page: Int, completion: @escaping (Result<SearchBooksResponse, NetworkError>) -> Void)
    
    func fetchBookDetail(isbn13: String, completion: @escaping (Result<BookDetailResponse, NetworkError>) -> Void)
}
