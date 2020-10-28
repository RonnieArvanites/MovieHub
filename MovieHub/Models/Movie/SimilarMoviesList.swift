//
//  SimilarMovies.swift
//  MovieHub
//
//  Created by Ronnie Arvanites on 10/6/20.
//

import Foundation

// Similar movie list JSON response model
struct SimilarMoviesList: Decodable {
    var movies: [MovieTile]
    let page: Int
    let totalPages: Int
    
    enum CodingKeys: String, CodingKey {
        case movies = "results"
        case page
        case totalPages = "total_pages"
    }
}
