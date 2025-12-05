//
//  SearchViewModelTests.swift
//  CarrotTestTests
//
//  Created by vision on 12/5/25.
//

import XCTest
@testable import CarrotTest

final class SearchViewModelTests: XCTestCase {
    
    func test_search_success_updatesBooks() {
        // given
        let mockRepo = MockBookRepository()
        
        let response = SearchBooksResponse(
            error: "0",
            total: "1",
            page: "1",
            books: [
                BookModel(
                    title: "Test Book",
                    subtitle: "Sub",
                    isbn13: "1234567890123",
                    price: "$10",
                    image: "https://example.com/image.png",
                    url: "https://example.com"
                )
            ]
        )
        mockRepo.searchResult = .success(response)
        
        let viewModel = SearchViewModel(repository: mockRepo)
        let exp = expectation(description: "search completion")
        
        // when
        viewModel.search(query: "swift") { result in
            // then
            switch result {
            case .success:
                XCTAssertEqual(viewModel.books.count, 1)
                XCTAssertEqual(viewModel.books.first?.title, "Test Book")
            case .failure:
                XCTFail("Expected success, but got failure")
            }
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1.0)
    }
    
    func test_search_pagination_appendsBooks() {
        // given
        let mockRepo = MockBookRepository()
        
        // page 1 응답
        let page1Response = SearchBooksResponse(
            error: "0",
            total: "3",
            page: "1",
            books: [
                BookModel(title: "Book1", subtitle: "", isbn13: "1", price: "$1", image: "", url: ""),
                BookModel(title: "Book2", subtitle: "", isbn13: "2", price: "$2", image: "", url: "")
            ]
        )
        
        // page 2 응답
        let page2Response = SearchBooksResponse(
            error: "0",
            total: "3",
            page: "2",
            books: [
                BookModel(title: "Book3", subtitle: "", isbn13: "3", price: "$3", image: "", url: "")
            ]
        )
        
        let viewModel = SearchViewModel(repository: mockRepo)
        
        let exp1 = expectation(description: "page1")
        let exp2 = expectation(description: "page2")
        
        // when: page 1
        mockRepo.searchResult = .success(page1Response)
        viewModel.search(query: "swift", page: 1) { result in
            switch result {
            case .success:
                XCTAssertEqual(viewModel.books.count, 2)
                XCTAssertEqual(viewModel.books.map { $0.title }, ["Book1", "Book2"])
            case .failure:
                XCTFail("page1 should succeed")
            }
            exp1.fulfill()
        }
        
        wait(for: [exp1], timeout: 1.0)
        
        // when: page 2
        mockRepo.searchResult = .success(page2Response)
        viewModel.search(query: "swift", page: 2) { result in
            switch result {
            case .success:
                XCTAssertEqual(viewModel.books.count, 3)
                XCTAssertEqual(viewModel.books.map { $0.title }, ["Book1", "Book2", "Book3"])
            case .failure:
                XCTFail("page2 should succeed")
            }
            exp2.fulfill()
        }
        
        wait(for: [exp2], timeout: 1.0)
    }
}
