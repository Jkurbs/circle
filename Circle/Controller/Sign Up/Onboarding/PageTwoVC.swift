//
//  PageTwoVC.swift
//  Circle
//
//  Created by Kerby Jean on 1/15/18.
//  Copyright © 2018 Kerby Jean. All rights reserved.
//

import UIKit

class PageTwoVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        
        let width = view.frame.width
        let x = view.center.x
        let label = UILabel(frame: CGRect(x: 0, y: 50, width: width, height: 60))
        label.center.x = x
        label.textAlignment = .center
        label.numberOfLines = 3
        label.font = UIFont.systemFont(ofSize: 20, weight: .light)
        label.text = "Circulate the money, until everyone gets paid"
        label.autoresizingMask = .flexibleTopMargin
        view.addSubview(label)
    }
}
