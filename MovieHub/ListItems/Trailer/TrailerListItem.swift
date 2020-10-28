//
//  TrailerListItem.swift
//  MovieHub
//
//  Created by Ronnie Arvanites on 10/5/20.
//

import SwiftUI
import AVKit

// Displays trailer
struct TrailerListItem: View {
    
    @State var videoReady: Bool = false
    
    @State var shouldPauseVideo: Bool = false
    
    var youtubeTrailer: Trailer?
    
    var vimeoTrailer: VimeoTrailer?
    
    @EnvironmentObject var tabState: TabState
    
    @EnvironmentObject var trailerTabState: TrailerPageState
    
    var body: some View {
        ZStack{
            // Check if trailer is on vimeo or youtube
            if vimeoTrailer != nil {
                /*
                 Vimeo Player
                 */
                VimeoPlayerView(url: vimeoTrailer!.contentUrl!.url, title: vimeoTrailer!.title, shareUrl: vimeoTrailer!.shareUrl)
            } else if youtubeTrailer != nil {
                /*
                 Youtube player
                 */
                YoutubePlayerView(videoReady: self.$videoReady, shouldPauseVideo: self.$shouldPauseVideo, videoKey: self.youtubeTrailer!.key)
                    // Checks if user swiped to another trailer
                    .onReceive(self.trailerTabState.objectWillChange) { value in
                        // Pauses trailer
                        self.shouldPauseVideo = true
                    }
                    //Checks if user tapped another tab
                    .onReceive(self.tabState.objectWillChange) { value in
                        // Pauses trailer
                        self.shouldPauseVideo = true
                    }
                
                /*
                 Loading Icon
                 */
                // Check if video is ready
                if !videoReady {
                    LoadingIcon(isAnimating: true, style: .medium, color: UIColor.white)
                }
            }
        }
        .frame(width: UIScreen.main.bounds.width, height: (0.56 * UIScreen.main.bounds.width))
    }
}

struct TrailerListItem_Previews: PreviewProvider {
    static var previews: some View {
        TrailerListItem(youtubeTrailer: Trailer(name: "Official Trailer", site: "YouTube", key: "jKCj3XuPG8M", type: "Video"))
            .environmentObject(TabState())
            .environmentObject(TrailerPageState())
    }
}
