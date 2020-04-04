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
import RealmSwift

class DetailViewController: UIViewController {
    
    let realm = try! Realm()
    
    var item: YoutubeItem!
//    var songPlayer = AVAudioPlayer()
    var isSongReady = false {
        didSet {
            if isSongReady {
                prepareSongAndSession()
                self.downloadStatusLabel.text = "Downloaded"
                playButton.isEnabled = true
                
            }
        }
    }
    
    var thumbnailUrlString: String {
        return item.thumbnail
    }
    
    var titleString: String {
        return item.title
    }
    
    var localUrl: URL?
    
    @IBOutlet weak var playButton: UIButton!
    
    @IBOutlet weak var downloadStatusLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    
    func prepareSongAndSession() {
        localUrl = DownloadManager.shared.getSaveFileUrl(fileName: item.id)
    }
    
    @IBAction func playClicked(_ sender: Any) {
        if !isSongReady { return }
        guard let url = localUrl else { return }
        do {
            try PlayerManager.shared.playSong(url: url)
            
            MiniPlayerView.shared.show(thumbnailUrlString: thumbnailUrlString, title: titleString)
            
        } catch {
            print("error ", error)
        }
    }
    
    @IBAction func pauseClicked(_ sender: Any) {
        PlayerManager.shared.toggleplaySong()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.playButton.isEnabled = false
        imageView.sd_setImage(with: URL(string: item.thumbnail)!, completed: nil)
//        self.view.backgroundColor = UIColor.yellow
        titleLabel.text = item.title
        titleLabel.numberOfLines = 0
        descLabel.text = item.videoDescription
        descLabel.numberOfLines = 0
        print(item.id)
        // TODO: change to check db
        if DownloadManager.shared.checkVideoExist(videoId: item.id) {
            self.isSongReady = true
        } else {
            self.downloadStatusLabel.text = "Start Downloading..."
            DownloadManager.shared.startDownload(videoId: item.id, completed: { [weak self] (errorMsg, filePath) in
                DispatchQueue.main.async {
                    guard let self = self else { return }
                    if let errorMsg = errorMsg {
                        self.downloadStatusLabel.text = "ERROR: " + errorMsg
                        return
                    }
                    
                    try! self.realm.write {
                        self.item.filePathString = filePath ?? ""
                        self.realm.add(self.item)
                    }
                    
                    self.isSongReady = true
                }
            })
        }
    }

    
}
