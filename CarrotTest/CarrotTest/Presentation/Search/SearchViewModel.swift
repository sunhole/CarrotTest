//
//  SearchViewModel.swift
//  CarrotTest
//
//  Created by vision on 12/2/25.
//

import Foundation

final class SearchViewModel {
    private let repository: BookRepository
    //내부 수정만 외부 읽기만 가능하게 public으로 권한을 열기보단 (set)으로 정의
    private(set) var books: [BookModel] = []
    private var currentQuery: String = ""
    private var currentPage: Int = 1
    private var isLoading: Bool = false
    
    init(repository: BookRepository = BookRepositoryImpl()) {
        self.repository = repository
    }
    
    func search(query: String, page: Int = 1, completion: @escaping (Result<Void, NetworkError>) -> Void) {
        //동시호출 방어
        if isLoading { return }
        isLoading = true
        
        currentQuery = query
        currentPage = page
        
        repository.searchBooks(query: query, page: page, completion: { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.isLoading = false
                
                switch result {
                case .success(let response):
                    self.books = response.books
                    completion(.success(()))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        })
    }
    
}
