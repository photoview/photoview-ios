//
//  ProtectedMediaView.swift
//  Photoview
//
//  Created by Viktor Strate Kløvedal on 04/02/2022.
//

import SwiftUI
import AVFoundation
import AVKit

struct ProtectedVideoView: View {
    let url: String?
    
    var videoAsset: AVURLAsset? {
        guard let url = self.url else { return nil }
        
        let headers: [String: String] = [
            "Cookie": Network.shared.authTokenCookieValue()
        ]
        
        return AVURLAsset(url: Network.shared.fullUrl(url), options: ["AVURLAssetHTTPHeaderFieldsKey": headers])
    }
    
    var body: some View {
        let player: AVPlayer?
        if let videoAsset = videoAsset {
            player = AVPlayer(playerItem: AVPlayerItem(asset: videoAsset))
        } else {
            player = nil
        }
        
        return VideoPlayer(player: player)
    }
}
