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
