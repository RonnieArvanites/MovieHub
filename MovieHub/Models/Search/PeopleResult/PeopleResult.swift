//
//  PeopleResult.swift
//  MovieHub
//
//  Created by Ronnie Arvanites on 10/17/20.
//

import Foundation

// People result JSON response model
struct PeopleResultList: Decodable {
    
    let page: Int
    let totalPages: Int
    let totalResults: Int
    var results: Array<PeopleResult>
    
    enum CodingKeys: String, CodingKey {
        case page
        case totalPages = "total_pages"
        case totalResults = "total_results"
        case results
    }
}

// People result JSON response model
struct PeopleResult: Decodable, Identifiable {
    
    let id: Int
    let name: String
    let profileImageUrl: String?
    let department: String
    let knownFor: Array<KnownFor>
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case profileImageUrl = "profile_path"
        case department = "known_for_department"
        case knownFor = "known_for"
    }
    
    // Returns known for array in string format
    func knownForString() -> String {
        var knownForString = ""
        // Loops through each item in knownFor array
        for knownFor in self.knownFor {
            // Adds the knownFor item to the string
            knownForString = knownForString + "\(knownFor.title)"
            // Check if known for item is the last item in the array
            if knownFor != self.knownFor.last {
                // Add a seperator in between items
                knownForString = knownForString + " • "
            }
        }
        // returns knownForString
        return knownForString
    }
}


