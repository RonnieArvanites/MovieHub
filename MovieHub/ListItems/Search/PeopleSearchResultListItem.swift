//
//  PeopleSearchResultListItem.swift
//  MovieHub
//
//  Created by Ronnie Arvanites on 10/20/20.
//

import SwiftUI
import SDWebImageSwiftUI

// Displays the people search result
struct PeopleSearchResultListItem: View {
    
    var result: PeopleResult
    
    var body: some View {
        // Displays PersonView when tapped on
        NavigationLink(destination: LazyView { PersonView(personId: result.id)}) {
            
            /*
             Profile Picture
             */
            HStack(alignment: .top){
                // Check if movie poster is available
                if result.profileImageUrl != nil {
                    WebImage(url: URL(string: "\(Globals.imageBaseURL)original\(result.profileImageUrl!)"))
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
                     Name
                     */
                    Text(result.name)
                        .foregroundColor(.white)
                        .font(.system(size: 18))
                        .fontWeight(.bold)
                    
                    /*
                     Known For Department
                     */
                    // Checks if department is empty
                    if !result.department.isEmpty {
                        HStack(alignment: .top){
                            Text("Department:")
                                .font(.system(size: 13))
                                .fontWeight(.bold)
                                .frame(width: 85, alignment: .topLeading)
                            Text(result.department)
                                .font(.system(size: 13))
                                .foregroundColor(.white)
                            Spacer()
                        }
                    }
                    
                    /*
                     Known For String
                     */
                    // Checks if knownForString is empty
                    if !result.knownForString().isEmpty {
                        HStack(alignment: .top){
                            Text("Known For:")
                                .font(.system(size: 13))
                                .fontWeight(.bold)
                                .frame(width: 85, alignment: .topLeading)
                            Text(result.knownForString())
                                .foregroundColor(.white)
                                .font(.system(size: 13))
                            Spacer()
                        }
                    }
                }
                
                Spacer()
                
            }
        }
    }
}

struct PeopleSearchResultListItem_Previews: PreviewProvider {
    static var previews: some View {
        PeopleSearchResultListItem(result: PeopleResult(id: 12495, name: "Will Smith", profileImageUrl: "/eze9FO9VuryXLP0aF2cRqPCcibN.jpg", department: "Acting", knownFor: [KnownFor(id: 1256, type: "Movie" , title: "Men in Black", posterURL: "/fr8f3jfj3f3f34fd.jpg", voteCount: 2938, role: "Agent J")])).background(Color.black)
    }
}
