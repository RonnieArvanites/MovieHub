//
//  SimilarTVShowList.swift
//  MovieHub
//
//  Created by Ronnie Arvanites on 10/13/20.
//

import Foundation

// Similar tv show list JSON response model
struct SimilarTVShowList: Decodable {
    var tvShows: [TVShowTile]
    let page: Int
    let totalPages: Int
    
    enum CodingKeys: String, CodingKey {
        case tvShows = "results"
        case page
        case totalPages = "total_pages"
    }
}
