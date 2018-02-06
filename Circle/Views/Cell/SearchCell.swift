//
//  SearchCell.swift
//  Circle
//
//  Created by Kerby Jean on 1/13/18.
//  Copyright © 2018 Kerby Jean. All rights reserved.
//


import UIKit

final class SearchCell: UICollectionViewCell {
    
    lazy var searchBar: UISearchBar = {
        let view = UISearchBar()
        self.contentView.addSubview(view)
        return view
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        searchBar.frame = contentView.bounds
    }
    
}
