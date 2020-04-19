//
//  CustomTextFieldView.swift
//  OCRApp
//


import UIKit

class LinkedInTextFieldView: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var textField: LinkedInTextField!
    
    @IBOutlet weak var titleLabel: UILabel!
    override init(frame: CGRect) {
        super.init(frame: frame)
        commomInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        commomInit()
    }
    
    
    
    func commomInit(){
        Bundle.main.loadNibNamed("LinkedInTextFieldView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth , .flexibleHeight]
        
    }

}
