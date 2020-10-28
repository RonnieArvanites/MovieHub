//
//  CustomVideoPlayer.swift
//  MovieHub
//
//  Created by Ronnie Arvanites on 10/10/20.
//

import Foundation
import SwiftUI
import AVKit

// SwiftUI Custom AVPlayer
struct CustomVideoPlayer: UIViewRepresentable {
    typealias UIViewType = UIView
    
    var player: AVPlayer    

    func makeUIView(context: UIViewRepresentableContext<CustomVideoPlayer>) -> UIView {
        let controller = AVPlayerViewController()
        controller.player = self.player
        // Enables audio
        try! AVAudioSession.sharedInstance().setCategory(.playback)
        
        context.coordinator.controller = controller
        return controller.view
    }

    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<CustomVideoPlayer>) {
    }

    func makeCoordinator() -> CustomVideoPlayer.Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, AVPlayerViewControllerDelegate {
        var playerView: CustomVideoPlayer
        var controller: AVPlayerViewController?
        
        init(_ customVideoPlayerView: CustomVideoPlayer){
            self.playerView = customVideoPlayerView
        }

        deinit {
            print("deinit coordinator")
        }
    }
}
