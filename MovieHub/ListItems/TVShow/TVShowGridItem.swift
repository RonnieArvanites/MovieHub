//
//  TVShowGridItem.swift
//  MovieHub
//
//  Created by Ronnie Arvanites on 10/13/20.
//

import SwiftUI
import SDWebImageSwiftUI

// Displays tv show poster
struct TVShowGridItem: View {
    
    var tvShow: TVShowTile
    var itemWidth: CGFloat = 175
    var itemHeigth: CGFloat = 262.5 //Chose this value to keep same aspect ratio as 2:3
    
    var body: some View {
        // Displays TVShowView when tapped on
        NavigationLink(destination: LazyView { TVShowView(tvShowId: tvShow.id)}) {
            
            VStack{
                /*
                 TV Show Poster
                 */
                // Check if tv show has a poster
                if tvShow.posterURL != nil {
                    WebImage(url: URL(string: "\(Globals.imageBaseURL)original\(tvShow.posterURL!)"))
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

struct TVShowGridItem_Previews: PreviewProvider {
    static var previews: some View {
        TVShowGridItem(tvShow: TVShowTile(id: 75006, posterURL: "/scZlQQYnDVlnpxFTxaIv2g0BWnL.jpg"))
    }
}
