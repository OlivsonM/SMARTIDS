
//
//  CardsView.swift
//  OCRApp
//

import UIKit
import MessageUI
import FCAlertView
class CardsView: UIView {
    
    var imageView : UIImageView!
    var mailMain : MFMailComposeViewController!
    var pinNote = ""
    override init(frame: CGRect) {
        super.init(frame: frame)
        commomInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        //--ww fatalError("init(coder:) has not been implemented")
        super.init(coder: aDecoder)
        commomInit()
    }

    func setCardData( data: Any? , row : Int?) {
        
        let bundles = Bundle.main.loadNibNamed("CardsView", owner: self, options: nil)
        
        var selectedRow = bundles!.count - 1
        // var selectedRow = 0
        if let selrow = row {
            
            selectedRow = selrow
        }
        
        let currentView = bundles![selectedRow] as! UIView
        print(self.subviews.count)
        for v in self.subviews {
            v.removeFromSuperview()
        }
//        if (self.subviews.count == 0) {
//            addSubview(currentView)
//        }
        addSubview(currentView)
        //self.backgroundColor = UIColor.blue
        imageView = currentView.viewWithTag(CardsUITags.cardImage.rawValue) as! UIImageView
        imageView.image = UIImage(named : "emptycard\(String(selectedRow + 1))-temp")
        
        let lblName = currentView.viewWithTag(CardsUITags.name.rawValue) as! UILabel
        let lblPosition = currentView.viewWithTag(CardsUITags.position.rawValue) as! UILabel
        let lblCompany = currentView.viewWithTag(CardsUITags.company.rawValue) as! UILabel
        let btnPin = currentView.viewWithTag(CardsUITags.notePin.rawValue) as! UIButton
        //setPinConstraint(btn: btnPin)
        self.setNeedsLayout()
        self.layoutSubviews()
        self.setNeedsDisplay()
        print(lblName.frame)
        print(btnPin.frame)
        print("emptycard\(String(selectedRow + 1))-temp")
        if let data1 = data as! Card? {
            
            
            let lblEmail = currentView.viewWithTag(CardsUITags.email.rawValue) as! UILabel
            let lblPhone = currentView.viewWithTag(CardsUITags.phone.rawValue) as! UILabel
            let lblAddress = currentView.viewWithTag(CardsUITags.location.rawValue) as! UILabel
            let lblWebsite = currentView.viewWithTag(CardsUITags.website.rawValue) as! UILabel
            let imgQRCode = currentView.viewWithTag(CardsUITags.QRCodeImage.rawValue) as! UIImageView
            
            imgQRCode.isHidden = true
            imageView.image = UIImage(named : "emptycard\(String(selectedRow + 1))")
            lblName.text = data1.name
            lblPosition.text = data1.poition
            lblCompany.text = data1.company
            lblEmail.text = data1.email
            lblPhone.text = data1.phone
            lblAddress.text = data1.address
            lblWebsite.text = data1.website
            if (data1.website.count <= 0) {
                lblWebsite.text = "N/A"
            }
            
            print(data1.QRImagePath)
            print(Utility.loadImageFromPath(data1.QRImagePath))
            imgQRCode.image = Utility.loadImageFromPath(data1.QRImagePath)
            
            if(data1.cardColor.count > 0) {
                //imageView.backgroundColor = UIColor.init(hexString: data1.cardColor)
                imageView.image = UIImage(named : "")
                imageView.backgroundColor = UIColor.init(hexString: data1.cardColor)
                imageView.layer.cornerRadius = DesignUtility.getValueFromRatio(18)
                imageView.layer.masksToBounds = true
                
            }
            btnPin.isHidden = false
            btnPin.addTarget(self, action: #selector(self.showNote), for: .touchUpInside)
            pinNote = data1.note
            if (data1.note.isEmptyStr()) {
                btnPin.isHidden = true
            }
            
//            implementTabGesture(label: lblName)
//            implementTabGesture(label: lblCompany)
            implementTabGesture(label: lblEmail)
            implementTabGesture(label: lblPhone)
//            implementTabGesture(label: lblAddress)
            implementTabGesture(label: lblWebsite)
            
        }
        else {
            var stackView = currentView.viewWithTag(CardsUITags.mainStack.rawValue)
            stackView?.removeFromSuperview()
            lblName.isHidden = true
            lblPosition.isHidden = true
            lblCompany.isHidden = true
            btnPin.isHidden = true
            stackView = nil
        }
        
    }
    
    func setPinConstraint( btn : UIButton) {
        print(btn.constraints)
//        let filteredConstraints = btn.constraints.filter { $0.identifier == "pintop" }
//        if let yourConstraint = filteredConstraints.first {
//            // DO YOUR LOGIC HERE
//            yourConstraint.constant = 50
//        }
        
    }
    
    @objc func showNote() {
        
            let alert = FCAlertView.init()
            alert.showAlert(inView: self.parentViewController, withTitle: "Note", withSubtitle: pinNote, withCustomImage: #imageLiteral(resourceName: "splashicon2"), withDoneButtonTitle: nil, andButtons: nil)
            // alert.delegate = self
            alert.dismissOnOutsideTouch = true
            alert.colorScheme = UIColor.blue
            alert.hideDoneButton = true
            alert.blurBackground = true
            //        alert.bounceAnimations = true
            alert.animateAlertInFromBottom = true
            alert.animateAlertOutToBottom = true
            alert.avoidCustomImageTint = true
            alert.autoHideSeconds = 5
        
        
        
        
    }
    
    func commomInit(){
        
    }
    
    @IBAction func shareCard(_ sender: UIButton) {
        
        
        
    }
    
    func implementTabGesture(label  : UILabel) {
    
        if let gesArray = label.gestureRecognizers {
            for ges in gesArray {
                label.removeGestureRecognizer(ges)
            }
        }
        

        let tap = UITapGestureRecognizer(target: self, action: #selector(CardsView.tapFunction))
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(tap)
    }
    @objc func tapFunction(sender:UITapGestureRecognizer) {
        print("tap working")
//        print(sender.view?.tag)
        if let label = sender.view as? UILabel {
            if label.tag == CardsUITags.email.rawValue {
                //let email = label.text
                openEmail(label: label)
            }
            else if label.tag == CardsUITags.phone.rawValue {
                makeCall(label: label)
            }
            else if label.tag == CardsUITags.website.rawValue {
                openWebsite(label: label)
            }
        }
    }
    
    
    func openEmail(label : UILabel) {
        
        if MFMailComposeViewController.canSendMail() {
            mailMain = MFMailComposeViewController()
            
            mailMain.mailComposeDelegate = self
            mailMain.setToRecipients([label.text!])
           // mail.setMessageBody("<p>You're so awesome!</p>", isHTML: true)
            let controller = self.parentViewController!
            controller.present(mailMain, animated: true, completion: nil)
//            present(mail, animated: true)
        } else {
            // show failure alert
            Alert.showMsg(msg: "Your device could not send e-mail.  Please check e-mail configuration and try again.")
        }
    }
    
    
    func makeCall(label : UILabel) {

        if let url  = NSURL(string: "TEL://\(label.text!)") {
            
            //            let url1: NSURL = URL(string: "TEL://\(label.text!)")! as NSURL
            UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
            
        }
        
//        let url: NSURL = URL(string: "TEL://\(label.text!)")! as NSURL
//        UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)

        
//        if let url = URL(string: "tel://\(String(describing: label.text))"), UIApplication.shared.canOpenURL(url) {
//            if #available(iOS 10, *) {
//                UIApplication.shared.open(url)
//            } else {
//                UIApplication.shared.openURL(url)
//            }
//        }
        
        
    }
    
    
    func openWebsite(label : UILabel) {
        //https://www.hackingwithswift.com
        if ((label.text?.count)! <= 0 ||
            label.text == "N/A") {
            return
        }
        
        if let urlString = label.text {
            let url: URL?
            if urlString.hasPrefix("http://") {
                url = URL(string: urlString)
            } else {
                url = URL(string: "http://" + urlString)
            }
            if let url = url {
                UIApplication.shared.open(url, options: [:])
            }
        }
        
        
//        if let url = URL(string: "https://\(label.text!)") {
//            UIApplication.shared.open(url, options: [:])
//        }
    }
}

extension CardsView : MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
}

extension UIView {
    var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder!.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
}
