//
//  FontDesignable.swift
//  TrafficFramework
//

import Foundation
import UIKit

@objc public protocol FontDesignable: class {
    
    var fontNameTheme:String? { get set }
    @objc optional var fontColorTheme:String? { get set }
    var fontSizeTheme:String? { get set }
    
    @objc optional var fontColorSelectedTheme:String? { get set }
}

extension FontDesignable where Self: UIBarButtonItem {
    internal func configureFont() {
        let fnt = getFont();
        guard fnt != nil else {
            #if DEBUG
                assertionFailure("Cannot load font: \(String(describing: fontNameTheme))");
            #endif
            return;
        }
        
        self.setTitleTextAttributes([NSAttributedStringKey.font:fnt!], for: UIControlState());
    }
}

extension FontDesignable where Self: UINavigationController {
    
    internal func configureFont() {
        let fnt = getFont();
        guard fnt != nil else {
            #if DEBUG
                assertionFailure("Cannot load font: \(String(describing: fontNameTheme))");
            #endif
            return;
        }
        
        let fColor = (fontColorTheme != nil && !(fontColorTheme??.isEmpty)!) ? ColorManager.color(forKey: fontColorTheme!) : UIColor.black;
        
        var attrDict:[NSAttributedStringKey : Any] = self.navigationBar.titleTextAttributes  ?? [NSAttributedStringKey : Any]()
        attrDict[NSAttributedStringKey.foregroundColor] = fColor;
        attrDict[NSAttributedStringKey.font] = fnt;
        
        self.navigationBar.titleTextAttributes = attrDict;
    }
}

extension FontDesignable where Self: UIView {
    
    internal func configureFont() {
        
        let fnt = getFont();
        guard fnt != nil else {
            #if DEBUG
                assertionFailure("Cannot load font: \(String(describing: fontNameTheme))");
            #endif
            return;
        }
        
        let fColor = (fontColorTheme != nil && !(fontColorTheme??.isEmpty)!) ? ColorManager.color(forKey: fontColorTheme!) : UIColor.black;
        
        if let view = self as? BaseUILabel {
            view.textColor = fColor;
            view.font = fnt;
        }
        else if let view = self as? BaseUITextField {
            view.textColor = fColor;
            view.font = fnt;
        }
        else if let view = self as? BaseUITextView {
            view.textColor = fColor;
            view.font = fnt;
            
            view.placeholderLabel.font = fnt;
        }
        else if let view = self as? BaseUIButton {
            view.titleLabel?.font = fnt;
            view.setTitleColor(fColor, for: .normal);
        }
    }
    
    internal func configureSelectedFont() {
        
        let fColor = (fontColorSelectedTheme != nil && !(fontColorSelectedTheme??.isEmpty)!) ? ColorManager.color(forKey: fontColorSelectedTheme!) : UIColor.black;
        
        if let view = self as? BaseUIButton {
            view.setTitleColor(fColor, for: .selected);
        }
    }
}

fileprivate extension FontDesignable {
    func getFont()->UIFont? {
        
        let fName = (fontNameTheme != nil && !(fontNameTheme?.isEmpty)!) ? FontManager.constant(forKey: fontNameTheme!) : "Helvetica";
        let fontSize = (fontSizeTheme != nil && !(fontSizeTheme?.isEmpty)!) ? FontManager.style(forKey: fontSizeTheme!) : 25;
        
        let resizedFontSize = DesignUtility.getFontSize(fSize: CGFloat(fontSize))
        
        let fnt = UIFont.init(name: fName!, size: resizedFontSize);
        return fnt;
    }
}

