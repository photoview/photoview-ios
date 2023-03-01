//
//  FullscreenAVPlayerView.swift
//  Photoview
//
//  Created by Dhrumil Shah on 3/1/23.
//

import SwiftUI
import PDFKit
import AVFoundation
import AVKit

struct FullscreenAVPlayerView: UIViewControllerRepresentable {
    typealias UIViewControllerType = AVPlayerViewController

    var player: AVPlayer

    func updateUIViewController(_ playerController: AVPlayerViewController, context: Context) {
        playerController.modalPresentationStyle = .overFullScreen
        playerController.player = player
        playerController.player?.play()
        playerController.showsPlaybackControls = true
        playerController.allowsPictureInPicturePlayback = true
        playerController.entersFullScreenWhenPlaybackBegins = true
        if #available(iOS 16, *) {
            playerController.allowsVideoFrameAnalysis = true
        }
        
        // Add swipe down gesture recognizer
        let swipeDown = UISwipeGestureRecognizer(target: context.coordinator, action: #selector(context.coordinator.handleSwipeGesture))
        swipeDown.direction = .down
        playerController.view.addGestureRecognizer(swipeDown)
        
        
        // Set audio session category to playback
        // Allows for audio even on silent mode
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback)
        } catch {
            print("Failed to set audio session category: \(error)")
        }
        
        playerController.viewWillLayoutSubviews()
    }

    func makeUIViewController(context: Context) -> AVPlayerViewController {
        let playerController = AVPlayerViewController()
        
        // Set the coordinator as the gesture recognizer's target
        playerController.view.isUserInteractionEnabled = true
        playerController.view.addGestureRecognizer(UITapGestureRecognizer(target: context.coordinator, action: nil))
        
        // Initialize the coordinator
        context.coordinator.playerController = playerController
        
        return playerController
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject {
        var parent: FullscreenAVPlayerView
        var playerController: AVPlayerViewController?
        
        init(_ parent: FullscreenAVPlayerView) {
            self.parent = parent
        }
        
        // Handle swipe gesture by dismissing the player controller
        @objc func handleSwipeGesture() {
            playerController?.dismiss(animated: true, completion: nil)
        }
    }
}
