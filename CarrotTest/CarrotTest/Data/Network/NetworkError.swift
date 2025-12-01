//
//  NetworkError.swift
//  CarrotTest
//
//  Created by vision on 12/1/25.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case requestFailed(Error)
    case invalidResponse
    case noData
    case decodingError(Error)
}
