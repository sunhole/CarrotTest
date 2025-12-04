//
//  BookDetailResponse.swift
//  CarrotTest
//
//  Created by vision on 12/1/25.
//

import Foundation

struct BookDetailResponse: Decodable {
    let error: String
    let title: String
    let subtitle: String
    let authors: String
    let publisher: String
    let language: String
    let isbn10: String
    let isbn13: String
    let pages: String
    let year: String
    let rating: String
    let desc: String
    let price: String
    let image: String
    let url: String
    //api콜 하다보면 가끔 pdf값이 없는경우도 있어서 일단 옵셔널로 처리
    let pdf: [String: String]?
}
