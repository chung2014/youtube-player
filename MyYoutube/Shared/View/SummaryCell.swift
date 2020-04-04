//
//  SummaryCell.swift
//  MyYoutube
//
//  Created by Man Chung Wong on 19/1/2020.
//  Copyright © 2020 Man Chung Wong. All rights reserved.
//

import UIKit
import SDWebImage

class SummaryCell: UITableViewCell {
    
    var imageViewContainer: UIView = {
        var view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
//        view.backgroundColor = UIColor.blue
        return view
    }()
    
    var thumbnailImageView: UIImageView = {
        var imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        return imageView
    }()
    
    var titleLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
//        label.backgroundColor = UIColor.green
        return label
    }()
    
    var descLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
//        label.backgroundColor = UIColor.blue
        label.numberOfLines = 0
        return label
    }()
    
    let SPACE_CONSTANT: CGFloat = 10
    
    func setThumbnail(string: String) {
        thumbnailImageView.sd_setImage(with: URL(string: string)!, completed: nil)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        imageViewContainer.addSubview(thumbnailImageView)
        
        self.addSubview(imageViewContainer)
        self.addSubview(titleLabel)
        self.addSubview(descLabel)
        
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    override func layoutSubviews() {
    func setupViews() {
        
//        backgroundColor = UIColor.yellow
        
        thumbnailImageView.topAnchor.constraint(equalTo: imageViewContainer.topAnchor).isActive = true
        thumbnailImageView.bottomAnchor.constraint(equalTo: imageViewContainer.bottomAnchor).isActive = true
        thumbnailImageView.leadingAnchor.constraint(equalTo: imageViewContainer.leadingAnchor).isActive = true
        thumbnailImageView.trailingAnchor.constraint(equalTo: imageViewContainer.trailingAnchor).isActive = true
        
        imageViewContainer.layer.cornerRadius = 5
        
        imageViewContainer.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: SPACE_CONSTANT).isActive = true
        imageViewContainer.widthAnchor.constraint(equalTo: imageViewContainer.heightAnchor).isActive = true
        imageViewContainer.topAnchor.constraint(equalTo: self.topAnchor, constant: SPACE_CONSTANT).isActive = true
        imageViewContainer.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        titleLabel.leadingAnchor.constraint(equalTo: imageViewContainer.trailingAnchor, constant: SPACE_CONSTANT).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -SPACE_CONSTANT).isActive = true
        titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: SPACE_CONSTANT).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 21).isActive = true
        
        descLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor).isActive = true
        descLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -SPACE_CONSTANT).isActive = true
        descLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: SPACE_CONSTANT).isActive = true
        descLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
    }
    
}
