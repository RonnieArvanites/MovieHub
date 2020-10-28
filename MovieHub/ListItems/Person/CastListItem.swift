//
//  CastListItem.swift
//  MovieHub
//
//  Created by Ronnie Arvanites on 10/4/20.
//

import SwiftUI
import SDWebImageSwiftUI

// Displays cast detail
struct CastListItem: View {
    
    var castMember: CastMember
    var imageWidth: CGFloat = 93.33
    var imageHeight: CGFloat = 140
    
    var body: some View {
        // Displays PersonView when tapped on
        NavigationLink(destination: LazyView { PersonView(personId: castMember.id)}){
        VStack{
            
            /*
             Name
             */
            Text("\(castMember.name)")
                .font(.system(size: 15))
                .multilineTextAlignment(.center)
                .frame(height: 20)
                .padding(.horizontal, 5)
                .padding(.vertical, 5)
                .minimumScaleFactor(0.5)
            
            Spacer().frame(height: 0)
            
            /*
            Profile Picture
             */
            // Check if cast member has a picture
            if castMember.profilePictureURL != nil {
                WebImage(url: URL(string: "\(Globals.imageBaseURL)original\(castMember.profilePictureURL!)"))
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
            if castMember.character != nil && !castMember.character!.isEmpty {
                Text("as \(castMember.character!)")
                    .font(.system(size: 15))
                    .padding(.horizontal, 5)
                    .padding(.bottom, 5)
                    .minimumScaleFactor(0.5)
                    .multilineTextAlignment(.center)
            }
        }
        .frame(width: 100, height: 200, alignment: .top)
        .border(Color.white, width: 1)
        }
    }
}

struct CastListItem_Previews: PreviewProvider {
    static var previews: some View {
        CastListItem(castMember: CastMember(id: 1030513, character: "Hughie Campbell", name: "Jack Quaid", profilePictureURL: "/c06rdofVnM7rIv7ATsrxfLGz5yo.jpg")).background(Color.black)
    }
}
