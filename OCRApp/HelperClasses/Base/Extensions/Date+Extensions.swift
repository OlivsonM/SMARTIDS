//
//  Date+Extensions.swift
//  LaundryApp
//


import UIKit
extension Date {
    
    func toString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: self)
    }
    
    func toString(withCustomeFormat : String? = "yyyy-MM-dd") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = withCustomeFormat
        return dateFormatter.string(from: self)
    }
}
