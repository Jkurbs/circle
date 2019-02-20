//
//  SearchBar.swift
//  Sparen
//
//  Created by Kerby Jean on 1/25/19.
//  Copyright © 2019 Kerby Jean. All rights reserved.
//

import UIKit 

class CustomSearchBar: UISearchBar {
    
    override func setShowsCancelButton(_ showsCancelButton: Bool, animated: Bool) {
//        super.setShowsCancelButton(false, animated: false)
    }}

class CustomSearchController: UISearchController {
    lazy var _searchBar: CustomSearchBar = {
        [unowned self] in
        let customSearchBar = CustomSearchBar(frame: CGRect.zero)
        return customSearchBar
        }()
    
    override var searchBar: UISearchBar {
        get {
            return _searchBar
        }
    }}
