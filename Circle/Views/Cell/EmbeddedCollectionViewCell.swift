//
//  EmbeddedCollectionViewCell.swift
//  Circle
//
//  Created by Kerby Jean on 11/26/17.
//  Copyright © 2017 Kerby Jean. All rights reserved.
//


import UIKit
import IGListKit

final class EmbeddedCollectionViewCell: UITableViewCell {

    
    lazy var collectionView: UICollectionView = {
        let layout = CircleLayout()
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.allowsMultipleSelection = true
        view.backgroundColor = .clear
        view.isPagingEnabled = true
        view.showsVerticalScrollIndicator = true
        self.contentView.addSubview(view)
        return view
    }()
    
    var user = [User]()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        
        let cellClass: AnyClass
        cellClass = PendingInviteCell.self
        
        collectionView.register(cellClass, forCellWithReuseIdentifier: "PendingInviteCell")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = contentView.frame
    }
}

