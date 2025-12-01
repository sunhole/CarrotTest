//
//  BookModel.swift
//  CarrotTest
//
//  Created by vision on 12/1/25.
//

import Foundation

struct BookModel: Decodable {
    let title: String
    let subtitle: String
    let isbn13: String
    let price: String
    let image: String
    let url: String
}
