//
//  FilmStudio.swift
//  MovieHub
//
//  Created by Ronnie Arvanites on 10/5/20.
//

import Foundation

// Film studio JSON response model
struct FilmStudio: Decodable, Equatable {
    
    let id: Int
    let logoURL: String?
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case logoURL = "logo_path"
        case name
    }
    
    static func ==(lhs: FilmStudio, rhs: FilmStudio) -> Bool {
        return lhs.id == rhs.id
    }
}
