//
//  MovieList.swift
//  MovieHub
//
//  Created by Ronnie Arvanites on 10/3/20.
//

import Foundation

// Movie list JSON response model
struct MovieList: Decodable {
    let page: Int
    let totalPages: Int
    var movies: Array<MovieTile>
    
    enum CodingKeys: String, CodingKey {
        case page
        case totalPages = "total_pages"
        case movies = "results"
    }
}
