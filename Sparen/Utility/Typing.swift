//
//  Typing.swift
//  Sparen
//
//  Created by Kerby Jean on 8/29/18.
//  Copyright © 2018 Kerby Jean. All rights reserved.
//

import UIKit

/*
 Set text at runtime to trigger type animation;
 
 Set charInterval property for interval time between each character, default is 0.1;
 
 Call pauseTyping() to pause animation;
 
 Call conitinueTyping() to continue paused animation;
 */


@IBDesignable open class CLTypingLabel: UILabel {
    /*
     Set interval time between each characters
     */
    @IBInspectable open var charInterval: Double = 0.1
    
    /*
     Optional handler which fires when typing animation is finished
     */
    open var onTypingAnimationFinished: (() -> Void)?
    
    /*
     If text is always centered during typing
     */
    @IBInspectable open var centerText: Bool = true
    
    private var typingStopped: Bool = false
    private var typingOver: Bool = true
    private var stoppedSubstring: String?
    private var attributes: [NSAttributedStringKey: Any]?
    private var currentDispatchID: Int = 320
    private let dispatchSerialQ = DispatchQueue(label: "CLTypingLableQueue")
    /*
     Setting the text will trigger animation automatically
     */
    override open var text: String! {
        get {
            return super.text
        }
        
        set {
            if charInterval < 0 {
                charInterval = -charInterval
            }
            
            currentDispatchID += 1
            typingStopped = false
            typingOver = false
            stoppedSubstring = nil
            
            attributes = nil
            setTextWithTypingAnimation(newValue, attributes,charInterval, true, currentDispatchID)
        }
    }
    
    /*
     Setting attributed text will trigger animation automatically
     */
    override open var attributedText: NSAttributedString! {
        get {
            return super.attributedText
        }
        
        set {
            if charInterval < 0 {
                charInterval = -charInterval
            }
            
            currentDispatchID += 1
            typingStopped = false
            typingOver = false
            stoppedSubstring = nil
            
            attributes = newValue.attributes(at: 0, effectiveRange: nil)
            setTextWithTypingAnimation(newValue.string, attributes,charInterval, true, currentDispatchID)
        }
    }
    
    // MARK: -
    // MARK: Stop Typing Animation
    
    open func pauseTyping() {
        if typingOver == false {
            typingStopped = true
        }
    }
    
    // MARK: -
    // MARK: Continue Typing Animation
    
    open func continueTyping() {
        
        guard typingOver == false else {
            print("CLTypingLabel: Animation is already over")
            return
        }
        
        guard typingStopped == true else {
            print("CLTypingLabel: Animation is not stopped")
            return
        }
        guard let stoppedSubstring = stoppedSubstring else {
            return
        }
        
        typingStopped = false
        setTextWithTypingAnimation(stoppedSubstring, attributes ,charInterval, false, currentDispatchID)
    }

    
    // MARK: -
    // MARK: Set Text Typing Recursive Loop
    
    private func setTextWithTypingAnimation(_ typedText: String, _ attributes: Dictionary<NSAttributedStringKey, Any>?, _ charInterval: TimeInterval, _ initial: Bool, _ dispatchID: Int) {
        
        guard typedText.count > 0 && currentDispatchID == dispatchID else {
            typingOver = true
            typingStopped = false
            if let nonNilBlock = onTypingAnimationFinished {
                DispatchQueue.main.async(execute: nonNilBlock)
            }
            return
        }
        
        if initial == true {
            super.text = ""
        }
        
        let firstCharIndex = typedText.index(typedText.startIndex, offsetBy: 1)
        
        DispatchQueue.main.async {
            if let attributes = attributes {
                super.attributedText = NSAttributedString(string: super.attributedText!.string +  String(typedText[..<firstCharIndex]),
                                                          attributes: attributes)
            } else {
                super.text = super.text! + String(typedText[..<firstCharIndex])
            }
            
            if self.centerText == true {
                self.sizeToFit()
            }
            self.dispatchSerialQ.asyncAfter(deadline: .now() + charInterval) { [weak self] in
                let nextString = String(typedText[firstCharIndex...])
                self?.setTextWithTypingAnimation(nextString, attributes, charInterval, false, dispatchID)
            }
        }
    }
}
