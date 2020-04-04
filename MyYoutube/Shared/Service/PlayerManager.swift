//
//  PlayerManager.swift
//  MyYoutube
//
//  Created by Man Chung Wong on 1/4/2020.
//  Copyright © 2020 Man Chung Wong. All rights reserved.
//

import Foundation
import AVFoundation

class PlayerManager {
    static let shared = PlayerManager()
    
    private var songPlayer: AVAudioPlayer!
    
    private init() {}
    
    var isPlaying: Bool {
        guard let songPlayer = songPlayer else { return false }
        return songPlayer.isPlaying
    }
    
    func playSong(url: URL) throws {
        //            let asset = AVURLAsset(url: url)
        //            let audioDuration = asset.duration
        //            audioLength = CMTimeGetSeconds(audioDuration)

        songPlayer = try AVAudioPlayer(contentsOf: url)
        songPlayer.prepareToPlay()
        songPlayer.numberOfLoops = -1

        let audioSession = AVAudioSession.sharedInstance()
        try audioSession.setCategory(AVAudioSession.Category.playback)
        
        songPlayer.play()
    }
    
    func toggleplaySong() {
        guard let songPlayer = songPlayer else { return }
        
        if songPlayer.isPlaying {
            songPlayer.pause()
        } else {
            songPlayer.play()
        }
    }
    
    func closeSong() {
        songPlayer = nil
    }
}
