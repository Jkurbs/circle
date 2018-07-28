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
    
    func button(_ title: String?, _ image: UIImage?, _ color: UIColor?, _ backgroundColor: UIColor?, _ contentView: UIView) -> UIButton {
        let button = UIButton()
        button.setTitle(title, for: .normal)
        button.setImage(image, for: .normal)
        button.setTitleColor(color, for: .normal)
        button.backgroundColor = backgroundColor
        button.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(button)
        return button
    }
    
    func label(_ text: String?, _ fontSize: CGFloat?, _ textColor: UIColor?, _ alignment: NSTextAlignment, _ weight: UIFont.Weight, _ contentView: UIView) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = UIFont.systemFont(ofSize: fontSize!, weight: weight)
        label.textColor = textColor
        label.textAlignment = alignment
        label.numberOfLines = 4
        label.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(label)
        return label
    }
    
    func imageView(_ image: UIImage?, _ contentView: UIView) -> UIImageView {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.layer.masksToBounds = true 
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .white
        imageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(imageView)
        return imageView
    }
    
    func sticker(_ imageName: String, _ contentView: UIView) -> UIView {
        let view = UIView()
        view.frame = .zero
        view.borderColor = .white
        let gradientLayer = CAGradientLayer()
        gradientLayer.contents = UIImage(named: imageName)?.cgImage
        gradientLayer.frame = view.bounds
        gradientLayer.cornerRadius = gradientLayer.frame.width/2
        gradientLayer.borderWidth = 1.0
        gradientLayer.borderColor = UIColor.white.cgColor
        gradientLayer.colors = [ UIColor.yellow.cgColor, UIColor(red: 243.0/255.0, green:  156.0/255.0, blue:  18.0/255.0, alpha: 1.0).cgColor, UIColor.orange.cgColor]
        view.layer.addSublayer(gradientLayer)
        contentView.addSubview(view)
        return view
    }
}

