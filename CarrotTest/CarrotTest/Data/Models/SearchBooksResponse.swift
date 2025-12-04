//
//  SearchBooksResponse.swift
//  CarrotTest
//
//  Created by vision on 12/1/25.
//

import Foundation

struct SearchBooksResponse: Decodable {
    let error: String
    let total: String
    let page: String
    let books: [BookModel]
}

extension SearchBooksResponse {
    /*
     totalCount: 전체 검색 결과 수
     currentPage: 지금 응답이 몇번째 페이지인지
     pageSize: 한페이지당 책 갯수 현재는 10개씩 내려오는듯
     hasNextPage: 페이지가 더있음 true
     즉 현재 페이지 * 페이지 크기 < 전체 개수 -> 다음 페이지 존재
    */
    var totalCount: Int {
        return Int(total) ?? 0
    }
    
    var currentPage: Int {
        return Int(page) ?? 1
    }
    
    var hasNextPage: Bool {
        let pageSize = books.count
        guard pageSize > 0 else { return false }
        return currentPage * pageSize < totalCount
    }
}
