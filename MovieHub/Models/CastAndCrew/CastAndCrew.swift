//
//  CastAndCrew.swift
//  MovieHub
//
//  Created by Ronnie Arvanites on 10/3/20.
//

import Foundation

// Cast and Crew JSON response model
struct CastAndCrew: Decodable {
    let cast: [CastMember]
    let crew: [CrewMember]
    
    enum CodingKeys: String, CodingKey {
        case cast
        case crew
    }
}

// Cast member JSON response model
struct CastMember: Decodable, Identifiable, Hashable {
    
    let id: Int
    let character: String?
    let name: String
    let profilePictureURL: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case character
        case name
        case profilePictureURL = "profile_path"
    }
}

// Crew member JSON response model
struct CrewMember: Decodable, Equatable {
    
    let id: Int
    let name: String
    let job: String
    let profilePictureURL: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case job
        case profilePictureURL = "profile_path"
    }
    
    static func ==(lhs: CrewMember, rhs: CrewMember) -> Bool {
        return lhs.id == rhs.id
    }
}

