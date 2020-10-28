//
//  MovieRoleList.swift
//  MovieHub
//
//  Created by Ronnie Arvanites on 10/6/20.
//

import Foundation

// Movie role list JSON response
struct MovieRoleList: Decodable {
    let cast: [MovieCastRole]
    let crew: [MovieCrewRole]
    
    enum CodingKeys: String, CodingKey {
        case cast
        case crew
    }
}

// Movie cast role JSON response
struct MovieCastRole: Decodable, Identifiable {
    
    let id = UUID()
    let movieId: Int
    let movieTitle: String
    let character: String?
    let moviePosterUrl: String?
    
    enum CodingKeys: String, CodingKey {
        case movieId = "id"
        case movieTitle = "title"
        case character
        case moviePosterUrl = "poster_path"
    }
}

// Movie crew role JSON response
struct MovieCrewRole: Decodable, Identifiable {
    
    let id = UUID()
    let movieId: Int
    let movieTitle: String
    let job: String
    let moviePosterUrl: String?
    
    enum CodingKeys: String, CodingKey {
        case movieId = "id"
        case movieTitle = "title"
        case job
        case moviePosterUrl = "poster_path"
    }
}
