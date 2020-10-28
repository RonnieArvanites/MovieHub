//
//  Review.swift
//  MovieHub
//
//  Created by Ronnie Arvanites on 10/6/20.
//

import Foundation

// Review list JSON response model
struct ReviewList: Decodable {
    var reviews: [Review]?
    let page: Int
    let totalPages: Int
    
    enum CodingKeys: String, CodingKey {
        case reviews = "results"
        case page
        case totalPages = "total_pages"
    }
}

// Review JSON response model
struct Review: Decodable, Identifiable {
    let id: String
    let author: String
    let content: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case author
        case content
    }
}
