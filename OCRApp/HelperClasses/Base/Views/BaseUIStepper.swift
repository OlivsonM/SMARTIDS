//
//  BaseUIStepper.swift
//  TrafficFramework
//


import UIKit

open class BaseUIStepper: UIStepper, TintDesignable {

    // MARK: - TintDesignable
    @IBInspectable open var tintThemeColor: String? {
        didSet {
            configureTintColor();
        }
    }

}
