//
//  TVShow.swift
//  MovieHub
//
//  Created by Ronnie Arvanites on 10/13/20.
//

import Foundation
import SwiftUI

// TV show JSON response model
struct TVShow: Decodable {

    let id: Int
    let name: String
    let posterURL: String?
    let backdropURL: String?
    let genres: Array<Genre>
    let overview: String
    let firstAirDate: Date?
    let lastAirDate: Date?
    let episodeRuntime: Array<Int>?
    let score: CGFloat
    let voteCount: Int
    let rating: String
    let filmStudios: Array<FilmStudio>?
    var trailers: TrailerList?
    var vimeoTrailers: [VimeoTrailer]?
    var youtubeTrailers: [Trailer]?
    var similarTVShows: SimilarTVShowList?
    let inProduction: Bool
    let numberOfSeasons: Int
    let numberOfEpisodes: Int
    let creators: Array<Creator>?
    let networks: Array<Network>
    let type: String
    var cast: [CastMember]?
    var seasons: [Season]?

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case posterURL = "poster_path"
        case backdropURL = "backdrop_path"
        case genres
        case overview
        case firstAirDate = "first_air_date"
        case lastAirDate = "last_air_date"
        case episodeRuntime = "episode_run_time"
        case score = "vote_average"
        case voteCount = "vote_count"
        case ratings = "content_ratings"
        case filmStudios = "production_companies"
        case trailers = "videos"
        case vimeoTrailers
        case youtubeTrailers
        case similarTVShows = "similar"
        case inProduction = "in_production"
        case numberOfSeasons = "number_of_seasons"
        case numberOfEpisodes =  "number_of_episodes"
        case creators  = "created_by"
        case networks
        case type
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        // Decodes id
        id = try container.decode(Int.self, forKey: .id)
        // Decodes name
        name = try container.decode(String.self, forKey: .name)
        // Decodes posterURL
        posterURL = try container.decodeIfPresent(String.self, forKey: .posterURL)
        // Decodes backdropURL
        backdropURL = try container.decodeIfPresent(String.self, forKey: .backdropURL)
        // Decodes genres
        genres = try container.decode([Genre].self, forKey: .genres)
        // Decodes overview
        overview = try container.decode(String.self, forKey: .overview)
        // Try to decode firstAirDate
        do {
            firstAirDate = try container.decode(Date.self, forKey: .firstAirDate)
        } catch {
            firstAirDate = nil
        }
        // Try to decode lastAirDate
        do {
            lastAirDate = try container.decode(Date.self, forKey: .lastAirDate)
        } catch {
            lastAirDate = nil
        }
        // Decodes episodeRuntime
        episodeRuntime = try container.decodeIfPresent([Int].self, forKey: .episodeRuntime)
        // Decodes score
        score = try container.decode(CGFloat.self, forKey: .score)
        // Decodes voteCount
        voteCount = try container.decode(Int.self, forKey: .voteCount)
        let ratings = try container.decode(Ratings.self, forKey: .ratings)
        // Get US rating
        if let usRating = ratings.ratingList.first(where: {$0.iso31661 == "US"}) {
            // Sets rating to US rating
            rating = usRating.rating
        } else {
            // Sets rating to Not Rated
            rating = "Not Rated"
        }
        // Decodes filmStudios
        filmStudios = try container.decodeIfPresent([FilmStudio].self, forKey: .filmStudios)
        // Decodes trailers
        trailers = try container.decodeIfPresent(TrailerList.self, forKey: .trailers)
        // Decodes similarTVShows
        similarTVShows = try container.decodeIfPresent(SimilarTVShowList.self, forKey: .similarTVShows)
        // Decodes inProduction
        inProduction = try container.decode(Bool.self, forKey: .inProduction)
        // Decodes numberOfSeasons
        numberOfSeasons = try container.decode(Int.self, forKey: .numberOfSeasons)
        // Decodes numberOfEpisodes
        numberOfEpisodes = try container.decode(Int.self, forKey: .numberOfEpisodes)
        // Decodes creators
        creators = try container.decodeIfPresent([Creator].self, forKey: .creators)
        // Decodes networks
        networks = try container.decode([Network].self, forKey: .networks)
        // Decodes type
        type = try container.decode(String.self, forKey: .type)
    }
    
    init(id: Int, name: String, posterURL: String?, backdropURL: String?, genres: Array<Genre>, overview: String, firstAirDate: Date?, lastAirDate: Date?, episodeRuntime: Array<Int>?, score: CGFloat, voteCount: Int, rating: String, filmStudios: Array<FilmStudio>?, trailers: TrailerList?, similarTVShows: SimilarTVShowList?, inProduction: Bool, numberOfSeasons: Int, numberOfEpisodes: Int, creators: Array<Creator>?, networks: Array<Network>, type: String, cast: [CastMember]?, seasons: [Season]?) {
        
        self.id = id
        self.name = name
        self.posterURL = posterURL
        self.backdropURL = backdropURL
        self.genres = genres
        self.overview = overview
        self.firstAirDate = firstAirDate
        self.lastAirDate = lastAirDate
        self.episodeRuntime = episodeRuntime
        self.score = score
        self.voteCount = voteCount
        self.rating = rating
        self.filmStudios = filmStudios
        self.trailers = trailers
        self.similarTVShows = similarTVShows
        self.inProduction = inProduction
        self.numberOfSeasons = numberOfSeasons
        self.numberOfEpisodes = numberOfEpisodes
        self.creators = creators
        self.networks = networks
        self.type = type
        self.cast = cast
        self.seasons = seasons
        
    }

    // Rating JSON Response model
    struct Ratings: Decodable {
        
        let ratingList: [CountryRatings]

        enum CodingKeys: String, CodingKey {
            case ratingList = "results"
        }
    }

    // CountryRatings JSON Response model
    struct CountryRatings: Decodable {
        
        let iso31661: String
        let rating: String

        enum CodingKeys: String, CodingKey {
            case iso31661 = "iso_3166_1"
            case rating
        }

    }

    // Network JSON Response model
    struct Network: Decodable, Identifiable {

        let id: Int
        let name: String
        let logoURL: String?

        enum CodingKeys: String, CodingKey {
            case id
            case name
            case logoURL = "logo_path"
        }
    }

    // Creator JSON Response model
    struct Creator: Decodable, Equatable {

        let id: Int
        let name: String

        enum CodingKeys: String, CodingKey {
            case id
            case name
        }
        
        static func ==(lhs: Creator, rhs: Creator) -> Bool {
            return lhs.id == rhs.id
        }
    }
    
    // Returns creators array in string format
    func creatorsString() -> String {
        var creatorString = ""
        // Loops through creator array
        for creator in self.creators! {
            // Adds creator to string
            creatorString = creatorString + "\(creator.name)"
            // Checks if creator is last creator in array
            if creator != self.creators?.last {
                // Adds a seperator
                creatorString = creatorString + ", "
            }
        }
        
        // Returns creatorString
        return creatorString
    }
    
    // Return the genre array in string format
    func genreList() -> String {
        var genreString = ""
        // Loops through genres array
        for genre in self.genres {
            // Adds genre to string
            genreString = genreString + "\(genre.toString())"
            // Checks if genre is last genre in array
            if genre != self.genres.last {
                // Adds seperator
                genreString = genreString + " • "
            }
        }
        
        // Returns genreString
        return genreString
    }
    
    // Return the filmStudio array in string format
    func filmStudiostoString() -> String {
        var filmStudiosString = ""
        // Loops through film studio array
        for filmStudio in self.filmStudios! {
            // Adds filmStudio to string
            filmStudiosString = filmStudiosString + "\(filmStudio.name)"
            // Checks if filmStudio is last filmStudio in array
            if filmStudio != self.filmStudios?.last {
                // Adds seperator
                filmStudiosString = filmStudiosString + ", "
            }
        }
        
        // Return filmStudiosString
        return filmStudiosString
    }
}
