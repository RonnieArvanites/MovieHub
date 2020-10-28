//
//  MovieHubApp.swift
//  MovieHub
//
//  Created by Ronnie Arvanites on 10/2/20.
//

import SwiftUI

@main
struct MovieHubApp: App {
    let persistenceController = PersistenceController.shared
    let tabState = TabState()
    let trailerTabState = TrailerPageState()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(tabState)
                .environmentObject(trailerTabState)
        }
    }
}
