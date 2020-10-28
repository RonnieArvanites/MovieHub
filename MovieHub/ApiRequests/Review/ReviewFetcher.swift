//
//  ReviewFetcher.swift
//  MovieHub
//
//  Created by Ronnie Arvanites on 10/6/20.
//

import Foundation

// Gets the reviews from the server
class ReviewFetcher: ObservableObject {
    @Published var dataIsLoaded: Bool = false
    @Published var reviewList: ReviewList?
    @Published var connectionError: Bool = false
    @Published var loadMoreConnectionError = false
    @Published var loadMoreDataIsLoaded = false
    
    var contentId: Int
    var contentType: String
    
    init(contentId: Int, contentType: String){
        self.contentId = contentId
        self.contentType = contentType
        //Get reviews
        getReviews()
    }
    
    // Gets reviews from the server
    func getReviews(){
        
        var url: URL
        
        //Check if content type is movie or tv show
        if self.contentType == "Movie" {
            // Sets the url to request
            url = URL(string: Globals.baseURL + "/3/movie/\(self.contentId)/reviews?api_key=\(Globals.apiKey)&language=en-US&page=1")!
        } else {
            // Sets the url to request
            url = URL(string: Globals.baseURL + "/3/tv/\(self.contentId)/reviews?api_key=\(Globals.apiKey)&language=en-US&page=1")!
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
                    let reviewList = try! JSONDecoder().decode(ReviewList.self, from: data!)
                    DispatchQueue.main.async {
                        // Save review list
                        self.reviewList = reviewList
                        // Tell view that the data is loaded
                        self.dataIsLoaded = true
                    }
                } else {
                    DispatchQueue.main.async {
                        // Tells the view that there is a connection error
                        self.connectionError = true
                        // Tell view that the data is loaded
                        self.dataIsLoaded = true
                    }
                }
            }
        }
        task.resume()
    }
    
    // Checks if more reviews are needed
    func loadMoreReviewsIfNeeded(currentReview: Review){
        //Check if more reviews are avialable
        if reviewList!.page < reviewList!.totalPages {
            // Set last review to last review in review list
            let lastReview = reviewList!.reviews?.last
            //Check if currentReview is the last review in the list
            if currentReview.id == lastReview?.id {
                // Get more reviews
                getMoreReviews()
            } else {
                return
            }
        } else {
            return
        }
    }
    
    // Gets more reviews
    func getMoreReviews(){
        
        var url: URL
        
        //Check if content type is movie or tv show
        if self.contentType == "Movie" {
            // Sets the url to request
            url = URL(string: Globals.baseURL + "/3/movie/\(self.contentId)/reviews?api_key=\(Globals.apiKey)&language=en-US&page=\(self.reviewList!.page + 1)")!
        } else {
            // Sets the url to request
            url = URL(string: Globals.baseURL + "/3/tv/\(self.contentId)/reviews?api_key=\(Globals.apiKey)&language=en-US&page=\(self.reviewList!.page + 1)")!
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
                    // Tells the view there is a connection error when loading more reviews
                    self.loadMoreConnectionError = true
                    // Tell view that more reviews are loaded
                    self.loadMoreDataIsLoaded = true
                }
            }
            
            // Sets the response from server
            if let response = response as? HTTPURLResponse {
                // If success
                if response.statusCode == 200 {
                    // Decodes JSON
                    let reviewList = try! JSONDecoder().decode(ReviewList.self, from: data!)
                    DispatchQueue.main.async {
                        // Set connection error to false
                        self.loadMoreConnectionError = false
                        // Store old reviews
                        let oldReviews = self.reviewList!.reviews
                        // Save new review list
                        self.reviewList = reviewList
                        // Combine old reviews with new reviews
                        let newReviews = oldReviews! + self.reviewList!.reviews!
                        // Update review list
                        self.reviewList!.reviews = newReviews
                        // Tell view that more reviews are loaded
                        self.loadMoreDataIsLoaded = true
                    }
                } else {
                    DispatchQueue.main.async {
                        // Tells the view there is a connection error when loading more reviews
                        self.loadMoreConnectionError = true
                        // Tell view that more reviews are loaded
                        self.loadMoreDataIsLoaded = true
                    }
                }
            }
        }
        task.resume()
    }
}
