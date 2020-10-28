//
//  VimeoPlayerView.swift
//  MovieHub
//
//  Created by Ronnie Arvanites on 10/10/20.
//

import SwiftUI
import AVKit

// Video player for Vimeo trailers
struct VimeoPlayerView: View {
    
    @State var playerObserver : PlayerObserver
    @State var showTitle: Bool = true
    
    var url: String
    var title: String
    var shareUrl: String
    @State var player: AVPlayer
    @EnvironmentObject var trailerTabState: TrailerPageState
    @EnvironmentObject var tabState: TabState
    
    init(url: String, title: String, shareUrl: String){
        let player = AVPlayer(url: URL(string: url)!)
        self.url = url
        self.title = title
        self.shareUrl = shareUrl
        self._player = State(initialValue: player)
        self._playerObserver = State(initialValue: PlayerObserver(player: player))

    }
    
    var body: some View {
        ZStack(alignment: .topLeading){
            /*
                 Custom Video Player
             */
            CustomVideoPlayer(player: self.player)
                // Checks if user swiped to another trailer
                .onReceive(self.trailerTabState.objectWillChange) { value in
                    self.player.pause()
                }
                // Checks if user tapped another tab
                .onReceive(self.tabState.objectWillChange) { value in
                    self.player.pause()
                }
                // Checks if the trailer video was paused
                .onReceive(playerObserver.$currentStatus) { newStatus in
                                switch newStatus {
                                case .waitingToPlayAtSpecifiedRate:
                                    self.showTitle = true
                                case .paused:
                                    self.showTitle = true
                                case .playing:
                                    self.showTitle = false
                                default:
                                    print("error")
                                }
                        }
            
            /*
                Title
             */
            if self.showTitle {
                HStack{
                    Text(self.title)
                        .font(.system(size: 18))
                        .fontWeight(.bold)
                        .minimumScaleFactor(0.5)
                    
                    Spacer()
                    
                    /*
                            Share Button
                        */
                    // Check if share link is available
                    if !self.shareUrl.isEmpty{
                        Button(action: {
                                // Show more options
                                self.actionSheet()
                        }) {
                            Image(systemName: "ellipsis")
                                .font(.system(size: 25))
                                .frame(width: 30, height: 30, alignment: .center)
                        }
                        .foregroundColor(Color.white)
                        .padding(.trailing, 10)
                    }
                }
            }
        }
        .onDisappear(){
            // Pauses the player when the view disappears
            self.player.pause()
        }
    }
    
    /*
        Share action sheet
     */
    func actionSheet() {
        guard let link = URL(string: self.shareUrl) else { return }
            let actionSheet = UIActivityViewController(activityItems: [link], applicationActivities: nil)
            UIApplication.shared.windows.first?.rootViewController?.present(actionSheet, animated: true, completion: nil)
        }
}

struct VimeoPlayerView_Previews: PreviewProvider {
    static var previews: some View {
        VimeoPlayerView(url: "https://vod-progressive.akamaized.net/exp=1602359423~acl=%2Fvimeo-prod-skyfire-std-us%2F01%2F4504%2F17%2F447523697%2F1964244497.mp4~hmac=bd706c890177f26a1795b7fed28288e15f3e6de44651c73a6cc6f7e85c0eeaf7/vimeo-prod-skyfire-std-us/01/4504/17/447523697/1964244497.mp4", title: "Lost Girls & Love Hotels Trailer", shareUrl: "https://vimeo.com/447523697")
            .environmentObject(TrailerPageState())
            .environmentObject(TabState())
    }
}
