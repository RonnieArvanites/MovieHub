//
//  TabBar.swift
//  MovieHub
//
//  Created by Ronnie Arvanites on 10/7/20.
//

import SwiftUI

// App's tab bar
struct TabBar: View {
    
    @EnvironmentObject var tabState: TabState
    
    let deviceWidth = UIScreen.main.bounds.width
    
    let tabBarHeight: CGFloat = 45
    
    var body: some View {
        HStack{
            
            /*
             Movie Tab
             */
            Button(action: {
                // Check if already on tab 0
                if self.tabState.currentTabIndex != 0 {
                    self.tabState.currentTabIndex = 0
                }
            }) {
                VStack{
                    Image(systemName: "film")
                        .font(.system(size: 20))
                    
                    Spacer().frame(height: 1)
                    
                    Text("Movies")
                        .font(.system(size: 12))
                }
            }
            .foregroundColor(self.tabState.currentTabIndex == 0 ? Color.white : Color.white.opacity(0.5))
            
            Spacer()
            
            /*
             TV Show Tab
             */
            Button(action: {
                // Check if already on tab 1
                if self.tabState.currentTabIndex != 1 {
                    self.tabState.currentTabIndex = 1
                }
            }) {
                VStack{
                    Image(systemName: "tv")
                        .font(.system(size: 20))
                    
                    Spacer().frame(height: 1)
                    
                    Text("TV Shows")
                        .font(.system(size: 12))
                }
            }.foregroundColor(self.tabState.currentTabIndex == 1 ? Color.white : Color.white.opacity(0.5))
            
            Spacer()
            
            /*
             Search Tab
             */
            Button(action: {
                // Check if already on tab 2
                if self.tabState.currentTabIndex != 2 {
                    self.tabState.currentTabIndex = 2
                }
            }) {
                VStack{
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 20))
                    
                    Spacer().frame(height: 1)
                    
                    Text("Search")
                        .font(.system(size: 12))
                }
            }.foregroundColor(self.tabState.currentTabIndex == 2 ? Color.white : Color.white.opacity(0.5))
        }
        .padding(.top, 10)
        .padding(.horizontal, 40)
        .frame(width:deviceWidth, height: tabBarHeight)
        .background(Color.black)
    }
}

struct TabBar_Previews: PreviewProvider {
    static var previews: some View {
        TabBar()
            .environmentObject(TabState())
    }
}
