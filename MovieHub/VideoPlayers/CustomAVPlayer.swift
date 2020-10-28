//
//  NewPlayerView.swift
//  MovieHub
//
//  Created by Ronnie Arvanites on 10/10/20.
//

import Foundation
import SwiftUI
import AVKit

struct VideoPlayer: UIViewRepresentable {
    typealias UIViewType = UIView
    
    var player: AVPlayer

    func makeUIView(context: UIViewRepresentableContext<VideoPlayer>) -> UIView {
        let controller = AVPlayerViewController()
//        controller.player = AVPlayer(url: url)
        controller.player = self.player
        //Enables audio
        try! AVAudioSession.sharedInstance().setCategory(.playback)
        context.coordinator.controller = controller
        return controller.view
    }

    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<VideoPlayer>) {
    }

    func makeCoordinator() -> VideoPlayer.Coordinator {
        Coordinator()
    }

    class Coordinator: NSObject {
        var controller: AVPlayerViewController?

        deinit {
            print("deinit coordinator")
        }
        
        
    }
}
