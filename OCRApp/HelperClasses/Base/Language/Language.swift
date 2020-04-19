//
//  Language.swift
//  SwiftBaseProject
//

import UIKit

let APPLE_LANGUAGE_KEY = "AppleLanguages"
let userdef = UserDefaults.standard

extension UIApplication {
    class func isRTL() -> Bool{
        let lang = DeviceUtility.getDeviceLanguage()
        var otherLang : String?
        if let someLang = lang.components(separatedBy: "-").first{
            otherLang = someLang
        }
        
       if lang == "ar" || otherLang! == "ar"{
        return true
        }else {
        return false
        }
        
    }
}


class language{
    
    /// get current Apple language
    class func currentAppleLanguage() -> String{
        
        let langArray = userdef.object(forKey: "AppleLanguages") as! NSArray
        let current = langArray.firstObject as! String
        return current
    }
    
    /// set @lang to be the first in Applelanguages list
    class func setAppleLanguageTo(lang: String)
    {
        

        userdef.set([lang,"ar"], forKey: "AppleLanguages")
        UserDefaults.standard.synchronize()

        userdef.synchronize()
        
    }

}

class languageNSObjectClass: NSObject {
    
    class func DoTheSwizzling() {
        
        MethodSwizzleGivenClassName(cls: Bundle.self, originalSelector: #selector(Bundle.localizedString(forKey:value:table:)),overrideSelector: #selector(Bundle.specialLocalizedStringForKey(key:value:table:)))
        
        let currentLanguage = language.currentAppleLanguage()
        
        if currentLanguage == "ar" {
            UIView.appearance().semanticContentAttribute = .forceRightToLeft
        }else
        {
            UIView.appearance().semanticContentAttribute = .forceLeftToRight
        }
    }

    
    
    class func doTHeMagic() {
        
        MethodSwizzleGivenClassName(cls: Bundle.self, originalSelector: #selector(Bundle.localizedString(forKey:value:table:)),overrideSelector: #selector(Bundle.specialLocalizedStringForKey(key:value:table:)))
        
        
        //var transition: UIViewAnimationOptions = .transitionFlipFromLeft
        if language.currentAppleLanguage() == "ar" {
            language.setAppleLanguageTo(lang: "en")
            UIView.appearance().semanticContentAttribute = .forceRightToLeft
        } else {
            language.setAppleLanguageTo(lang: "ar")
            //transition = .transitionFlipFromRight
            UIView.appearance().semanticContentAttribute = .forceLeftToRight
        }
        

    }
    
    func setUpNav() {
        //let appDelegate = UIApplication.shared.delegate as! AppDelegate
       
        //appDelegate.application(UIApplication.shared, didFinishLaunchingWithOptions: nil)

    }
    
    
}

/// Exchange the implementation of two methods for the same Class
func MethodSwizzleGivenClassName(cls: AnyClass, originalSelector: Selector, overrideSelector: Selector)
{
    let origMethod: Method = class_getInstanceMethod(cls, originalSelector)!;
    let overrideMethod: Method = class_getInstanceMethod(cls, overrideSelector)!;
    if (class_addMethod(cls, originalSelector, method_getImplementation(overrideMethod), method_getTypeEncoding(overrideMethod))) {
        class_replaceMethod(cls, overrideSelector, method_getImplementation(origMethod), method_getTypeEncoding(origMethod));
    } else {
        method_exchangeImplementations(origMethod, overrideMethod);
    }
}

extension Bundle {
    

    @objc func specialLocalizedStringForKey(key: String, value: String?, table tableName: String?) -> String {
        /*2*/let currentLanguage = language.currentAppleLanguage()
        var bundle = Bundle();
        /*3*/if let _path = Bundle.main.path(forResource: currentLanguage, ofType: "lproj") {
            bundle = Bundle(path: _path)!
        } else {
            let _path = Bundle.main.path(forResource: "Base", ofType: "lproj")!
            bundle = Bundle(path: _path)!
        }
        /*4*/return (bundle.specialLocalizedStringForKey(key: key, value: value, table: tableName))
    }
    
}

class localoizedFromPlist {
    
    static let sharedInstance = localoizedFromPlist()
    
    lazy var localizableDictionary: NSDictionary = {
        if let path = Bundle.main.path(forResource: "Strings", ofType: "plist") {
            return NSDictionary(contentsOfFile: path)! as NSDictionary
        }
        fatalError("Localizable file NOT found")
    }()
    
    func localize(string: String) -> String {
        
        var bundle = Bundle();
        /*3*/if let _path = Bundle.main.path(forResource: language.currentAppleLanguage(), ofType: "lproj") {
            bundle = Bundle(path: _path)!
        } else {
            let _path = Bundle.main.path(forResource: "Base", ofType: "lproj")!
            bundle = Bundle(path: _path)!
        }
        
        let path = bundle.path(forResource: "Strings", ofType: "plist")
        let localizableDictionary: NSDictionary = NSDictionary(contentsOfFile: path!)! as NSDictionary
        
        if let localizedString =  localizableDictionary.value(forKey: "\(string)") as? String{
            return localizedString
        }
        return ""
    }
}
extension UIViewController {
    func loopThroughSubViewAndFlipTheImageIfItsAUIImageView(subviews: [UIView]) {
        if subviews.count > 0 {
            for subView in subviews {
                if (subView is UIImageView) && subView.tag < 0 {
                    let toRightArrow = subView as! UIImageView
                    if let _img = toRightArrow.image {
                        toRightArrow.image = UIImage(cgImage: _img.cgImage!, scale:_img.scale , orientation: UIImageOrientation.upMirrored)
                    }
                }
                loopThroughSubViewAndFlipTheImageIfItsAUIImageView(subviews: subView.subviews)
            }
        }
    }

}

extension UILabel {
    public func cstmlayoutSubviews() {
      //  self.cstmlayoutSubviews()
        if self.isKind(of: NSClassFromString("UITextFieldLabel")!) {
            return // handle special case with uitextfields
        }
      
        if self.tag < 0  {
            if UIApplication.isRTL()  {
                if self.textAlignment == .right {
                    return
                }
            } else {
                if self.textAlignment == .left {
                    return
                }
            }
        }
        
       
        if self.tag < 0 {
            if UIApplication.isRTL()  {
                self.textAlignment = .right
            } else {
                self.textAlignment = .left
            }
        }
    }
}


extension UITextField {
    public func cstmlayoutSubviews() {
       // self.cstmlayoutSubviews()
        if self.tag < 0 {
            if UIApplication.isRTL()  {
                if self.textAlignment == .right { return }
                self.textAlignment = .right
            } else {
                if self.textAlignment == .left { return }
                self.textAlignment = .left
            }
        }
    }
}

extension UITextView {
    public func cstmlayoutSubviews() {
       // self.cstmlayoutSubviews()
        if self.tag < 0 {
            if UIApplication.isRTL()  {
                if self.textAlignment == .right { return }
                self.textAlignment = .right
            } else {
                if self.textAlignment == .left { return }
                self.textAlignment = .left
            }
        }
    }
}



