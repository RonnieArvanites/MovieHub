//
//  MovieGridItem.swift
//  MovieHub
//
//  Created by Ronnie Arvanites on 10/3/20.
//

import SwiftUI
import SDWebImageSwiftUI

// Displays movie poster
struct MovieGridItem: View {
    
    var movie: MovieTile
    var itemWidth: CGFloat = 175
    var itemHeigth: CGFloat = 262.5 //Chose this value to keep same aspect ratio as 2:3
    
    
    var body: some View {
        // Displays MovieView when tapped on
        NavigationLink(destination: LazyView { MovieView(movieId: movie.id)}) {
            
            VStack{
                /*
                 Movie Poster
                 */
                // Check if movie has a poster
                if movie.posterURL != nil {
                    WebImage(url: URL(string: "\(Globals.imageBaseURL)original\(movie.posterURL!)"))
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: itemWidth, height: itemHeigth, alignment: .center)
                        .clipped()
                } else {
                    Image("NoImage")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: itemWidth, height: itemHeigth, alignment: .center)
                        .clipped()
                }
            }
            .frame(width: itemWidth, height: itemHeigth, alignment: .center)
        }
    }
}

struct MovieGridItem_Previews: PreviewProvider {
    static var previews: some View {
        MovieGridItem(movie: MovieTile(id: 337401, posterURL: "/aKx1ARwG55zZ0GpRvU2WrGrCG9o.jpg"))
    }
}
