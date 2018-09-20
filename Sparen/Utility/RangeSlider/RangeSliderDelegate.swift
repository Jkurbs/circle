//
//  RangeSliderDelegate.swift
//  Sparen
//
//  Created by Kerby Jean on 9/2/18.
//  Copyright © 2018 Kerby Jean. All rights reserved.
//

import CoreGraphics

public protocol RangeSliderDelegate: class {
    
    /// Called when the RangeSeekSlider values are changed
    ///
    /// - Parameters:
    ///   - slider: RangeSeekSlider
    ///   - minValue: minimum value
    ///   - maxValue: maximum value
    func rangeSeekSlider(_ slider: RangeSlider, didChange minValue: CGFloat, maxValue: CGFloat)
    
    /// Called when the user has started interacting with the RangeSeekSlider
    ///
    /// - Parameter slider: RangeSeekSlider
    func didStartTouches(in slider: RangeSlider)
    
    /// Called when the user has finished interacting with the RangeSeekSlider
    ///
    /// - Parameter slider: RangeSeekSlider
    func didEndTouches(in slider: RangeSlider)
    
    /// Called when the RangeSeekSlider values are changed. A return `String?` Value is displayed on the `minLabel`.
    ///
    /// - Parameters:
    ///   - slider: RangeSeekSlider
    ///   - minValue: minimum value
    /// - Returns: String to be replaced
    func rangeSeekSlider(_ slider: RangeSlider, stringForMinValue minValue: CGFloat) -> String?
    
    /// Called when the RangeSeekSlider values are changed. A return `String?` Value is displayed on the `maxLabel`.
    ///
    /// - Parameters:
    ///   - slider: RangeSeekSlider
    ///   - maxValue: maximum value
    /// - Returns: String to be replaced
    func rangeSeekSlider(_ slider: RangeSlider, stringForMaxValue: CGFloat) -> String?
}


// MARK: - Default implementation
public extension RangeSliderDelegate {
    
    func rangeSeekSlider(_ slider: RangeSlider, didChange minValue: CGFloat, maxValue: CGFloat) {}
    func didStartTouches(in slider: RangeSlider) {}
    func didEndTouches(in slider: RangeSlider) {}
    func rangeSeekSlider(_ slider: RangeSlider, stringForMinValue minValue: CGFloat) -> String? { return nil }
    func rangeSeekSlider(_ slider: RangeSlider, stringForMaxValue maxValue: CGFloat) -> String? { return nil }
}
