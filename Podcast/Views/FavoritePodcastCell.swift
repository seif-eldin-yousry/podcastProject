//
//  FavoritePodcastCell.swift
//  Podcast
//
//  Created by Seif Yousry on 11/24/19.
//  Copyright © 2019 Seif Yousry. All rights reserved.
//

import UIKit

class FavoritePodcastCell: UICollectionViewCell {
    
    var podcast: Podcast! {
        didSet {
            nameLabel.text = podcast.trackName
            artistNameLabel.text = podcast.artistName
            
            let url = URL(string: podcast.artworkUrl600 ?? "")
            imageView.sd_setImage(with: url)
        }
    }
    
    let imageView = UIImageView(image: UIImage(named: "appicon"))
    let artistNameLabel = UILabel()
    let nameLabel = UILabel()
//    let artistNameLabel = UILabel()
    
    fileprivate func stylizeUI() {
        //        nameLabel.text =
        nameLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
//                artistNameLabel.text = "jjj"
        artistNameLabel.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        artistNameLabel.textColor = .red
    }
    
    fileprivate func setupViews() {
        imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor).isActive = true
        
        let stackView = UIStackView(arrangedSubviews: [imageView, nameLabel, artistNameLabel])
        stackView.axis = .vertical
        //enables auto layout
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)
        stackView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        stackView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        stylizeUI()
        
        setupViews()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}























