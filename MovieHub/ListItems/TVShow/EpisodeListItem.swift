//
//  EpisodeListItem.swift
//  MovieHub
//
//  Created by Ronnie Arvanites on 10/14/20.
//

import SwiftUI
import SDWebImageSwiftUI

// Displays Episode Information
struct EpisodeListItem: View {
    
    var episode: Episode
    var itemWidth: CGFloat = UIScreen.main.bounds.width
    var itemHeight: CGFloat = 200
    
    var body: some View {
        VStack{
            
            Spacer().frame(height:0)
            
            /*
             Episode Thumbnail
             */
            if self.episode.thumbnailURL != nil {
                WebImage(url: URL(string: "\(Globals.imageBaseURL)original\(self.episode.thumbnailURL!)"))
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: itemWidth, height: itemHeight, alignment: .center)
                    .clipped()
            } else {
                Image("NoImage")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: itemWidth, height: itemHeight, alignment: .center)
                    .clipped()
            }
            
            Spacer().frame(height: 5)
            
            VStack(alignment: .leading){
                /*
                 Episode Number and Name
                 */
                Text("Episode \(self.episode.episodeNumber): \(self.episode.name)")
                    .font(.system(size: 18))
                    .fontWeight(.bold)
                
                /*
                 Episode Overview
                 */
                Text(self.episode.overview)
                    .font(.system(size: 15))
                    .fixedSize(horizontal: false, vertical: true)
                /*
                 Episode Aired Date
                 */
                // Checks if episode air date is not nil
                if self.episode.airDate != nil {
                    HStack{
                        Text("Aired:")
                            .font(.system(size: 15))
                            .fontWeight(.bold)
                            .frame(width: 50, alignment: .topLeading)
                        Text("\(self.episode.airDate!.toMDYString())")
                            .font(.system(size: 15))
                    }
                    
                }
                
                /*
                 Episode Score
                 */
                // Check if episode has a score
                if self.episode.voteCount != 0 {
                    HStack{
                        Text("Score:")
                            .font(.system(size: 15))
                            .fontWeight(.bold)
                            .frame(width: 50, alignment: .topLeading)
                        ScoreIcon(score: (self.episode.score / 10) * 100)
                    }
                }
                
                Spacer().frame(height:5)
                
            }
            .frame(width: UIScreen.main.bounds.width, alignment: .leading)
        }
    }
}

struct EpisodeListItem_Previews: PreviewProvider {
    static var previews: some View {
        EpisodeListItem(episode: Episode(id: 973085, episodeNumber: 2, name: "Earth Skills", airDate: DateFormatter().date(from: "2014-03-26"), overview: "Discovering that Jasper may still be alive, Clarke, Bellamy, Finn, Wells and Murphy head out to find him. On the Ark, Abby is determined to prove Earth is habitable, and enlists a mechanic to craft an escape pod.", thumbnailURL: "/vH0hZ9eZjAeEPX5bNgZLLeCaegw.jpg", score: 5.921, voteCount: 38))
            .foregroundColor(Color.white)
            .background(Color.black)
    }
}
