//
//  SeasonState.swift
//  MovieHub
//
//  Created by Ronnie Arvanites on 10/15/20.
//

import Foundation

// Used to keep track of the season state
class SeasonState: ObservableObject {
    @Published var currentSeason: Int = 1
}
