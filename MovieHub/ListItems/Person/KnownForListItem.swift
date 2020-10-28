//
//  KnownForListItem.swift
//  MovieHub
//
//  Created by Ronnie Arvanites on 10/20/20.
//

import SwiftUI
import SDWebImageSwiftUI

// Displays known for detail
struct KnownForListItem: View {
    
    var knownFor: KnownFor
    var imageWidth: CGFloat = 175
    var imageHeight: CGFloat = 262.5
    
    var body: some View {
        // Check if type is movie or tv show
        if knownFor.type == "movie" {
            // Displays MovieView when tapped on
            NavigationLink(destination: LazyView { MovieView(movieId: knownFor.id)}) {
                VStack{
                    /*
                     Movie Title
                     */
                    Text(knownFor.title)
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
                    if knownFor.posterURL != nil {
                        WebImage(url: URL(string: "\(Globals.imageBaseURL)original\(knownFor.posterURL!)"))
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
                     Character
                     */
                    // Check if character is nil or empty
                    if knownFor.role != nil && !knownFor.role!.isEmpty {
                        Text("as \(knownFor.role!)")
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
        } else {
            // If type is tv show
            // Displays TVShowView when tapped on
            NavigationLink(destination: LazyView { TVShowView(tvShowId: knownFor.id)}){
                VStack{
                    /*
                     TV Show Name
                     */
                    Text(knownFor.title)
                        .font(.system(size: 15))
                        .multilineTextAlignment(.center)
                        .frame(height: 20)
                        .padding(.horizontal, 5)
                        .padding(.vertical, 5)
                        .minimumScaleFactor(0.5)
                    
                    Spacer().frame(height: 0)
                    
                    /*
                     TV Show Poster
                     */
                    // Check if tv show has a poster
                    if knownFor.posterURL != nil {
                        WebImage(url: URL(string: "\(Globals.imageBaseURL)original\(knownFor.posterURL!)"))
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
                     Character
                     */
                    // Check if character is nil or empty
                    if knownFor.role != nil && !knownFor.role!.isEmpty {
                        Text("as \(knownFor.role!)")
                            .font(.system(size: 15))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 5)
                            .padding(.bottom, 5)
                            .minimumScaleFactor(0.5)
                    }
                }
                .frame(width: 175, height: 325, alignment: .top)
                .border(Color.white, width: 1)
            }
        }
    }
}

struct KnownForListItem_Previews: PreviewProvider {
    static var previews: some View {
        KnownForListItem(knownFor: KnownFor(id: 29343, type: "Movie", title: "Men in Black", posterURL: "/uLOmOF5IzWoyrgIF5MfUnh5pa1X.jpg", voteCount: 2974, role: "Agent J")).background(Color.black)
    }
}
