//
//  RadioPlayer.swift
//  Radio8
//  Created by brfsu on 24.04.2024.
//
import MediaPlayer
import AVKit
import AVFoundation
import SwiftUI

class RadioPlayer: ObservableObject {
    static let instance = RadioPlayer()
    var player = AVPlayer()
    
    private init() {
        setupRemoteCommandCenter()
        configureAudioSession()
    }
    
    @Published var isPlaying = false
    @Published var efir: EfirM? = nil
    private var artwork: MPMediaItemArtwork? = nil
    
    func initPlayer(url: String) {
        guard let url = URL(string: url) else { return }
        let playerItem = AVPlayerItem(url: url)
        player = AVPlayer(playerItem: playerItem)
    }

    func play(_ efir: EfirM) {
        self.efir = efir
        player.volume = 1
        player.play()
        isPlaying = true
        updateNowPlayingInfo()
        loadArtwork()
    }
    
    func stop() {
        isPlaying = false
        player.pause()
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nil
    }
    
    private func configureAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [])
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Ошибка настройки аудио-сессии: \(error.localizedDescription)")
        }
    }
    
    private func setupRemoteCommandCenter() {
        let commandCenter = MPRemoteCommandCenter.shared()
        
        commandCenter.playCommand.addTarget { [unowned self] _ in
            if !self.isPlaying, let currentEfir = self.efir {
                self.play(currentEfir)
                return .success
            }
            return .commandFailed
        }
        
        commandCenter.pauseCommand.addTarget { [unowned self] _ in
            if self.isPlaying {
                self.stop()
                return .success
            }
            return .commandFailed
        }
        
        commandCenter.togglePlayPauseCommand.addTarget { [unowned self] _ in
            if self.isPlaying {
                self.stop()
            } else if let currentEfir = self.efir {
                self.play(currentEfir)
            }
            return .success
        }
    }
    
    private func updateNowPlayingInfo() {
        var nowPlayingInfo = [String: Any]()
        
        if let efir = efir {
            nowPlayingInfo[MPMediaItemPropertyTitle] = efir.name
            nowPlayingInfo[MPMediaItemPropertyArtist] = "Radio8"
            
            if let artwork = artwork {
                nowPlayingInfo[MPMediaItemPropertyArtwork] = artwork
            }
        }
        
        nowPlayingInfo[MPNowPlayingInfoPropertyIsLiveStream] = true
        nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = isPlaying ? 1.0 : 0.0
        
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
    }
    
    private func loadArtwork() {
        guard let imageUrl = efir?.imageUrl else { return }
        
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: imageUrl),
               let image = UIImage(data: data) {
                
                let artwork = MPMediaItemArtwork(boundsSize: image.size) { _ in image }
                
                DispatchQueue.main.async {
                    self.artwork = artwork
                    self.updateNowPlayingInfo()
                }
            }
        }
    }
}
