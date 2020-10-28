//
//  MovieCollection.swift
//  MovieHub
//
//  Created by Ronnie Arvanites on 10/6/20.
//

import Foundation

// Movie collection JSON response model
struct MovieCollection: Decodable {
    
    let id: Int
    let name: String
    let movies: Array<MovieTile>?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case movies = "parts"
    }
}
