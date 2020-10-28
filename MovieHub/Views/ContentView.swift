//
//  ContentView.swift
//  MovieHub
//
//  Created by Ronnie Arvanites on 10/2/20.
//

import SwiftUI
//import CoreData

// Main app view
struct ContentView: View {
    
    @EnvironmentObject var tabState: TabState
    
    var body: some View {
            VStack{
                /*
                 App Tabs
                 */
                ZStack{
                    /*
                     MovieCategoriesView
                     */
                    MovieCategoriesView()
                        .opacity(tabState.currentTabIndex == 0 ? 1:0)
                    /*
                     TVShowCategoriesView
                     */
                    TVShowCategoriesView()
                        .opacity(tabState.currentTabIndex == 1 ? 1:0)
                    /*
                     SearchView
                     */
                    SearchView()
                        .opacity(tabState.currentTabIndex == 2 ? 1:0)
                }
            
                Spacer().frame(height: 0)
                
                /*
                 Tab Bar
                 */
                TabBar()
            }
            .ignoresSafeArea(.keyboard, edges: .bottom)
            .navigationBarTitle("")
            .navigationBarHidden(true)
            .background(Color.black
                            .edgesIgnoringSafeArea(.all))
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(TabState())
    }
}
