//
//  TextFieldRect.swift
//  Circle
//
//  Created by Kerby Jean on 1/15/18.
//  Copyright © 2018 Kerby Jean. All rights reserved.
//

import UIKit

class TextFieldRect: UITextField {
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 10, dy: 0)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 10, dy: 0)
    }
}
