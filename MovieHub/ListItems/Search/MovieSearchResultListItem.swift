//
//  MovieSearchResultListItem.swift
//  MovieHub
//
//  Created by Ronnie Arvanites on 10/20/20.
//

import SwiftUI
import SDWebImageSwiftUI

// Displays the movie search result
struct MovieSearchResultListItem: View {
    
    var result: MovieResult
    
    var body: some View {
        // Displays MovieView when tapped on
        NavigationLink(destination: LazyView { MovieView(movieId: result.id)}) {
            
            /*
             Movie Poster
             */
            HStack(alignment: .top){
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
                     Movie Title
                     */
                    Text(result.title)
                        .foregroundColor(.white)
                        .font(.system(size: 18))
                        .fontWeight(.bold)
                    
                    /*
                     Movie Overview
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

struct MovieSearchResultListItem_Previews: PreviewProvider {
    static var previews: some View {
        MovieSearchResultListItem(result: MovieResult(id: 9758, posterURL: "/y95lQLnuNKdPAzw9F9Ab8kJ80c3.jpg", title: "Bad Boys for Life", overview: "Marcus and Mike are forced to confront new threats, career changes, and midlife crises as they join the newly created elite team AMMO of the Miami police department to take down the ruthless Armando Armas, the vicious leader of a Miami drug cartel.")).background(Color.black)
    }
}
