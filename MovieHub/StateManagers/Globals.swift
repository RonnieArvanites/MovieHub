//
//  Globals.swift
//  MovieHub
//
//  Created by Ronnie Arvanites on 10/2/20.
//

import Foundation
import SwiftUI

// Global Variables
struct Globals {
    static var baseURL = "https://api.themoviedb.org"
    static var imageBaseURL = "https://image.tmdb.org/t/p/"
    static var apiKey: String = "65fa0814fa58c30a39ea872866fe9628"
    static var navBarHeight: CGFloat = 45
}

// Date Extension
extension Date {
    
    // Returns date to string in the format July 31, 1956
    func toMDYString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        return dateFormatter.string(from: self)
        
    }
    
    // Returns the current age of a person
    func getAge() -> Int {
        // Gets current date
        let now = Date()
        let calendar = Calendar.current
        
        // Calculates age
        let ageComponents = calendar.dateComponents([.year], from: self, to: now)
        let age = ageComponents.year!
        
        // Returns age
        return age
    }
    
    // Returns the death age of a person
    func getDeathAge(birthday: Date) -> Int {
        // Sets the calendar to current calendar
        let calendar = Calendar.current

        // Calculates death age
        let ageComponents = calendar.dateComponents([.year], from: birthday, to: self)
        let age = ageComponents.year!
        // Returns death age
        
        return age
    }
}

// UIApplication extension
extension UIApplication {
    // Closes keyboard
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
