//
//  TrailerTabState.swift
//  MovieHub
//
//  Created by Ronnie Arvanites on 10/10/20.
//

import Foundation

// Used to keep track of the trailer page state
class TrailerPageState: ObservableObject {
    @Published var currentPageIndex: Int = 0
}
