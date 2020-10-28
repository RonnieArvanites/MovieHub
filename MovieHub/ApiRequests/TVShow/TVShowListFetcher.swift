//
//  TVShowListFetcher.swift
//  MovieHub
//
//  Created by Ronnie Arvanites on 10/13/20.
//

import Foundation

// Used to fetch the tv show list based on category
class TVShowListFetcher: ObservableObject {
    
    @Published var dataIsLoaded: Bool = false
    @Published var tvShowList: TVShowList? = nil
    @Published var connectionError: Bool = false
    @Published var loadMoreConnectionError = false
    @Published var loadMoreDataIsLoaded = false
    
    var categoryId: Int
    
    init(categoryId: Int){
        self.categoryId = categoryId
        // Get tv show list
        getTVShowList()
    }
    
    // Used to get tv show list based on the category
    func getTVShowList() {
        
        var url: URL
        
        // Assigns the url based on the categoryId (0)Most Popular, (1)Top Rated, (2)On the air, (3)Trending, default is the url with the categoryId parameter
        switch self.categoryId {
        case 0:
            url = URL(string: Globals.baseURL + "/3/tv/popular?api_key=\(Globals.apiKey)&language=en-US")!
            
        case 1:
            url = URL(string: Globals.baseURL + "/3/tv/top_rated?api_key=\(Globals.apiKey)&language=en-US")!
            
        case 2:
            url = URL(string: Globals.baseURL + "/3/tv/on_the_air?api_key=\(Globals.apiKey)&language=en-US")!
        case 3:
            url = URL(string: Globals.baseURL + "/3/trending/tv/week?api_key=\(Globals.apiKey)")!
            
        default:
            url = URL(string: Globals.baseURL + "/3/discover/tv?api_key=\(Globals.apiKey)&language=en-US&with_genres=\(self.categoryId)&include_null_first_air_dates=false")!
            
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
                    let tvShows = try! JSONDecoder().decode(TVShowList.self, from: data!)
                    
                    DispatchQueue.main.async {
                        // Saves the tv shows returned from the server
                        self.tvShowList = tvShows
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
    
    // Used to check if more tv shows need to be loaded
    func loadMoreTVShowsIfNeeded(currentTVShow: TVShowTile){
        // Check if more tv shows are available
        if tvShowList!.page < tvShowList!.totalPages {
            let lastTVShow = tvShowList!.tvShows.last
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
    func getMoreTVShows() {
        
        var url: URL
        
        // Assigns the url based on the categoryId (0)Most Popular, (1)Top Rated, (2)On the air, (3)Trending, default is the url with the categoryId parameter
        
        switch self.categoryId {
        case 0:
            url = URL(string: Globals.baseURL + "/3/tv/popular?api_key=\(Globals.apiKey)&language=en-US&page=\(tvShowList!.page + 1)")!
            
        case 1:
            url = URL(string: Globals.baseURL + "/3/tv/top_rated?api_key=\(Globals.apiKey)&language=en-US&page=\(tvShowList!.page + 1)")!
            
        case 2:
            url = URL(string: Globals.baseURL + "/3/tv/on_the_air?api_key=\(Globals.apiKey)&language=en-US&page=\(tvShowList!.page + 1)")!
            
        case 3:
            url = URL(string: Globals.baseURL + "/3/trending/tv/week?api_key=\(Globals.apiKey)&page=\(tvShowList!.page + 1)")!
            
        default:
            url = URL(string: Globals.baseURL + "/3/discover/tv?api_key=\(Globals.apiKey)&language=en-US&page=\(tvShowList!.page + 1)&with_genres=\(self.categoryId)&include_null_first_air_dates=false")!
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
                
                // If success
                if response.statusCode == 200 {
                    // Decodes JSON
                    let tvShows = try! JSONDecoder().decode(TVShowList.self, from: data!)
                    DispatchQueue.main.async {
                        // Store old tv shows
                        let oldTVShows = self.tvShowList!.tvShows
                        // Save new tv show list
                        self.tvShowList = tvShows
                        // Combine old tv shows with new tv shows
                        let newTVShows = oldTVShows + self.tvShowList!.tvShows
                        // Update tv show list
                        self.tvShowList?.tvShows = newTVShows
                        // Tells data is loaded
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
