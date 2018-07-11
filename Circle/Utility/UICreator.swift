//
//  UICreator.swift
//  Circle
//
//  Created by Kerby Jean on 7/3/18.
//  Copyright © 2018 Kerby Jean. All rights reserved.
//

import UIKit


class UICreator {
    
    private static let _create = UICreator()
    
    static var create: UICreator {
        return _create
    }
    
    func button(_ title: String?, _ image: UIImage?, _ color: UIColor?, _ backgroundColor: UIColor?, _ view: UIView) -> UIButton {
        let button = UIButton()
        button.setTitle(title, for: .normal)
        button.setImage(image, for: .normal)
        button.setTitleColor(color, for: .normal)
        button.backgroundColor = backgroundColor
        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)
        return button
    }
    
    func label(_ text: String?, _ fontSize: CGFloat?, _ textColor: UIColor?, _ alignment: NSTextAlignment, _ weight: UIFont.Weight, _ view: UIView) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = UIFont.systemFont(ofSize: fontSize!, weight: weight)
        label.textColor = textColor
        label.textAlignment = alignment
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        return label
    }
    
    func imageView(_ image: UIImage?, _ view: UIView) -> UIImageView {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.layer.masksToBounds = true 
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = UIColor(white: 0.8, alpha: 1.0)
        view.addSubview(imageView)
        return imageView
    }
}

