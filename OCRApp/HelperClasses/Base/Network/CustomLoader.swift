//
//  CustomLoader.swift
//  LaundryApp
//


import UIKit
//MARK: ################    CUSTOM LOADER CLASS    ###############
class customLoader: NSObject {
    //MARK: ################    OUTLETS    ###############
    static var containerView : BaseUIView!
    static var imgView : UIImageView!
    static var viewOp : UIView!
    static var isLoaderShown : Bool = false
    static var  viewCOntrollerObj : UIViewController?
    ///   SHOW LOADER    
    class  func show(){
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        appdelegate.window?.isUserInteractionEnabled = false
        isLoaderShown = true
        let screenWidth = UIScreen.main.bounds.size.width
        let screenHeight = UIScreen.main.bounds.size.height
        let widthSize = DesignUtility.getValueFromRatio(75)
        let heightSize = DesignUtility.getValueFromRatio(75)
        let widthSizeView = DesignUtility.getValueFromRatio(150)
        let heightSizeView = DesignUtility.getValueFromRatio(150)
    
        containerView = BaseUIView.init(frame: CGRect(x: (screenWidth/2) - (widthSizeView/2) , y: (screenHeight/2) - (heightSizeView/2) , width: widthSizeView, height: heightSizeView))
        
        
        imgView = UIImageView(frame: CGRect(x: (widthSizeView/2) - (widthSize/2) , y: (heightSizeView/2) - (heightSize/2) , width: widthSize, height: heightSize))
        imgView.image = UIImage.init(named: "logo-small")
        imgView.contentMode = .scaleAspectFit
        viewCOntrollerObj = self.getVisibleViewController(UIApplication.shared.keyWindow?.rootViewController)
        viewOp  = UIView(frame: (viewCOntrollerObj?.view.frame)!)
        viewOp.alpha = 0.5
        viewOp.backgroundColor = UIColor.black
        viewCOntrollerObj?.view.addSubview(viewOp)
        containerView.addSubview(imgView)
        viewCOntrollerObj?.view.addSubview(containerView)
        containerView.backgroundColor = UIColor.white
        containerView.cornerRadius = DesignUtility.getValueFromRatio(10)
        
        imgView.rotate()
    }
    ///  GET VISIBLE CONTROLLER
    class func getVisibleViewController(_ rootViewController: UIViewController?) -> UIViewController? {
        var rootVC = rootViewController
        if rootVC == nil {
            rootVC = UIApplication.shared.keyWindow?.rootViewController
        }
        if rootVC?.presentedViewController == nil {
            return rootVC
        }
        if let presented = rootVC?.presentedViewController {
            if presented.isKind(of: UINavigationController.self) {
                let navigationController = presented as! UINavigationController
                return navigationController.viewControllers.last!
            }
            if presented.isKind(of: UITabBarController.self) {
                let tabBarController = presented as! UITabBarController
                return tabBarController.selectedViewController!
            }
            return getVisibleViewController(presented)
        }
        return nil
    }
    ///  HIDE CUSTOM LOADER
    class func hide(){
        isLoaderShown = false
        containerView.removeFromSuperview()
        
        imgView.removeFromSuperview()
        viewOp.removeFromSuperview()
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        appdelegate.window?.isUserInteractionEnabled = true
    }
}

