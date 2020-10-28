//
//  Movie.swift
//  MovieHub
//
//  Created by Ronnie Arvanites on 10/3/20.
//

import Foundation
import SwiftUI

// Movie JSON response model
struct Movie: Decodable {
    
    let id: Int
    let title: String
    let posterURL: String?
    let backdropURL: String?
    let budget: Int
    let genres: Array<Genre>
    let overview: String
    var releaseDate: Date?
    let revenue: Int
    let runtime: Int?
    let score: CGFloat
    let voteCount: Int
    let filmStudios: Array<FilmStudio>?
    var rating: String?
    var directors: Array<CrewMember>?
    var writers: Array<CrewMember>?
    var castAndCrew: CastAndCrew?
    var movieCollection: MovieCollection?
    var movieCollectionMovies: Array<MovieTile>?
    var trailers: TrailerList?
    var vimeoTrailers: [VimeoTrailer]?
    var youtubeTrailers: [Trailer]?
    var similarMovies: SimilarMoviesList?
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case posterURL = "poster_path"
        case backdropURL = "backdrop_path"
        case budget
        case genres
        case overview
        case releaseDate = "release_date"
        case filmStudios = "production_companies"
        case revenue
        case runtime
        case score = "vote_average"
        case voteCount = "vote_count"
        case releases
        case rating
        case directors
        case writers
        case castAndCrew = "casts"
        case movieCollection = "belongs_to_collection"
        case trailers = "videos"
        case vimeoTrailers
        case youtubeTrailers
        case similarMovies = "similar"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        // Decodes id
        id = try container.decode(Int.self, forKey: .id)
        // Decodes title
        title = try container.decode(String.self, forKey: .title)
        // Decodes posterURL
        posterURL = try container.decodeIfPresent(String.self, forKey: .posterURL)
        // Decodes backdropURL
        backdropURL = try container.decodeIfPresent(String.self, forKey: .backdropURL)
        // Decodes budget
        budget = try container.decode(Int.self, forKey: .budget)
        // Decodes genres
        genres = try container.decode([Genre].self, forKey: .genres)
        // Decodes overview
        overview = try container.decode(String.self, forKey: .overview)
        // Try to decode releaseDate
        do {
            releaseDate = try container.decode(Date.self, forKey: .releaseDate)
        } catch {
            releaseDate = nil
        }
        // Decodes revenue
        revenue = try container.decode(Int.self, forKey: .revenue)
        // Decodes runtime
        runtime = try container.decodeIfPresent(Int.self, forKey: .runtime)
        // Decodes score
        score = try container.decode(CGFloat.self, forKey: .score)
        // Decodes voteCount
        voteCount = try container.decode(Int.self, forKey: .voteCount)
        let releases = try container.decode(Releases.self, forKey: .releases)
        // Get US rating
        if let usRating = releases.countries.first(where: {$0.iso31661 == "US" }) {
            // Checks if US rating is empty
            if !usRating.certification!.isEmpty {
                // Sets rating to US Rating
                rating = usRating.certification
            } else {
                // Sets rating to Not Rated
                rating = "Not Rated"
            }
            // Update release date to US release date
            releaseDate = usRating.releaseDate
        } else {
            // Sets rating to Not Rated
            rating = "Not Rated"
        }
        // Decodes filmStudios
        filmStudios = try container.decodeIfPresent([FilmStudio].self, forKey: .filmStudios)
        // Decodes castAndCrew
        castAndCrew = try container.decodeIfPresent(CastAndCrew.self, forKey: .castAndCrew)
        // Sets directors
        directors = castAndCrew!.crew.filter({$0.job == "Director"})
        // Sets writers
        writers = castAndCrew!.crew.filter({$0.job == "Screenplay" || $0.job == "Writer"})
        // Decodes movieCollection
        movieCollection = try container.decodeIfPresent(MovieCollection.self, forKey: .movieCollection)
        // Decodes trailers
        trailers = try container.decodeIfPresent(TrailerList.self, forKey: .trailers)
        // Decodes similarMovies
        similarMovies = try container.decodeIfPresent(SimilarMoviesList.self, forKey: .similarMovies)
    }
    
    // Countries JSON Response model
    struct Countries: Decodable {
        let certification: String?
        let iso31661: String
        let primary: Bool
        let releaseDate: Date
        
        enum CodingKeys: String, CodingKey {
            case certification
            case iso31661 = "iso_3166_1"
            case primary
            case releaseDate = "release_date"
        }
    }
    
    // Releases JSON Response model
    struct Releases: Decodable {
        let countries: [Countries]
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
    
    // Return the director array in string format
    func directorString() -> String {
        var directorString = ""
        // Loops through director array
        for director in self.directors! {
            // Adds director to string
            directorString = directorString + "\(director.name)"
            // Checks if director is last director in array
            if director != self.directors?.last {
                // Adds seperator
                directorString = directorString + ", "
            }
        }
        
        // Return directorString
        return directorString
    }
    
    // Return the writer array in string format
    func writersString() -> String {
        var writerString = ""
        // Loops through writer array
        for writer in self.writers! {
            // Adds writer to string
            writerString = writerString + "\(writer.name)"
            // Checks if writer is last writer in array
            if writer != self.writers?.last {
                // Adds seperator
                writerString = writerString + ", "
            }
        }
        
        // Return writerString
        return writerString
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
