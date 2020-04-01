//
//  MiniPlayerView.swift
//  MyYoutube
//
//  Created by Man Chung Wong on 1/4/2020.
//  Copyright © 2020 Man Chung Wong. All rights reserved.
//

import Foundation
import UIKit
import SDWebImage

class MiniPlayerView {
    static let shared = MiniPlayerView()
    
    private var containerView: UIView!
    private var imageView: UIImageView!
    private var titleLabel: UILabel!
    private var playButton: UIButton!
    private var closeButton: UIButton!
    
    private init () {}
    
    private func createContainerView() {
        guard let window = UIApplication.shared.windows.last else { return }

        let ypos = UIScreen.main.bounds.size.height - (UIApplication.shared.windows[1].rootViewController! as! UITabBarController).tabBar.frame.size.height - 50
        containerView = UIView.init(frame: CGRect(x: 0, y: ypos, width: UIScreen.main.bounds.width, height: 50))
        containerView.backgroundColor = UIColor.white
        
        imageView = UIImageView.init(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        containerView.addSubview(imageView)
        imageView.backgroundColor = UIColor.green
        
        let remainingWidth: CGFloat = UIScreen.main.bounds.size.width - 50 * 3
        titleLabel = UILabel.init(frame: CGRect(x: 50, y: 0, width: remainingWidth, height: 50))
        containerView.addSubview(titleLabel)
        titleLabel.textColor = UIColor.black
//        titleLabel.backgroundColor = UIColor.blue
        titleLabel.numberOfLines = 0
        
        playButton = UIButton.init(frame: CGRect(x: 50 + remainingWidth, y: 0, width: 50, height: 50))
        containerView.addSubview(playButton)
//        playButton.backgroundColor = UIColor.green
        playButton.setImage(UIImage.init(named: "pause"), for: .normal)
        playButton.addTarget(self, action: #selector(playClicked), for: .touchUpInside)
        
        closeButton = UIButton.init(frame: CGRect(x: 50 + remainingWidth + 50, y: 0, width: 50, height: 50))
        containerView.addSubview(closeButton)
//        closeButton.backgroundColor = UIColor.blue
        closeButton.setImage(UIImage.init(named: "close"), for: .normal)
        
        closeButton.addTarget(self, action: #selector(closeClicked), for: .touchUpInside)
        
        window.addSubview(containerView)
        window.bringSubviewToFront(containerView)
    }
    
    func show(thumbnailUrlString: String, title: String) {
        if (containerView == nil) {
            createContainerView()
        }
        
        imageView.sd_setImage(with: URL(string: thumbnailUrlString)!, completed: nil)
        titleLabel.text = title
        containerView.isHidden = false
    }
    
    @objc private func playClicked() {
        PlayerManager.shared.toggleplaySong()
        playButton.setImage(UIImage.init(named: "\(PlayerManager.shared.isPlaying ? "pause" : "play")"), for: .normal)
    }
    
    @objc private func closeClicked() {
        containerView.isHidden = true
        PlayerManager.shared.closeSong()
    }
}
