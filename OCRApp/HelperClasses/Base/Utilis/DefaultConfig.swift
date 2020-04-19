//
//  DefaultConfig.swift
//  TrafficFramework
//


import UIKit

public let DEFAULT_CONFIG = DefaultConfig.shared;

public class DefaultConfig: NSObject {
    
    static let shared = DefaultConfig()
    
    //Project settings
    public var baseUrl:String = "http://laundry.stagingic.com/api/";
    public var baseUrlImage:String = "http://laundry.stagingic.com/api/resize/";

    public var defaultFontName:String = "fontDefault";
    public var defaultFontSize:String = "sizeMedium";
    public var defaultFontColor:String = "theme";
    
    public var defaultButtonFontColor = "themeButton";
    public var defaultButtonSelectedFontColor = "themeSelectedButton";

    public var defaultButtonImageSpacing:CGFloat = 5;
    
    public var defaultShadowRadius:CGFloat = 2;
    public var defaultShadowOpacity:CGFloat = 0.3;
    
    public var fontFactorWidth           = UIScreen.main.bounds.width / 414 //resize font according to screen size
    
    public var windowFrame                = UIScreen.main.bounds
    public var screenSize                 = UIScreen.main.bounds.size
    public var windowWidth                = UIScreen.main.bounds.size.width
    public var windowHeight               = UIScreen.main.bounds.size.height
    
    //public var appDelegate                = UIApplication.shared.delegate as! AppDelegate
    public var window                    = UIApplication.shared.delegate!.window!
    
    public var userDefaults               = UserDefaults.standard
    
    
    //PRIVATE init so that singleton class should not be reinitialized from anyother class
    fileprivate override init() {
        super.init()
    }
}
