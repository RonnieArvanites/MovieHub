//
//  SearchFetcher.swift
//  MovieHub
//
//  Created by Ronnie Arvanites on 10/17/20.
//

import Foundation

// Gets search results from server
class SearchFetcher: ObservableObject {
    
    var searchString: String = ""
    @Published var connectionError: Bool = false
    @Published var dataIsLoaded: Bool = false
    
    //Movie Results
    @Published var loadMoreMovieResultsConnectionError: Bool = false
    @Published var movieResults: MovieResultList? = nil
    
    //TV Show Results
    @Published var loadMoreTVShowResultsConnectionError: Bool = false
    @Published var tvShowResults: TVShowResultList? = nil
    
    //People Results
    @Published var loadMorePeopleResultsConnectionError: Bool = false
    @Published var peopleResults: PeopleResultList? = nil
    
    let searchDispatchGroup = DispatchGroup()
    
    // Gets the search results for the given searchString
    func search(searchString: String, completion: @escaping () -> Void){
        
        // Percent encodes search string
        self.searchString = searchString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        // Get movie results
        getMovieResults()
        // Get tv show results
        getTVShowResults()
        // Get people results
        getPeopleResults()
        // Tells view the data is loaded
        searchDispatchGroup.notify(queue: .main) {
                self.dataIsLoaded = true
                // Performs completion function
                completion()
        }

    }
    
    // Gets movie results from server
    func getMovieResults(){
        
        // Adds this function to the searchDispatchGroup
        searchDispatchGroup.enter()
        
        // Sets the url to request
        let url = URL(string: Globals.baseURL + "/3/search/movie?api_key=\(Globals.apiKey)&language=en-US&query=\(self.searchString)&include_adult=false")
        
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
                    // Removes this function from the searchDispatchGroup
                    self.searchDispatchGroup.leave()
                }
            }
            
            // Sets the response from server
            if let response = response as? HTTPURLResponse {
                
                // If success
                if response.statusCode == 200 {
                    // Decodes JSON
                    let movieResults = try! JSONDecoder().decode(MovieResultList.self, from: data!)
                    DispatchQueue.main.async {
                        // Saves movie results returned from server
                        self.movieResults = movieResults
                        // Removes this function from the searchDispatchGroup
                        self.searchDispatchGroup.leave()
                    }
                } else {
                    DispatchQueue.main.async {
                        // Tells the view that there is a connection error
                        self.connectionError = true
                        // Removes this function from the searchDispatchGroup
                        self.searchDispatchGroup.leave()
                    }
                }
            }
        }
        task.resume()
    }
    
    // Checks if more movies are needed
    func loadMoreMoviesIfNeeded(currentMovie: MovieResult){
        
        //Check if more movies are available
        if movieResults!.page < movieResults!.totalPages {
            // Set last movie to last movie in movie results list
            let lastMovie = movieResults!.results.last
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
        
        // Sets the url to request
        let url = URL(string: Globals.baseURL + "/3/search/movie?api_key=\(Globals.apiKey)&language=en-US&query=\(self.searchString)&page=\(self.movieResults!.page + 1)&include_adult=false")!
        
        // Sets the request
        var request = URLRequest(url: url)
        // Sets the request method to a GET method
        request.httpMethod = "GET"
        
        // Performs the url request
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            // Check for connection error
            if (error != nil) {
                DispatchQueue.main.async {
                    // Tells the view there is a connection error when loading more movies
                    self.loadMoreMovieResultsConnectionError = true
                }
            }
            
            // Sets the response from server
            if let response = response as? HTTPURLResponse {
                // If success
                if response.statusCode == 200 {
                    // Decodes JSON
                    let movieResults = try! JSONDecoder().decode(MovieResultList.self, from: data!)
                    DispatchQueue.main.async {
                        // Set connection error to false
                        self.loadMoreMovieResultsConnectionError = false
                        // Store old results
                        let oldResults = self.movieResults!.results
                        // Save new results
                        self.movieResults = movieResults
                        // Combine old results with new results
                        let newResults = oldResults + self.movieResults!.results
                        // Update movie results
                        self.movieResults!.results = newResults
                    }
                } else {
                    DispatchQueue.main.async {
                        // Tells the view there is a connection error when loading more movies
                        self.loadMoreMovieResultsConnectionError = true
                    }
                }
            }
        }
        task.resume()
    }
    
    // Gets tv show results from server
    func getTVShowResults(){
        
        // Adds this function to the searchDispatchGroup
        searchDispatchGroup.enter()
        
        // Sets the url to request
        let url = URL(string: Globals.baseURL + "/3/search/tv?api_key=\(Globals.apiKey)&language=en-US&query=\(self.searchString)&include_adult=false")!
        
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
                    // Removes this function from the searchDispatchGroup
                    self.searchDispatchGroup.leave()
                }
            }
            
            // Sets the response from server
            if let response = response as? HTTPURLResponse {
                
                // If success
                if response.statusCode == 200 {
                    // Decodes JSON
                    let tvShowResults = try! JSONDecoder().decode(TVShowResultList.self, from: data!)
                    DispatchQueue.main.async {
                        // Saves tv show results returned from server
                        self.tvShowResults = tvShowResults
                        // Removes this function from the searchDispatchGroup
                        self.searchDispatchGroup.leave()
                    }
                } else {
                    DispatchQueue.main.async {
                        // Tells the view that there is a connection error
                        self.connectionError = true
                        // Removes this function from the searchDispatchGroup
                        self.searchDispatchGroup.leave()
                    }
                }
            }
        }
        task.resume()
    }
    
    // Checks if more tv shows are needed
    func loadMoreTVShowsIfNeeded(currentTVShow: TVShowResult){
        
        //Check if more tv shows are available
        if tvShowResults!.page < tvShowResults!.totalPages {
            // Set last tv show to last tv show in tv show results list
            let lastTVShow = tvShowResults!.results.last
            // Checks if current tv show is last tv show in tv show results list
            if currentTVShow.id == lastTVShow?.id {
                // Get more tv shows
                getMoreTVShows()
            } else {
                return
            }
        } else {
            return
        }
        
    }
    
    // Used to get more tv shows from the server
    func getMoreTVShows(){
        
        // Sets the url to request
        let url = URL(string: Globals.baseURL + "/3/search/tv?api_key=\(Globals.apiKey)&language=en-US&query=\(self.searchString)&page=\(self.tvShowResults!.page + 1)&include_adult=false")!
        
        // Sets the request
        var request = URLRequest(url: url)
        // Sets the request method to a GET method
        request.httpMethod = "GET"
        
        // Performs the url request
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            // Check for connection error
            if (error != nil) {
                DispatchQueue.main.async {
                    // Tells the view there is a connection error when loading more tv shows
                    self.loadMoreTVShowResultsConnectionError = true
                }
            }
            
            // Sets the response from server
            if let response = response as? HTTPURLResponse {
                // If success
                if response.statusCode == 200 {
                    // Decodes JSON
                    let tvShowResults = try! JSONDecoder().decode(TVShowResultList.self, from: data!)
                    DispatchQueue.main.async {
                        // Set connection error to false
                        self.loadMoreTVShowResultsConnectionError = false
                        // Store old results
                        let oldResults = self.tvShowResults!.results
                        // Save new results
                        self.tvShowResults = tvShowResults
                        // Combine old results with new results
                        let newResults = oldResults + self.tvShowResults!.results
                        // Update tv show results
                        self.tvShowResults!.results = newResults
                    }
                } else {
                    DispatchQueue.main.async {
                        // Tells the view there is a connection error when loading more tv shows
                        self.loadMoreTVShowResultsConnectionError = true
                    }
                }
            }
        }
        task.resume()
    }
    
    // Gets people results from server
    func getPeopleResults(){
        
        // Adds this function to the searchDispatchGroup
        searchDispatchGroup.enter()
        
        // Sets the url to request
        let url = URL(string: Globals.baseURL + "/3/search/person?api_key=\(Globals.apiKey)&language=en-US&query=\(self.searchString)&include_adult=false")!
       
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
                    // Removes this function from the searchDispatchGroup
                    self.searchDispatchGroup.leave()
                }
            }
            
            // Sets the response from server
            if let response = response as? HTTPURLResponse {
                // If success
                if response.statusCode == 200 {
                    // Decodes JSON
                    let peopleResults = try! JSONDecoder().decode(PeopleResultList.self, from: data!)
                    DispatchQueue.main.async {
                        // Saves people results returned from server
                        self.peopleResults = peopleResults
                        // Removes this function from the searchDispatchGroup
                        self.searchDispatchGroup.leave()
                    }
                } else {
                    DispatchQueue.main.async {
                        // Tells the view that there is a connection error
                        self.connectionError = true
                        // Removes this function from the searchDispatchGroup
                        self.searchDispatchGroup.leave()
                    }
                }
            }
        }
        task.resume()
    }
    
    // Checks if more people are needed
    func loadMorePeopleIfNeeded(currentPerson: PeopleResult){
        
        //Check if more people are available
        if peopleResults!.page < peopleResults!.totalPages {
            // Set last person to last person in person results list
            let lastPerson = peopleResults!.results.last
            // Checks if current person is last person in people results list
            if currentPerson.id == lastPerson?.id {
                // Get more people
                getMorePeople()
            } else {
                return
            }
        } else {
            return
        }
    }
    
    // Used to get more people from the server
    func getMorePeople(){
        
        // Sets the url to request
        let url = URL(string: Globals.baseURL + "/3/search/person?api_key=\(Globals.apiKey)&language=en-US&query=\(self.searchString)&page=\(self.peopleResults!.page + 1)&include_adult=false")!
        
        // Sets the request
        var request = URLRequest(url: url)
        // Sets the request method to a GET method
        request.httpMethod = "GET"
        
        // Performs the url request
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            // Check for connection error
            if (error != nil) {
                DispatchQueue.main.async {
                    // Tells the view there is a connection error when loading more people
                    self.loadMorePeopleResultsConnectionError = true
                }
            }
            
            // Sets the response from server
            if let response = response as? HTTPURLResponse {
                // If success
                if response.statusCode == 200 {
                    // Decodes JSON
                    let peopleResults = try! JSONDecoder().decode(PeopleResultList.self, from: data!)
                    DispatchQueue.main.async {
                        // Set connection error to false
                        self.loadMorePeopleResultsConnectionError = false
                        // Store old results
                        let oldResults = self.peopleResults!.results
                        // Save new results
                        self.peopleResults = peopleResults
                        // Combine old results with new results
                        let newResults = oldResults + self.peopleResults!.results
                        // Update people results
                        self.peopleResults!.results = newResults
                    }
                } else {
                    DispatchQueue.main.async {
                        // Tells the view there is a connection error when loading more people
                        self.loadMorePeopleResultsConnectionError = true
                    }
                }
            }
        }
        task.resume()
    }
}
