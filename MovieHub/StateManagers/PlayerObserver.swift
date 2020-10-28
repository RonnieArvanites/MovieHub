//
//  PlayerObserver.swift
//  MovieHub
//
//  Created by Ronnie Arvanites on 10/25/20.
//

import Foundation
import AVKit
import Combine

// Used to observe the status of the video player
class PlayerObserver {
    
    @Published var currentStatus: AVPlayer.TimeControlStatus?
    private var itemObservation: AnyCancellable?
    
    init(player: AVPlayer) {
        itemObservation = player.publisher(for: \.timeControlStatus).sink { newStatus in
            self.currentStatus = newStatus
        }
        
    }
}
