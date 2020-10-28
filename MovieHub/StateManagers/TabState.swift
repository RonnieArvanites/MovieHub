//
//  TabState.swift
//  MovieHub
//
//  Created by Ronnie Arvanites on 10/7/20.
//

import Foundation

// Used to keep track of tab state
class TabState: ObservableObject {
    @Published var currentTabIndex: Int = 0
}
