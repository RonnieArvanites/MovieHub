//
//  AutoCompleteResult.swift
//  MovieHub
//
//  Created by Ronnie Arvanites on 10/18/20.
//

import Foundation

// Autocomplete result list JSON response model
struct AutoCompleteResultList: Decodable {
    
    var results: Array<AutoCompleteResult>
    
    enum CodingKeys: String, CodingKey {
        case results
    }
}

// Autocomplete result JSON response model
struct AutoCompleteResult: Decodable, Identifiable {
    
    let id: Int
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case title
        case mediaType = "media_type"
    }
    
    // Manually decodes JSON
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        let mediaType = try container.decode(String.self, forKey: .mediaType)
        // Check if media type is movie
        if mediaType == "movie" {
            name = try container.decode(String.self, forKey: .title)
        } else {
            name = try container.decode(String.self, forKey: .name)
        }
    }
}
