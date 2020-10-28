//
//  MovieFetcher.swift
//  MovieHub
//
//  Created by Ronnie Arvanites on 10/3/20.
//

import Foundation

// Used to fetch movie detail
class MovieFetcher: ObservableObject {
    
    @Published var dataIsLoaded: Bool = false
    @Published var movie: Movie? = nil
    @Published var connectionError: Bool = false
    @Published var loadMoreSimilarMoviesConnectionError = false
    @Published var loadMoreSimilarMoviesAreLoaded = false
    
    var movieId: Int
    let movieDispatchGroup = DispatchGroup()
    
    init(movieId: Int){
        self.movieId = movieId
        // Get movie detail
        getMovieData()
        // Tells view the data is loaded
        movieDispatchGroup.notify(queue: .main) {
                self.dataIsLoaded = true
        }
    }
    
    // Gets the collection the movie is in
    func getCollection(collectionId: Int){
        
        // Adds this function to the movieDispatchGroup
        movieDispatchGroup.enter()
        
        // Sets the url to request
        let url = URL(string: Globals.baseURL + "/3/collection/\(collectionId)?api_key=\(Globals.apiKey)&language=en-US")
        
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
                    // Removes this function from the movieDispatchGroup
                    self.movieDispatchGroup.leave()
                }
            }
            
            // Sets the response from server
            if let response = response as? HTTPURLResponse {
                // If success
                if response.statusCode == 200 {
                    // Decodes JSON
                    let movieCollection = try! JSONDecoder().decode(MovieCollection.self, from: data!)
                    // Set collection movies
                    let movies = movieCollection.movies
                    DispatchQueue.main.async {
                        // Saves the collection movies returned from the server
                        self.movie?.movieCollectionMovies = movies
                        // Removes this function from the movieDispatchGroup
                        self.movieDispatchGroup.leave()
                    }
                } else {
                    DispatchQueue.main.async {
                        // Tells the view there is a connection error
                        self.connectionError = true
                        // Removes this function from the movieDispatchGroup
                        self.movieDispatchGroup.leave()
                    }
                }
            }
        }
        task.resume()
    }
    
    // Gets movie data
    func getMovieData(){
        
        // Adds this function to the movieDispatchGroup
        movieDispatchGroup.enter()
        
        // Sets the url to request
        let url = URL(string: Globals.baseURL + "/3/movie/\(self.movieId)?api_key=\(Globals.apiKey)&language=en-US&append_to_response=casts,videos,releases,similar")
        
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
                    // Removes this function from the movieDispatchGroup
                    self.movieDispatchGroup.leave()
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
                    // Decode JSON
                    var movie = try! decoder.decode(Movie.self, from: data!)
                    // Get collection movies if movie is part of a collection
                    if movie.movieCollection != nil {
                        self.getCollection(collectionId: movie.movieCollection!.id)
                    }
                    // Filter trailers for videos on vimeo
                    let vimeoTrailers = movie.trailers?.trailers.filter({$0.site == "Vimeo"})
                    // Check if movie has vimeo trailers
                    if !vimeoTrailers!.isEmpty {
                        // Get url for vimeo trialers
                        self.setVimeoTrailers(trailers: vimeoTrailers!)
                    }
                    // Filter trailers on youtube
                    let youtubeTrailers = movie.trailers?.trailers.filter({$0.site == "YouTube"})
                    // Check if movie has youtube trailers
                    if !youtubeTrailers!.isEmpty {
                        // Set the movie's youtube trailers
                        movie.youtubeTrailers = youtubeTrailers
                    }
                    DispatchQueue.main.async {
                        // Save movie data returned from the server
                        self.movie = movie
                        // Removes this function from the movieDispatchGroup
                        self.movieDispatchGroup.leave()
                    }
                } else {
                    DispatchQueue.main.async {
                        // Tells the view that there is a connection error
                        self.connectionError = true
                        // Removes this function from the movieDispatchGroup
                        self.movieDispatchGroup.leave()
                    }
                }
            }
        }
        task.resume()
    }
    
    
    // Gets the vimeo trailers url path
    func setVimeoTrailers(trailers: [Trailer]){
        
        // Adds this function to the movieDispatchGroup
        movieDispatchGroup.enter()
        
        // Creates an emtpy list
        var vimeoTrailers = [VimeoTrailer]()
        
        // Creates a DispatchGroup
        let vimeoTrailerDispatchGroup = DispatchGroup()
        
        // Fetches the video file url on the vimeo website
        trailers.forEach { trailer in
            
            // Adds this function to the vimeoTrailerDispatchGroup group
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
            // Set vimeo trailers
            self.movie?.vimeoTrailers = vimeoTrailers
            // Removes this function from the movieDispatchGroup
            self.movieDispatchGroup.leave()
        }
    }
    
    
    // Checks if more similar movies are needed
    func loadMoreSimilarMoviesIfNeeded(currentMovie: MovieTile) {
        // Check if more similar movies are available
        if self.movie!.similarMovies!.page < self.movie!.similarMovies!.totalPages {
            // Set last movie to last movie in similar movie list
            let lastMovie = self.movie!.similarMovies!.movies.last
            // Check if currentMovie is the last movie in the list
            if currentMovie.id == lastMovie?.id {
                // Get more similar movies
                self.getMoreSimilarMovies()
            } else {
                return
            }
        } else {
            return
        }
    }
    
    
    // Gets more similar movies
    func getMoreSimilarMovies(){
        
        // Sets the url to request
        let url = URL(string: Globals.baseURL + "/3/movie/\(self.movieId)/similar?api_key=\(Globals.apiKey)&language=en-US&page=\(self.movie!.similarMovies!.page + 1)")
        
        // Sets the request
        var request = URLRequest(url: url!)
        // Sets the request method to a GET method
        request.httpMethod = "GET"
        
        // Performs the url request
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            // Check for connection error
            if (error != nil) {
                DispatchQueue.main.async {
                    // Tells the view there is a connection error when loading more similar movies
                    self.loadMoreSimilarMoviesConnectionError = true
                    // Tell view that more similar movies are loaded
                    self.loadMoreSimilarMoviesAreLoaded = true
                }
            }
            
            // Sets the response from server
            if let response = response as? HTTPURLResponse {
                // If success
                if response.statusCode == 200 {
                    // Decodes JSON
                    let similarMovieList = try! JSONDecoder().decode(SimilarMoviesList.self, from: data!)
                    DispatchQueue.main.async {
                        // Set connection error to false
                        self.loadMoreSimilarMoviesConnectionError = false
                        // Store old similar movies
                        let oldSimilarMovies = self.movie!.similarMovies!.movies
                        // Save new similar movie list
                        self.movie?.similarMovies = similarMovieList
                        // Combine old similar movies with new similar movies
                        let newSimlarMovies = oldSimilarMovies + self.movie!.similarMovies!.movies
                        // Update similar movie list
                        self.movie!.similarMovies!.movies = newSimlarMovies
                        // Tells view data is loaded
                        self.loadMoreSimilarMoviesAreLoaded = true
                    }
                } else {
                    DispatchQueue.main.async {
                        // Tells the view there is a connection error when loading more similar movies
                        self.loadMoreSimilarMoviesConnectionError = true
                        // Tell view that more similar movies are loaded
                        self.loadMoreSimilarMoviesAreLoaded = true
                    }
                }
            }
        }
        task.resume()
    }
}
