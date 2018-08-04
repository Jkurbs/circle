//
//  PageOneVC.swift
//  Circle
//
//  Created by Kerby Jean on 1/15/18.
//  Copyright © 2018 Kerby Jean. All rights reserved.
//

import UIKit

class PageOneVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white 

        let width = view.frame.width
        let label = UILabel(frame: CGRect(x: 0, y: 50, width: width, height: 30))
        label.center.x = view.center.x
        label.textAlignment = .center
        label.numberOfLines = 3
        label.font = UIFont.systemFont(ofSize: 20, weight: .light)
        label.text = "Set a Circle Goal"
        label.autoresizingMask = [.flexibleTopMargin, .flexibleWidth]

        view.addSubview(label)

    }
}
