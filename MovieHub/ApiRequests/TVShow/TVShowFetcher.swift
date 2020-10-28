//
//  TVShowFetcher.swift
//  MovieHub
//
//  Created by Ronnie Arvanites on 10/13/20.
//

import Foundation

// Used to fetch tv show detail
class TVShowFetcher: ObservableObject {
    @Published var dataIsLoaded: Bool = false
    @Published var tvShow: TVShow? = nil
    @Published var connectionError: Bool = false
    @Published var seasonConnectionError: Bool = false
    @Published var loadMoreSimilarTVShowsConnectionError = false
    @Published var loadMoreSimilarTVShowsAreLoaded = false
    
    var tvShowId: Int
    let tvShowDispatchGroup = DispatchGroup()
    
    init(tvShowId: Int){
        self.tvShowId = tvShowId
        // Get tv show detail
        getTVShowData()
        // Tells view the data is loaded
        tvShowDispatchGroup.notify(queue: .main) {
            self.dataIsLoaded = true
        }
    }
    
    // Gets tv show data
    func getTVShowData(){
        
        // Adds this function to the tvShowDispatchGroup
        tvShowDispatchGroup.enter()
        
        // Sets the url to request
        let url = URL(string: Globals.baseURL + "/3/tv/\(self.tvShowId)?api_key=\(Globals.apiKey)&language=en-US&append_to_response=videos,content_ratings,similar")
        
        // Sets the request
        var request = URLRequest(url: url!)
        // Sets the request method to a GET method
        request.httpMethod = "GET"
        
        // Performs the url request
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            //Check for connection error
            if (error != nil) {
                DispatchQueue.main.async {
                    // Tells the view that there is a connection error
                    self.connectionError = true
                    // Removes this function from the tvShowDispatchGroup
                    self.tvShowDispatchGroup.leave()
                }
            }
            
            // Sets the response from server
            if let response = response as? HTTPURLResponse {
                
                // If success
                if response.statusCode == 200 {
                    // Sets decoder format to read date
                    let decoder = JSONDecoder()
                    let formatter = DateFormatter()
                    formatter.dateFormat = "yyyy-MM-dd"
                    decoder.dateDecodingStrategy = .formatted(formatter)
                    // Decodes JSON
                    var tvShow = try! decoder.decode(TVShow.self, from: data!)
                    // Get seaons info
                    self.getSeasonInfo(tvShowId: tvShow.id, numberOfSeasons: tvShow.numberOfSeasons)
                    // Filter trailer for videos on vimeo
                    let vimeoTrailers = tvShow.trailers?.trailers.filter({
                        $0.site == "Vimeo"})
                    // Check if tv show has vimeo trailers
                    if !vimeoTrailers!.isEmpty {
                        // Get url for vimeo trialers
                        self.setVimeoTrailers(trailers: vimeoTrailers!)
                    }
                    // Filter trailers on youtube
                    let youtubeTrailers = tvShow.trailers?.trailers.filter({$0.site == "YouTube"})
                    // Check if tv show has youtube trailers
                    if !youtubeTrailers!.isEmpty {
                        tvShow.youtubeTrailers = youtubeTrailers
                    }
                    DispatchQueue.main.async {
                        // Save tv show data returned from the server
                        self.tvShow = tvShow
                        // Removes this function from the tvShowDispatchGroup
                        self.tvShowDispatchGroup.leave()
                    }
                } else {
                    DispatchQueue.main.async {
                        // Tells the view that there is a connection error
                        self.connectionError = true
                        // Removes this function from the tvShowDispatchGroup
                        self.tvShowDispatchGroup.leave()
                    }
                }
            }
        }
        task.resume()
    }
    
    // Gets the vimeo trailers url path
    func setVimeoTrailers(trailers: [Trailer]){
        
        // Adds this function to the tvShowDispatchGroup
        tvShowDispatchGroup.enter()
        
        //Creates an empty list
        var vimeoTrailers = [VimeoTrailer]()
        
        // Creates a DispatchGroup
        let vimeoTrailerDispatchGroup = DispatchGroup()
        
        // Fetches the video file url on the vimeo website
        trailers.forEach { trailer in
            
            // Adds this function to the vimeoTrailerDispatchGroup
            vimeoTrailerDispatchGroup.enter()
            
            // Sets the url to request
            let url = URL(string: "https://player.vimeo.com/video/\(trailer.key)/config")
            
            // Sets the request
            var request = URLRequest(url: url!)
            // Sets the request method to a GET method
            request.httpMethod = "GET"
            
            // Performs the url request
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                
                // Check for connection error
                if (error != nil) {
                    DispatchQueue.main.async {
                        // Tells the view that there is a connection error
                        self.connectionError = true
                        // Removes this function from the vimeoTrailerDispatchGroup
                        vimeoTrailerDispatchGroup.leave()
                    }
                }
                
                // Sets the response from server
                if let response = response as? HTTPURLResponse {
                    
                    // If success
                    if response.statusCode == 200 {
                        // Decodes JSON
                        let vimeoTrailer = try! JSONDecoder().decode(VimeoTrailer.self, from: data!)
                        
                        DispatchQueue.main.async {
                            // Adds vimeoTrailer to vimeoTrailers list
                            vimeoTrailers.append(vimeoTrailer)
                            // Removes this function from the vimeoTrailerDispatchGroup
                            vimeoTrailerDispatchGroup.leave()
                        }
                    } else {
                        DispatchQueue.main.async {
                            // Tells the view that there is a connection error
                            self.connectionError = true
                            // Removes this function from the vimeoTrailerDispatchGroup
                            vimeoTrailerDispatchGroup.leave()
                        }
                    }
                }
            }
            task.resume()
        }
        
        vimeoTrailerDispatchGroup.notify(queue: .main) {
            //Set vimeo trailers
            self.tvShow?.vimeoTrailers = vimeoTrailers
            // Removes this function from the tvShowDispatchGroup
            self.tvShowDispatchGroup.leave()
        }
    }
    
    // Gets the tv show's season information and update cast information
    func getSeasonInfo(tvShowId: Int, numberOfSeasons: Int){
        
        // Adds this function to the tvShowDispatchGroup
        tvShowDispatchGroup.enter()
        
        // Create an emtpy list for cast
        var cast = [CastMember]()
        
        // Create an emtpy list for season information
        var seasons = [Season]()
        
        // Creates a DispatchGroup
        let seasonDispatchGroup = DispatchGroup()
        
        // Loops for each season
        for seasonNumber in 1...numberOfSeasons {
            
            // Adds this function to the seasonDispatchGroup
            seasonDispatchGroup.enter()
            
            // Sets the url to request
            let url = URL(string: Globals.baseURL + "/3/tv/\(tvShowId)/season/\(seasonNumber)?api_key=\(Globals.apiKey)&language=en-US&append_to_response=credits,videos")
            
            // Sets the request
            var request = URLRequest(url: url!)
            request.httpMethod = "GET"
            
            // Performs the url request
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                
                // Check for connection error
                if (error != nil) {
                    DispatchQueue.main.async {
                        // Tells the view that there is a connection error
                        self.seasonConnectionError = true
                        // Removes this function from the seasonDispatchGroup
                        seasonDispatchGroup.leave()
                    }
                }
                
                // Sets the response from server
                if let response = response as? HTTPURLResponse {
                    // If success
                    if response.statusCode == 200 {
                        // Sets decoder format to read date
                        let decoder = JSONDecoder()
                        let formatter = DateFormatter()
                        formatter.dateFormat = "yyyy-MM-dd"
                        decoder.dateDecodingStrategy = .formatted(formatter)
                        // Decodes JSON
                        var season = try! decoder.decode(Season.self, from: data!)
                        // Filters trailers for videos on vimeo
                        let vimeoTrailers = season.trailers?.trailers.filter({$0.site == "Vimeo"})
                        // Check if tv show has vimeo trailers
                        if !vimeoTrailers!.isEmpty {
                            // Get url for vimeo trialers
                            self.setSeasonVimeoTrailers(trailers: vimeoTrailers!, seasonNumber: seasonNumber)
                        }
                        // Filters tailers for youtube
                        let youtubeTrailers = season.trailers?.trailers.filter({$0.site == "YouTube"})
                        // Check if tv show has youtube trailers
                        if !youtubeTrailers!.isEmpty {
                            season.youtubeTrailers = youtubeTrailers
                        }
                        // Save season cast
                        let seasonCast = season.castAndCrew?.cast
                        DispatchQueue.main.async {
                            // Add season to list
                            seasons.append(season)
                            // Check if season cast is empty
                            if !seasonCast!.isEmpty{
                                // Loops through each item in seasonCast list
                                seasonCast?.forEach { castMember in
                                    // Check if cast member is already in list
                                    if !cast.contains(where: {$0.id == castMember.id}) {
                                        // Adds castMember to cast list
                                        cast.append(castMember)
                                    }
                                }
                            }
                            // Removes this function from the seasonDispatchGroup
                            seasonDispatchGroup.leave()
                        }
                    } else {
                        DispatchQueue.main.async {
                            // Tells the view that there is a connection error
                            self.seasonConnectionError = true
                            // Removes this function from the seasonDispatchGroup
                            seasonDispatchGroup.leave()
                        }
                    }
                }
            }
            task.resume()
        }
        
        seasonDispatchGroup.notify(queue: .main) {
            // Sort seasons by season number
            seasons.sort(by: {$0.seasonNumber < $1.seasonNumber})
            // Checks if show had cast info
            if !cast.isEmpty{
                // Sets cast
                self.tvShow?.cast = cast
            }
            // Sets season information
            self.tvShow?.seasons = seasons
            // Removes this function from the tvShowDispatchGroup
            self.tvShowDispatchGroup.leave()
        }
    }
    
    // Checks if more similar tv shows are needed
    func loadMoreSimilarTVShowIfNeeded(currentTVShow: TVShowTile){
        // Check if more similar tv shows are available
        if self.tvShow!.similarTVShows!.page < self.tvShow!.similarTVShows!.totalPages {
            // Set last tv show to last tv show in similar tv show list
            let lastTVShow = self.tvShow!.similarTVShows!.tvShows.last
            // Check if currentTVShow is the last tv show in the list
            if currentTVShow.id == lastTVShow?.id {
                // Get more similar tv shows
                self.getMoreSimilarTVShows()
            } else {
                return
            }
        } else {
            return
        }
    }
    
    // Gets more similar tv shows
    func getMoreSimilarTVShows(){
        // Sets the url to request
        let url = URL(string: Globals.baseURL + "/3/tv/\(self.tvShowId)/similar?api_key=\(Globals.apiKey)&language=en-US&page=\(self.tvShow!.similarTVShows!.page + 1)")
        
        // Sets the request
        var request = URLRequest(url: url!)
        // Sets the request method to a GET method
        request.httpMethod = "GET"
        
        // Performs the url request
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            // Check for connection error
            if (error != nil) {
                DispatchQueue.main.async {
                    // Tells the view there is a connection error when loading more similar tv shows
                    self.loadMoreSimilarTVShowsConnectionError = true
                    // Tell view that more similar tv shows are loaded
                    self.loadMoreSimilarTVShowsAreLoaded = true
                }
            }
            
            // Sets the response from server
            if let response = response as? HTTPURLResponse {
                // If success
                if response.statusCode == 200 {
                    // Decodes JSON
                    let similarTVShowList = try! JSONDecoder().decode(SimilarTVShowList.self, from: data!)
                    DispatchQueue.main.async {
                        // Set connection error to false
                        self.loadMoreSimilarTVShowsConnectionError = false
                        // Store old similar tv shows
                        let oldSimilarTVShows = self.tvShow!.similarTVShows!.tvShows
                        // Save new similar movie list
                        self.tvShow?.similarTVShows = similarTVShowList
                        // Combine old similar tv shows with new similar tv shows
                        let newSimlarTVShows = oldSimilarTVShows + self.tvShow!.similarTVShows!.tvShows
                        // Update similar tv show list
                        self.tvShow!.similarTVShows!.tvShows = newSimlarTVShows
                        // Tells view data is loaded
                        self.loadMoreSimilarTVShowsAreLoaded = true
                    }
                } else {
                    DispatchQueue.main.async {
                        // Tells the view there is a connection error when loading more similar tv shows
                        self.loadMoreSimilarTVShowsConnectionError = true
                        // Tell view that more similar tv shows are loaded
                        self.loadMoreSimilarTVShowsAreLoaded = true
                    }
                }
            }
        }
        task.resume()
    }
    
    // Gets season trailers that are on vimeo
    func setSeasonVimeoTrailers(trailers: [Trailer], seasonNumber: Int) {
        // Adds this function to the tvShowDispatchGroup
        tvShowDispatchGroup.enter()
        
        // Create an emtpy list
        var vimeoTrailers = [VimeoTrailer]()
        
        // Creates a DispatchGroup
        let seasonVimeoTrailerDispatchGroup = DispatchGroup()
        
        // Fetches the video file url on the vimeo website
        trailers.forEach { trailer in
            
            // Adds this function to the seasonVimeoTrailerDispatchGroup
            seasonVimeoTrailerDispatchGroup.enter()
            
            // Sets the url to request
            let url = URL(string: "https://player.vimeo.com/video/\(trailer.key)/config")
            
            // Sets the request
            var request = URLRequest(url: url!)
            // Sets the request method to a GET method
            request.httpMethod = "GET"
            
            // Performs the url request
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                
                // Check for connection error
                if (error != nil) {
                    DispatchQueue.main.async {
                        // Tells the view that there is a season connection error
                        self.seasonConnectionError = true
                        // Removes this function from the seasonVimeoTrailerDispatchGroup
                        seasonVimeoTrailerDispatchGroup.leave()
                    }
                }
                
                // Sets the response from server
                if let response = response as? HTTPURLResponse {
                    // If success
                    if response.statusCode == 200 {
                        // Decodes JSON
                        let vimeoTrailer = try! JSONDecoder().decode(VimeoTrailer.self, from: data!)
                        
                        DispatchQueue.main.async {
                            // Adds vimeoTrailer to vimeoTrailers list
                            vimeoTrailers.append(vimeoTrailer)
                            // Removes this function from the seasonVimeoTrailerDispatchGroup
                            seasonVimeoTrailerDispatchGroup.leave()
                        }
                    } else {
                        DispatchQueue.main.async {
                            // Tells the view that there is a season connection error
                            self.seasonConnectionError = true
                            // Removes this function from the seasonVimeoTrailerDispatchGroup
                            seasonVimeoTrailerDispatchGroup.leave()
                        }
                    }
                }
            }
            task.resume()
        }
        
        seasonVimeoTrailerDispatchGroup.notify(queue: .main) {
            // Set vimeo trailers
            self.tvShow?.seasons![seasonNumber-1].vimeoTrailers = vimeoTrailers
            // Removes this function from the tvShowDispatchGroup
            self.tvShowDispatchGroup.leave()
        }
    }

}
