//
//  PersonFetcher.swift
//  MovieHub
//
//  Created by Ronnie Arvanites on 10/6/20.
//

import Foundation

class PersonFetcher: ObservableObject {
    
    @Published var dataIsLoaded: Bool = false
    @Published var person: Person? = nil
    @Published var connectionError: Bool = false
    
    var personId: Int
    
    init(personId: Int){
        self.personId = personId
        // Get person data
        getPersonData()
    }
    
    // Get person detail from server
    func getPersonData(){
        
        // Sets the url to request
        let url = URL(string: Globals.baseURL + "/3/person/\(personId)?api_key=\(Globals.apiKey)&language=en-US&append_to_response=movie_credits,tv_credits,combined_credits")
        
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
                    // Tells the view that the data is loaded
                    self.dataIsLoaded = true
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
                    let person = try! decoder.decode(Person.self, from: data!)
                    DispatchQueue.main.async {
                        // Saves person data from server
                        self.person = person
                        // Tells the view that the data is loaded
                        self.dataIsLoaded = true
                    }
                } else {
                    DispatchQueue.main.async {
                        // Tells the view that there is a connection error
                        self.connectionError = true
                        // Tells the view that the data is loaded
                        self.dataIsLoaded = true
                    }
                }
            }
        }
        task.resume()
    }
    
}
