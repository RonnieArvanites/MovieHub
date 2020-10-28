//
//  MovieRoleListItem.swift
//  MovieHub
//
//  Created by Ronnie Arvanites on 10/7/20.
//

import SwiftUI
import SDWebImageSwiftUI

// Displays the movie role
struct MovieRoleListItem: View {
    
    var movieRole: MovieCastRole
    var imageWidth: CGFloat = 175
    var imageHeight: CGFloat = 262.5
    
    var body: some View {
        // Displays MovieView when tapped on
        NavigationLink(destination: LazyView { MovieView(movieId: movieRole.movieId)}){
            
            VStack{
                /*
                 Movie Title
                 */
                Text(movieRole.movieTitle)
                    .font(.system(size: 15))
                    .multilineTextAlignment(.center)
                    .frame(height: 20)
                    .padding(.horizontal, 5)
                    .padding(.vertical, 5)
                    .minimumScaleFactor(0.5)
                
                Spacer().frame(height: 0)
                
                /*
                 Movie Poster
                 */
                // Check if movie has a poster
                if movieRole.moviePosterUrl != nil {
                    WebImage(url: URL(string: "\(Globals.imageBaseURL)original\(movieRole.moviePosterUrl!)"))
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: imageWidth, height: imageHeight, alignment: .center)
                        .clipped()
                } else {
                    Image("NoImage")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: imageWidth, height: imageHeight, alignment: .center)
                        .clipped()
                }
                
                Spacer().frame(height: 5)
                
                /*
                 Character Name
                 */
                // Check if character is nil or empty
                if movieRole.character != nil && !movieRole.character!.isEmpty {
                    Text("as \(movieRole.character!)")
                        .font(.system(size: 15))
                        .padding(.horizontal, 5)
                        .padding(.bottom, 5)
                        .minimumScaleFactor(0.5)
                        .multilineTextAlignment(.center)
                }
            }
            .frame(width: 175, height: 325, alignment: .top)
            .border(Color.white, width: 1)
        }
    }
}

struct MovieRoleListItem_Previews: PreviewProvider {
    static var previews: some View {
        MovieRoleListItem(movieRole: MovieCastRole(movieId: 420817, movieTitle: "Aladdin", character: "Genie", moviePosterUrl: "/ykUEbfpkf8d0w49pHh0AD2KrT52.jpg")).background(Color.black)
    }
}
