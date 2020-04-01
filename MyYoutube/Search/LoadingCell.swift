//
//  LoadingCell.swift
//  MyYoutube
//
//  Created by Man Chung Wong on 27/1/2020.
//  Copyright © 2020 Man Chung Wong. All rights reserved.
//

import UIKit

class LoadingCell: UITableViewCell {
    
    let spinner: UIActivityIndicatorView = {
        var view = UIActivityIndicatorView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        addSubview(spinner)
        spinner.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        spinner.widthAnchor.constraint(equalToConstant: 44).isActive = true
        spinner.heightAnchor.constraint(equalToConstant: 44).isActive = true
    }
}
