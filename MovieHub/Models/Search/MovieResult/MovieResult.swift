//
//  MovieResult.swift
//  MovieHub
//
//  Created by Ronnie Arvanites on 10/17/20.
//

import Foundation

// Movie result list JSON response model
struct MovieResultList: Decodable {
    
    let page: Int
    let totalPages: Int
    let totalResults: Int
    var results: Array<MovieResult>
    
    enum CodingKeys: String, CodingKey {
        case page
        case totalPages = "total_pages"
        case totalResults = "total_results"
        case results
    }
}

// Movie result JSON response model
struct MovieResult: Decodable, Identifiable {

    let id: Int
    let posterURL: String?
    let title: String
    let overview: String

    enum CodingKeys: String, CodingKey {
        case id
        case posterURL = "poster_path"
        case title
        case overview
    }
}
