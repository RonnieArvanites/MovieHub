//
//  TVShowTile.swift
//  MovieHub
//
//  Created by Ronnie Arvanites on 10/13/20.
//

import Foundation

// TV show tile JSON response model
struct TVShowTile: Decodable, Identifiable {
    let id: Int
    let posterURL: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case posterURL = "poster_path"
    }
}
