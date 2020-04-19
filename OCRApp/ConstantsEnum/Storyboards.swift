//
//  Storyboards.swift
//  LaundryApp
//


import Foundation
import UIKit

public enum Storyboards : String {
    
    // As enum is extends from String then its case name is also its value
    case main = "Main"
    case walkthrough = "Walkthrough"
    case registeration = "Registeration"
    case home = "Home"
    case services = "Services"
    case orders = "Orders"
    
}

public enum Navigations {
     static var mainNavigation:UINavigationController? = nil
}

