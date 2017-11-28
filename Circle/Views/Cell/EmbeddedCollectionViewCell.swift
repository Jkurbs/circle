//
//  EmbeddedCollectionViewCell.swift
//  Circle
//
//  Created by Kerby Jean on 11/26/17.
//  Copyright © 2017 Kerby Jean. All rights reserved.
//


import UIKit

final class EmbeddedCollectionViewCell: UICollectionViewCell {
    
    lazy var collectionView: UICollectionView = {
        let layout = CircleLayout()
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.backgroundColor = .clear
        view.isPagingEnabled = true
        view.showsHorizontalScrollIndicator = false
        view.alwaysBounceVertical = false
        view.alwaysBounceHorizontal = true
        self.contentView.addSubview(view)
        return view
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = contentView.frame
    }
}

