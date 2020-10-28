//
//  KnownFor.swift
//  MovieHub
//
//  Created by Ronnie Arvanites on 10/20/20.
//

import Foundation

// KnownFor JSON response model
struct KnownFor: Decodable, Equatable, Identifiable {
    
    let id: Int
    let type: String
    let title: String
    let posterURL: String?
    let voteCount: Int
    var role: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case type = "media_type"
        case title
        case name
        case posterURL = "poster_path"
        case voteCount = "vote_count"
        case job
        case character
    }
    
    // Manually decodes JSON
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        // Decodes id
        id = try container.decode(Int.self, forKey: .id)
        // Decodes type
        type = try container.decode(String.self, forKey: .type)
        // Decodes posterURL
        posterURL = try container.decodeIfPresent(String.self, forKey: .posterURL)
        // Decodes voteCount
        voteCount = try container.decode(Int.self, forKey: .voteCount)
        // Check if media type is movie or tv
        if type == "movie" {
            // Decodes title
            title = try container.decode(String.self, forKey: .title)
        } else {
            // Decodes title
            title = try container.decode(String.self, forKey: .name)
        }
        // Decodes role
        role = try container.decodeIfPresent(String.self, forKey: .job)
        // Check if role is nil
        if role == nil {
            // Decodes role
            role = try container.decodeIfPresent(String.self, forKey: .character)
        }
    }
    
    // Initilaizes KnownFor
    init(id: Int, type: String, title: String, posterURL: String, voteCount: Int, role: String) {
        self.id = id
        self.type = type
        self.title = title
        self.posterURL = posterURL
        self.voteCount = voteCount
        self.role = role
    }
}
