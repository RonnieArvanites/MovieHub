//
//  TrailerList.swift
//  MovieHub
//
//  Created by Ronnie Arvanites on 10/3/20.
//

import Foundation

// Trailers list JSON response model
struct TrailerList: Decodable {
    var trailers: [Trailer]
    
    enum CodingKeys: String, CodingKey {
        case trailers = "results"
    }
}

// Trailer JSON response model
struct Trailer: Decodable, Hashable {
    let name: String
    let site: String
    let key: String
    let type: String
    
    enum CodingKeys: String, CodingKey {
        case name
        case site
        case key
        case type
    }
}
