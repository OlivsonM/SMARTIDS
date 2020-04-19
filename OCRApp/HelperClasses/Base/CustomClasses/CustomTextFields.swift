//
//  CustomTextFields.swift
//  LaundryApp
//


import UIKit

class NameTextField: BaseUITextField {
    
    override func txtEditing(_ txt: UITextField) {
        
        if let typedText = self.text {
            if typedText.count > Constants.maximumLengthName{
                txt.deleteBackward()
            }
        }
    }
}


class NumberTextField: BaseUITextField {
    
    override func txtEditing(_ txt: UITextField) {
        
        if let typedText = self.text {
            if typedText.count > Constants.maximumLengthNumber{
                txt.deleteBackward()
            }
        }
    }
}

class LinkedInTextField: BaseUITextField {
    
    override func txtEditing(_ txt: UITextField) {
        
        if let typedText = self.text {
            if typedText.count > Constants.maximumLengthLinkedIn{
                txt.deleteBackward()
            }
        }
    }
}
