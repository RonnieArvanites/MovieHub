//
//  Person.swift
//  MovieHub
//
//  Created by Ronnie Arvanites on 10/6/20.
//

import Foundation

// Person JSON response model
struct Person: Decodable {
    
    let id: Int
    let name: String
    let birthday: Date?
    let deathday: Date?
    let biography: String?
    let birthPlace: String?
    let gender: Int?
    let profileImageUrl: String?
    let movieRoleList: MovieRoleList?
    let tvRoleList: TVRoleList?
    var knownFor: [KnownFor]?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case birthday
        case deathday
        case biography
        case birthPlace = "place_of_birth"
        case gender
        case profileImageUrl = "profile_path"
        case movieRoleList = "movie_credits"
        case tvRoleList = "tv_credits"
        case knownForDepartment = "known_for_department"
        case combinedCredits = "combined_credits"
        case cast
        case crew
        
    }
    
    
    // Manually decodes JSON
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        // Decodes id
        id = try container.decode(Int.self, forKey: .id)
        // Decodes name
        name = try container.decode(String.self, forKey: .name)
        // Decodes birthday
        birthday = try container.decodeIfPresent(Date.self, forKey: .birthday)
        // Decodes deathday
        deathday = try container.decodeIfPresent(Date.self, forKey: .deathday)
        // Decodes biography
        biography = try container.decodeIfPresent(String.self, forKey: .biography)
        // Decodes birthPlace
        birthPlace = try container.decodeIfPresent(String.self, forKey: .birthPlace)
        // Decodes gender
        gender = try container.decodeIfPresent(Int.self, forKey: .gender)
        // Decodes profileImageUrl
        profileImageUrl = try container.decodeIfPresent(String.self, forKey: .profileImageUrl)
        // Decodes movieRoleList
        movieRoleList = try container.decodeIfPresent(MovieRoleList.self, forKey: .movieRoleList)
        // Decodes tvRoleList
        tvRoleList = try container.decodeIfPresent(TVRoleList.self, forKey: .tvRoleList)
        let knownForDepartment = try container.decode(String.self, forKey: .knownForDepartment)
        let combinedCredits = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .combinedCredits)
        var knownForList = [KnownFor]()
        // Check if knownForDepartment is Directing
        if knownForDepartment == "Directing" {
            var crew = try combinedCredits.nestedUnkeyedContainer(forKey: .crew)
            // Loops through all roles
            while !crew.isAtEnd {
                // Decodes role
                let role = try crew.decode(KnownFor.self)
                // Adds the role to the knownForList
                knownForList.append(role)
            }
            // Sort list by most popular movie/tv show
            knownForList.sort(by: {$0.voteCount > $1.voteCount})
            // Check to see if knownForList has more than five items
            if knownForList.count > 5 {
                // Saves only the first 5
                var topFive = [KnownFor]()
                var index = 0
                while topFive.count < 5 {
                    // Check if movie/tv show is already in array
                    if !topFive.contains(where: {$0.id == knownForList[index].id}) {
                        // Add movie/tv show to list
                        topFive.append(knownForList[index])
                    }
                    // Increment index by 1
                    index+=1
                }
                // Sets knownFor to topFive
                knownFor = topFive
            } else {
                // Sets knownFor to knownForList
                knownFor = knownForList
            }
        } else if knownForDepartment == "Acting" {
            var cast = try combinedCredits.nestedUnkeyedContainer(forKey: .cast)
            // Loops through all roles
            while !cast.isAtEnd {
                // Decodes role
                let role = try cast.decode(KnownFor.self)
                // Adds the role to the knownForList
                knownForList.append(role)
            }
            // Sort list by most popular movie/tv show
            knownForList.sort(by: {$0.voteCount > $1.voteCount})
            // Check to see if knownForList has more than five items
            if knownForList.count > 5 {
                // Saves only the first 5
                var topFive = [KnownFor]()
                var index = 0
                while topFive.count < 5 {
                    // Check if movie/tv show is already in array
                    if !topFive.contains(where: {$0.id == knownForList[index].id}) {
                        // Add movie/tv show to list
                        topFive.append(knownForList[index])
                    }
                    // Increment index by 1
                    index+=1
                }
                // Sets knownFor to topFive
                knownFor = topFive
            } else {
                // Sets knownFor to knownForList
                knownFor = knownForList
            }
        }
    }
}
