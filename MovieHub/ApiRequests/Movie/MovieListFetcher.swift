//
//  MovieListFetcher.swift
//  MovieHub
//
//  Created by Ronnie Arvanites on 10/2/20.
//

import Foundation

// Used to fetch the movie list based on category
class MovieListFetcher: ObservableObject {
    
    @Published var dataIsLoaded: Bool = false
    @Published var movieList: MovieList? = nil
    @Published var connectionError: Bool = false
    @Published var loadMoreConnectionError: Bool = false
    @Published var loadMoreDataIsLoaded: Bool = false
    
    var categoryId: Int
    
    init(categoryId: Int){
        self.categoryId = categoryId
        // Get movie list
        getMovieList()
    }
    
    // Used to get movie list based on the category
    func getMovieList(){
        
        var url: URL
        
        // Assigns the url based on the categoryId (0)Most Popular, (1)Top Rated, (2)Upcoming, (3)Trending, (4)Now playing, default is the url with the categoryId parameter
        switch self.categoryId {
        
        case 0:
            url = URL(string: Globals.baseURL + "/3/movie/popular?api_key=\(Globals.apiKey)&language=en-US")!
            
        case 1:
            url = URL(string: Globals.baseURL + "/3/movie/top_rated?api_key=\(Globals.apiKey)&language=en-US")!
            
        case 2:
            url = URL(string: Globals.baseURL + "/3/movie/upcoming?api_key=\(Globals.apiKey)&language=en-US&region=US")!
            
        case 3:
            url = URL(string: Globals.baseURL + "/3/trending/movie/week?api_key=\(Globals.apiKey)")!
            
        case 4:
            url = URL(string: Globals.baseURL + "/3/movie/now_playing?api_key=\(Globals.apiKey)&language=en-US&region=US")!
            
        default:
            url = URL(string: Globals.baseURL + "/3/discover/movie?api_key=\(Globals.apiKey)&language=en-US&include_adult=false&include_video=false&page=1&with_genres=\(self.categoryId)")!
            
        }
        
        // Sets the request
        var request = URLRequest(url: url)
        // Sets the request method to a GET method
        request.httpMethod = "GET"
        
        // Performs the url request
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            // Check for connection error
            if (error != nil) {
                DispatchQueue.main.async {
                    // Tells the view that there is a connection error
                    self.connectionError = true
                    // Tells the view that the data is loaded
                    self.dataIsLoaded = true
                }
            }
            
            // Sets the response from server
            if let response = response as? HTTPURLResponse {
                // If success
                if response.statusCode == 200 {
                    // Decodes JSON
                    let movies = try! JSONDecoder().decode(MovieList.self, from: data!)
                    
                    DispatchQueue.main.async {
                        // Saves the movies returned from the server
                        self.movieList = movies
                        // Tells the view that the data is loaded
                        self.dataIsLoaded = true
                    }
                } else {
                    DispatchQueue.main.async {
                        // Tells the view that the there is a connect error
                        self.connectionError = true
                        // Tells the view that the data is loaded
                        self.dataIsLoaded = true
                    }
                }
            }
        }
        task.resume()
    }
    
    // Used to check if more movies need to be loaded
    func loadMoreMoviesIfNeeded(currentMovie: MovieTile){
        // Check if more movies are available
        if movieList!.page < movieList!.totalPages {
            // Set last movie to last movie in movie results list
            let lastMovie = movieList!.movies.last
            // Checks if current movie is last movie in movie results list
            if currentMovie.id == lastMovie?.id {
                // Get more movies
                getMoreMovies()
            } else {
                return
            }
        } else {
            return
        }
    }
    
    // Used to get more movies from the server
    func getMoreMovies(){
        
        var url: URL
        
        // Assigns the url based on the categoryId (0)Most Popular, (1)Top Rated, (2)Upcoming, (4)Now playing, default is the url with the categoryId parameter
        switch self.categoryId {
        
        case 0:
            url = URL(string: Globals.baseURL + "/3/movie/popular?api_key=\(Globals.apiKey)&language=en-US&page=\(movieList!.page + 1)")!
            
        case 1:
            url = URL(string: Globals.baseURL + "/3/movie/top_rated?api_key=\(Globals.apiKey)&language=en-US&page=\(movieList!.page + 1)")!
            
        case 2:
            url = URL(string: Globals.baseURL + "/3/movie/upcoming?api_key=\(Globals.apiKey)&language=en-US&region=US&page=\(movieList!.page + 1)")!
            
        case 3:
            url = URL(string: Globals.baseURL + "/3/trending/movie/week?api_key=\(Globals.apiKey)&page=\(movieList!.page + 1)")!
            
        case 4:
            url = URL(string: Globals.baseURL + "/3/movie/now_playing?api_key=\(Globals.apiKey)&language=en-US&region=US&page=\(movieList!.page + 1)")!
        default:
            url = URL(string: Globals.baseURL + "/3/discover/movie?api_key=\(Globals.apiKey)&language=en-US&include_adult=false&include_video=false&page=\(movieList!.page + 1)&with_genres=\(self.categoryId)")!
            
        }
        
        // Sets the request
        var request = URLRequest(url: url)
        // Sets the request method to a GET method
        request.httpMethod = "GET"
        
        // Performs the url request
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            // Check for connection error
            if (error != nil) {
                DispatchQueue.main.async {
                    // Tells the view there is a connection error when loading more data
                    self.loadMoreConnectionError = true
                    // Tell view the data is loaded
                    self.loadMoreDataIsLoaded = true
                }
            }
            
            // Sets the response from server
            if let response = response as? HTTPURLResponse {
                
                //If success
                if response.statusCode == 200 {
                    // Decodes JSON
                    let movies = try! JSONDecoder().decode(MovieList.self, from: data!)
                    DispatchQueue.main.async {
                        // Store old movies
                        let oldMovies = self.movieList!.movies
                        // Save new movie list
                        self.movieList = movies
                        // Combine old movies with new movies
                        let newMovies = oldMovies + self.movieList!.movies
                        // Update movie list
                        self.movieList?.movies = newMovies
                        // Tell view the data is loaded
                        self.loadMoreDataIsLoaded = true
                    }
                } else {
                    DispatchQueue.main.async {
                        // Tell view there is a connection error
                        self.loadMoreConnectionError = true
                        // Tell view the data is loaded
                        self.loadMoreDataIsLoaded = true
                    }
                }
            }
        }
        task.resume()
    }
}
