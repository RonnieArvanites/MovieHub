//
//  YoutubePlayerView.swift
//  MovieHub
//
//  Created by Ronnie Arvanites on 10/5/20.
//

import SwiftUI
import youtube_ios_player_helper

// SwiftUI wrapper for the youtube player
struct YoutubePlayerView: UIViewRepresentable {
    typealias UIViewType = YTPlayerView
    
    @Binding var videoReady: Bool
    @Binding var shouldPauseVideo: Bool
    var videoKey: String

    func makeUIView(context: Context) -> YTPlayerView {
        let playerView = YTPlayerView()
        playerView.load(
            withVideoId: videoKey,
            playerVars: ["playsinline":1]
        )
        // Removes white screen that displays before video loads
        playerView.webView?.isOpaque = false
        playerView.webView?.backgroundColor = UIColor.clear
        
        playerView.delegate = context.coordinator
        return playerView
    }

    func updateUIView(_ uiView: YTPlayerView, context: Context) {
        // Checks if video should be paused
        if shouldPauseVideo {
            // Pauses video if tab changed
            uiView.pauseVideo()
            // Reset shouldPauseVideo variable
            self.shouldPauseVideo = false
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self, self.$videoReady)
    }

    class Coordinator: NSObject, YTPlayerViewDelegate {
        var player: YoutubePlayerView
        @Binding var videoReady: Bool

        init(_ youtubePlayerView: YoutubePlayerView, _ videoReady: Binding<Bool>){
            self.player = youtubePlayerView
            self._videoReady = videoReady
        }

        func playerViewDidBecomeReady(_ playerView: YTPlayerView) {
            self.videoReady = true
        }
    }
}
