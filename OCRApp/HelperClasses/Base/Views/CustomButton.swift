//
//  CustomButton.swift
//  LaundryApp
//


import UIKit

class CustomButton: UIButton {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.isExclusiveTouch = true
        self.titleEdgeInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: DesignUtility.getValueFromRatio(7), right: 0.0)
        
        self.titleLabel?.font = UIFont.init(name: "Lato-Bold", size: DesignUtility.getFontSize(fSize: 14))
       // self.titleLabel?.font = UIFont.systemFont(ofSize: DesignUtility.getFontSize(fSize: 18))
    }

}
