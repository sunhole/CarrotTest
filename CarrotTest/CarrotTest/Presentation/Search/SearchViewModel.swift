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
    private var totalCount: Int = 0
    
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
                    self.totalCount = response.totalCount
                    self.currentPage = response.currentPage
                    /* 검색을 새로 할떄마다 페이지가 1일텐데 이경우 기존 book 데이터에 새로 추가하면 안되기때문에 기존데이터 지우고 새데이터로 교체가 필요함
                        즉 page 1은 새로운 검색이니 새로 고침 개념이고 1아 아닐경우 이어서 데이터를 추가하는개념
                     */
                    if page == 1 {
                        self.books = response.books
                    } else {
                        self.books.append(contentsOf: response.books)
                    }
                    completion(.success(()))
                    print("Log:\(response.currentPage)\(self.books.count)/\(self.totalCount)")
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        })
    }
    
    //다음페이지 호출 함수
    //서치 내부에서 로딩플래그가있으니 다음 페이지 값만 계산해서 재사용하도록 처리
    func loadNextPage(completion: @escaping (Result<Void, NetworkError>) -> Void) {
        //로딩중이 아니며 현재 쿼리가 있고 더불러올 페이지가 있다면
        guard !isLoading,
              !currentQuery.isEmpty,
              isLoadMorePage else { return }
        
        let nextPage = currentPage + 1
        
        search(query: currentQuery, page: nextPage, completion: completion)
    }
}

extension SearchViewModel {
    var isLoadMorePage: Bool {
        return books.count < totalCount
    }
}
