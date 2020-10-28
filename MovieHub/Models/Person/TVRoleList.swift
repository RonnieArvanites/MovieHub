//
//  TVRoleList.swift
//  MovieHub
//
//  Created by Ronnie Arvanites on 10/6/20.
//

import Foundation

// TV role list JSON response
struct TVRoleList: Decodable {
    
    let cast: [TVCastRole]
    let crew: [TVCrewRole]
    
    enum CodingKeys: String, CodingKey {
        case cast
        case crew
    }
}

// TV crew role JSON response
struct TVCrewRole: Decodable, Identifiable {
    
    let id = UUID()
    let showId: Int
    let showTitle: String
    let job: String
    let tvPosterUrl: String?
    
    enum CodingKeys: String, CodingKey {
        case showId = "id"
        case showTitle = "name"
        case job
        case tvPosterUrl = "poster_path"
    }
}

// TV cast role JSON response
struct TVCastRole: Decodable, Identifiable {
    
    let id = UUID()
    let showId: Int
    let showTitle: String
    let tvPosterUrl: String?
    let character: String?
    
    enum CodingKeys: String, CodingKey {
        case showId = "id"
        case showTitle = "name"
        case tvPosterUrl = "poster_path"
        case character
    }
}
