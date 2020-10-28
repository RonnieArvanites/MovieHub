//
//  TVShowSearchResultListItem.swift
//  MovieHub
//
//  Created by Ronnie Arvanites on 10/20/20.
//

import SwiftUI
import SDWebImageSwiftUI

// Displays the tv show search result
struct TVShowSearchResultListItem: View {
    
    var result: TVShowResult
    
    var body: some View {
        // Displays TVShowView when tapped on
        NavigationLink(destination: LazyView { TVShowView(tvShowId: result.id)}) {
            
            /*
             TV Show Poster
             */
            HStack(alignment: .top) {
                // Check if movie poster is available
                if result.posterURL != nil {
                    WebImage(url: URL(string: "\(Globals.imageBaseURL)original\(result.posterURL!)"))
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 100, height: 150, alignment: .center)
                        .clipped()
                } else {
                    Image("NoImage")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 100, height: 150, alignment: .center)
                        .clipped()
                }
                
                VStack(alignment: .leading){
                    /*
                     TV Show Name
                     */
                    Text(result.name)
                        .foregroundColor(.white)
                        .font(.system(size: 18))
                        .fontWeight(.bold)
                    
                    /*
                     TV Show Overview
                     */
                    Text(result.overview)
                        .foregroundColor(.white)
                        .font(.system(size: 13))
                }
                
                Spacer()
                
            }
        }
        
    }
}

struct TVShowSearchResultListItem_Previews: PreviewProvider {
    static var previews: some View {
        TVShowSearchResultListItem(result: TVShowResult(id: 9475, posterURL: "/qgjP2OrrX9gc6M270xdPnEmE9tC.jpg", name: "The Walking Dead", overview: "Sheriff's deputy Rick Grimes awakens from a coma to find a post-apocalyptic world dominated by flesh-eating zombies. He sets out to find his family and encounters many other survivors along the way."))
            .background(Color.black)
    }
}
