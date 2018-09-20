//
//  UICreator.swift
//  Circle
//
//  Created by Kerby Jean on 7/3/18.
//  Copyright © 2018 Kerby Jean. All rights reserved.
//

import UIKit
import LTMorphingLabel


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
        label.layer.masksToBounds = true 
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
        imageView.backgroundColor = UIColor(white: 0.8, alpha: 1.0)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(imageView)
        return imageView
    }
    
    
    func textField(_ placeholder: String?, _ keyboardType: UIKeyboardType, _ contentView: UIView) -> UITextField {
        let field = UITextField()
        field.textColor = .darkText
        field.translatesAutoresizingMaskIntoConstraints = false 
        field.keyboardType = keyboardType
        field.cornerRadius = 5
        field.placeholder = placeholder
        contentView.addSubview(field)
        return field 
    }
    
    func textView (_ contentView: UIView) -> UITextView {
        let field = UITextView()
        contentView.addSubview(field)
        return field
    }
    
    func badge( _ contentView: UIView) -> UIView {
        
        let view = UIView()
        view.frame = CGRect(x: contentView.bounds.width - 30 , y: 20, width: 8, height: 8)
        view.cornerRadius = view.frame.width / 2 
        view.backgroundColor = .sparenColor
        contentView.addSubview(view)
        return view
    }
}

