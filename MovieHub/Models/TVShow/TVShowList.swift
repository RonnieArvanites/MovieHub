//
//  TVShowList.swift
//  MovieHub
//
//  Created by Ronnie Arvanites on 10/13/20.
//

import Foundation

// TV show list JSON response model
struct TVShowList: Decodable {
    let page: Int
    let totalPages: Int
    var tvShows: Array<TVShowTile>
    
    enum CodingKeys: String, CodingKey {
        case page
        case totalPages = "total_pages"
        case tvShows = "results"
    }
}
