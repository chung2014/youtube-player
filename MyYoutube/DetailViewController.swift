//
//  DetailViewController.swift
//  MyYoutube
//
//  Created by Man Chung Wong on 19/1/2020.
//  Copyright © 2020 Man Chung Wong. All rights reserved.
//

import UIKit
import AVFoundation
import SDWebImage

class DetailViewController: UIViewController {
    var item: YoutubeItem!
    var songPlayer = AVAudioPlayer()
    var isSongReady = false {
        didSet {
            if isSongReady {
                prepareSongAndSession()
                self.downloadStatusLabel.text = "Downloaded"
            }
        }
    }
    
    @IBOutlet weak var downloadStatusLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    func prepareSongAndSession() {
        do {
            let url = DownloadUtils.shared.getSaveFileUrl(fileName: item.id)
            
//            let asset = AVURLAsset(url: url)
//            let audioDuration = asset.duration
//            audioLength = CMTimeGetSeconds(audioDuration)
            
            songPlayer = try AVAudioPlayer(contentsOf: url)
            songPlayer.prepareToPlay()
            songPlayer.numberOfLoops = -1
            
            let audioSession = AVAudioSession.sharedInstance()
            do {
                try audioSession.setCategory(AVAudioSession.Category.playback)
                
            } catch {
                print("setCategory error")
                print(error)
            }
        } catch {
            print("create AVAudioPlayer error")
            print(error)
        }
    }
    
    @IBAction func playClicked(_ sender: Any) {
        if !isSongReady { return }
        songPlayer.play()
    }
    
    @IBAction func pauseClicked(_ sender: Any) {
        if songPlayer.isPlaying {
            songPlayer.pause()
        } else {
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        imageView.sd_setImage(with: URL(string: item.thumbnail)!, completed: nil)
//        self.view.backgroundColor = UIColor.yellow
        print(item.id)
        if DownloadUtils.shared.checkVideoExist(videoId: item.id) {
            self.isSongReady = true
        } else {
            self.downloadStatusLabel.text = "Start Downloading..."
            DownloadUtils.shared.startDownload(videoId: item.id, completed: { errorMsg in
                DispatchQueue.main.async {
                    if let errorMsg = errorMsg {
                        self.downloadStatusLabel.text = "ERROR: " + errorMsg
                        return
                    }
                    self.isSongReady = true
                }
            })
        }
    }

    
}
