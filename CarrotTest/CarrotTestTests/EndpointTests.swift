//
//  EndpointTests.swift
//  CarrotTestTests
//
//  Created by vision on 12/5/25.
//

import XCTest
@testable import CarrotTest

final class EndpointTests: XCTestCase {
    
    func test_searchEndpoint_withPage_buildsCorrectURL() throws {
        // given
        let endpoint = ITBookEndpoint.search(query: "swift", page: 1)
        
        // when
        let request = try endpoint.makeURLRequest()
        let urlString = request.url?.absoluteString
        
        // then
        XCTAssertEqual(
            urlString,
            "https://api.itbook.store/1.0/search/swift/1"
        )
    }

    func test_searchEndpoint_withoutPage_buildsCorrectURL() throws {
        // given
        let endpoint = ITBookEndpoint.search(query: "swift", page: nil)
        
        // when
        let request = try endpoint.makeURLRequest()
        let urlString = request.url?.absoluteString
        
        // then
        XCTAssertEqual(
            urlString,
            "https://api.itbook.store/1.0/search/swift"
        )
    }
    
    func test_bookDetailEndpoint_buildsCorrectURL() throws {
        // given
        let endpoint = ITBookEndpoint.bookDetaul(isbn13: "9781484206485")
        
        // when
        let request = try endpoint.makeURLRequest()
        let urlString = request.url?.absoluteString
        
        // then
        XCTAssertEqual(
            urlString,
            "https://api.itbook.store/1.0/books/9781484206485"
        )
    }
}
