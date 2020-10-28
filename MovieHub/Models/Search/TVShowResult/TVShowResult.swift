//
//  TVShowResult.swift
//  MovieHub
//
//  Created by Ronnie Arvanites on 10/17/20.
//

import Foundation

// TV show result list JSON response model
struct TVShowResultList: Decodable {
    
    let page: Int
    let totalPages: Int
    let totalResults: Int
    var results: Array<TVShowResult>
    
    enum CodingKeys: String, CodingKey {
        case page
        case totalPages = "total_pages"
        case totalResults = "total_results"
        case results
    }
}

// TV show result JSON response model
struct TVShowResult: Decodable, Identifiable {
    
    let id: Int
    let posterURL: String?
    let name: String
    let overview: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case posterURL = "poster_path"
        case name
        case overview
    }
}
