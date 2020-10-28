//
//  Genre.swift
//  MovieHub
//
//  Created by Ronnie Arvanites on 10/3/20.
//

import Foundation

// Genre JSON response model
struct Genre: Decodable, Hashable {
    let id: Int
    let name: String

    enum CodingKeys: String, CodingKey {
        case id
        case name
    }

    // Returns the genre string representation
    func toString() -> String{
        return self.name
    }
}
