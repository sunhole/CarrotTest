//
//  BookDetailViewModel.swift
//  CarrotTest
//
//  Created by vision on 12/4/25.
//

import Foundation

final class BookDetailViewModel {
    private let repository: BookRepository
    private let isbn13: String
    
    private(set) var book: BookDetailResponse?
    private(set) var isLoading: Bool = false
    
    init(repository: BookRepository, isbn13: String) {
        self.repository = repository
        self.isbn13 = isbn13
    }
    
    func loadDetail(completion: @escaping (Result<Void, NetworkError>) -> Void) {
        if isLoading { return }
        isLoading = true
        
        repository.fetchBookDetail(isbn13: isbn13, completion: { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.isLoading = false
                
                switch result {
                case .success(let response):
                    self.book = response
                    completion(.success(()))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        })
    }
}

//MARK: - UI 프로퍼티 일단 이정도만 있어도 될듯
extension BookDetailViewModel {
    var titleText: String {
        book?.title ?? ""
    }
    
    var authorsText: String {
        book?.authors ?? ""
    }
    
    var descriptionText: String {
        book?.desc ?? ""
    }
    
    var imageURL: URL? {
        guard let urlString = book?.image else { return nil }
        return URL(string: urlString)
    }
}
