//
//  AutoCompleteFetcher.swift
//  MovieHub
//
//  Created by Ronnie Arvanites on 10/18/20.
//

import Foundation

// Gets multi search results from server
class AutoCompleteFetcher: ObservableObject {
    
    @Published var connectionError: Bool = false
    @Published var resultsAreLoaded: Bool = false
    @Published var autoCompleteResults: AutoCompleteResultList? = nil
    
    // Gets results from server for the given searchString
    func getAutoComplete(searchString: String){
        
        // Percent encodes search string
        let searchString = searchString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
        // Sets the url to request
        let url = URL(string: Globals.baseURL + "/3/search/multi?api_key=\(Globals.apiKey)&language=en-US&query=\(searchString)&include_adult=false")
        
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
                    // Tells the view that the results are loaded
                    self.resultsAreLoaded = true
                }
            }
            
            // Sets the response from server
            if let response = response as? HTTPURLResponse {
                
                // If success
                if response.statusCode == 200 {
                    // Decodes JSON
                    var autoCompleteResults = try! JSONDecoder().decode(AutoCompleteResultList.self, from: data!)
                    // Checks if results is empty
                    if !autoCompleteResults.results.isEmpty {
                        // Creates an empty list
                        var duplicatesRemovedResults = [AutoCompleteResult]()
                        // Loops through each item in the autoComplete results
                        autoCompleteResults.results.forEach { result in
                            // Check if the duplicatesRemovedResults list contains the result
                            if !duplicatesRemovedResults.contains(where: {$0.name == result.name}){
                                // Adds result to the duplicatesRemovedResults list
                                duplicatesRemovedResults.append(result)
                            }
                        }
                        // Saves the result list without duplicates
                        autoCompleteResults.results = duplicatesRemovedResults
                    }
                    DispatchQueue.main.async {
                        // Saves the autocomplete list
                        self.autoCompleteResults = autoCompleteResults
                        // Tells the view the results are loaded
                        self.resultsAreLoaded = true
                    }
                } else {
                    DispatchQueue.main.async {
                        // Tells the view that there is a connection error
                        self.connectionError = true
                        // Tells the view the results are loaded
                        self.resultsAreLoaded = true
                    }
                }
            }
        }
        task.resume()
    }
}
