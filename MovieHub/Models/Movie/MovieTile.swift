//
//  MovieTVShowTile.swift
//  MovieHub
//
//  Created by Ronnie Arvanites on 10/2/20.
//

import Foundation

// Movie tile JSON response model
struct MovieTile: Decodable, Identifiable {
    let id: Int
    let posterURL: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case posterURL = "poster_path"
    }
}
