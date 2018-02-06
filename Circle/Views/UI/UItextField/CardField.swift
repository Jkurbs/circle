//
//  CardField.swift
//  Circle
//
//  Created by Kerby Jean on 1/17/18.
//  Copyright © 2018 Kerby Jean. All rights reserved.
//

import Foundation
import Stripe

class CardField: STPPaymentCardTextField {
    
    var theme = STPTheme.default()
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        setup()
    }
    
    required override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    
    func setup() {
        self.backgroundColor = textFieldBackgroundColor
        self.textColor = theme.primaryForegroundColor
        self.placeholderColor = theme.secondaryForegroundColor
        self.borderColor = .lightGray
        self.borderWidth = 0.5
        self.textErrorColor = theme.errorColor
        self.postalCodeEntryEnabled = true
    }
}
