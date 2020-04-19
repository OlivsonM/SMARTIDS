//
//  PopUpView.swift
//  OCRApp
//


import UIKit

class PopUpView: UIView {

    @IBOutlet weak var txtView: UITextView!
    @IBOutlet var contentView: UIView!
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    override init(frame: CGRect) {
        super.init(frame: frame)
        commomInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        commomInit()
    }
    func commomInit(){
        Bundle.main.loadNibNamed("PopUpView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth , .flexibleHeight]
//        txtView.textContainerInset = UIEdgeInsetsMake(-7.0,0.0,0,0.0);
//        self.txtView.contentInset = UIEdgeInsets(top: 10.0, left: 0, bottom: 20.0, right: 0)
//        self.txtView.contentOffset = CGPoint(x: 0, y: 0)
        
        
        let strAttrText = txtView.attributedText
        txtView.attributedText = NSAttributedString.init(string: "")
        
        let lineBreak = NSAttributedString.init(string: "\n")
        
        
        let textMutableAttributedString = NSMutableAttributedString.init()
        
        textMutableAttributedString.append(lineBreak)
        textMutableAttributedString.append(lineBreak)
        textMutableAttributedString.append(lineBreak)
        
        textMutableAttributedString.append(lineBreak)
        let imageAttachment = NSTextAttachment.init()
        
        let image = #imageLiteral(resourceName: "splashicon2")
        imageAttachment.image = image
        
        let imageAttributedString = NSAttributedString.init(attachment: imageAttachment)
        let imageMutableAttributedString = NSMutableAttributedString.init(attributedString: imageAttributedString)
        let imageParagraphStyle = NSMutableParagraphStyle.init()
        imageParagraphStyle.alignment = .center
        
       imageMutableAttributedString.addAttribute(NSAttributedStringKey.paragraphStyle, value: imageParagraphStyle, range: NSRange.init(location: 0, length: imageAttributedString.length))
        textMutableAttributedString.append(imageMutableAttributedString)
        textMutableAttributedString.append(lineBreak)
        textMutableAttributedString.append(strAttrText!)
        txtView.attributedText = textMutableAttributedString
        //imageMutableAttributedString.addAttributes([NSParagraphStyleAttributeName : imageParagraphStyle], range: NSRange.init(location: 0, length: imageAttributedString.length))
//        textMutableAttributedString.append(imageMutableAttributedString)
//
//
//        //create and NSTextAttachment and add your image to it.
//        let attachment = NSTextAttachment()
////        attachment.image = UIImage(cgImage: (attachment.image?.cgImage)!, scale: 20, orientation: UIImageOrientation.left)
//        attachment.image = image
//        attachment.bounds = CGRect.init(x: 0, y: -8, width: (attachment.image?.size.width)!, height: (attachment.image?.size.height)!)
//
//       // attachment.image = image
//        //put your NSTextAttachment into and attributedString
//        let attString = NSAttributedString(attachment: attachment)
//        //add this attributed string to the current position.
//        let strAttrText = txtView.attributedText
//
//        txtView.textStorage.insert(attString, at: 0)
    }
    
    @IBAction func agreeClicked(_ sender: UIButton) {
        
        UserDefaults.standard.set(true, forKey: "isAgreeTerms")
        
        self.removeFromSuperview()
        
    }
    
}
