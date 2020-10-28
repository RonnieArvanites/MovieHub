//
//  Season.swift
//  MovieHub
//
//  Created by Ronnie Arvanites on 10/14/20.
//

import Foundation
import SwiftUI

// Season JSON response model
struct Season: Decodable {
    let id: Int
    let name: String
    let overview: String?
    let seasonNumber: Int
    let episodes: [Episode]
    let posterURL: String?
    let castAndCrew: CastAndCrew?
    let trailers: TrailerList?
    var vimeoTrailers: [VimeoTrailer]?
    var youtubeTrailers: [Trailer]?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case overview
        case seasonNumber = "season_number"
        case episodes
        case posterURL = "poster_path"
        case castAndCrew = "credits"
        case trailers = "videos"
    }
}
