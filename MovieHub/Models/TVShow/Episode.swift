//
//  Episode.swift
//  MovieHub
//
//  Created by Ronnie Arvanites on 10/14/20.
//

import Foundation
import SwiftUI

// Episode JSON response model
struct Episode: Decodable, Identifiable {
    
    let id: Int
    let episodeNumber: Int
    let name: String
    let airDate: Date?
    let overview: String
    let thumbnailURL: String?
    let score: CGFloat
    let voteCount: Int
    
    enum CodingKeys: String, CodingKey {
        case id
        case episodeNumber = "episode_number"
        case name
        case airDate = "air_date"
        case overview
        case thumbnailURL = "still_path"
        case score = "vote_average"
        case voteCount = "vote_count"
    }
}
