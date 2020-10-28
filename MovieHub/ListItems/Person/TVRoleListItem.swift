//
//  TVRoleListItem.swift
//  MovieHub
//
//  Created by Ronnie Arvanites on 10/7/20.
//

import SwiftUI
import SDWebImageSwiftUI

// Displays the tv role
struct TVRoleListItem: View {
    
    var tvRole: TVCastRole
    var imageWidth: CGFloat = 175
    var imageHeight: CGFloat = 262.5
    
    var body: some View {
        // Displays TVShowView when tapped on
        NavigationLink(destination: LazyView { TVShowView(tvShowId: tvRole.showId)}) {
            
            VStack{
                /*
                 TV Show Name
                 */
                Text(tvRole.showTitle)
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
                if tvRole.tvPosterUrl != nil {
                    WebImage(url: URL(string: "\(Globals.imageBaseURL)original\(tvRole.tvPosterUrl!)"))
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
                // Checks if character is nil or empty
                if tvRole.character != nil && !tvRole.character!.isEmpty {
                    Text("as \(tvRole.character!)")
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

struct TVRoleListItem_Previews: PreviewProvider {
    static var previews: some View {
        TVRoleListItem(tvRole: TVCastRole(showId: 234, showTitle: "The Simpsons", tvPosterUrl: "/qcr9bBY6MVeLzriKCmJOv1562uY.jpg", character: "Homer")).background(Color.black)
    }
}
