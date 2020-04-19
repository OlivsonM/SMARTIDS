//
//  CustomReferesh.swift
//  LaundryApp
//


import UIKit

class CustomReferesh: UIRefreshControl {
    
  static let imgLogo = UIImageView.init(image: UIImage.init(named: "logo-small-home"))
  static let imgLogoFooter = UIImageView.init(image: UIImage.init(named: "logo-small-home"))
 
    class func addCustomLoader(refereshControl : UIRefreshControl){
        refereshControl.backgroundColor = .clear
        refereshControl.tintColor = .clear
    
       CustomReferesh.imgLogo.center = refereshControl.center
        refereshControl.addSubview(CustomReferesh.imgLogo)
            CustomReferesh.imgLogo.translatesAutoresizingMaskIntoConstraints = false
         CustomReferesh.imgLogo.centerXAnchor.constraint(equalTo: refereshControl.centerXAnchor).isActive = true
         CustomReferesh.imgLogo.centerYAnchor.constraint(equalTo: refereshControl.centerYAnchor).isActive = true
        DispatchQueue.main.async {
              CustomReferesh.imgLogo.rotate()
        }
      
        
      //  CustomReferesh.imgLogo.heightAnchor.constraint(equalTo: refereshControl.heightAnchor, multiplier: 0.7, constant: 0).isActive = true
     // CustomReferesh.imgLogo.widthAnchor.constraint(equalTo: CustomReferesh.imgLogo.heightAnchor, multiplier: 1, constant: 0).isActive = true
     
        

}
    
    
    
    class func getCustomLoaderToFooter() -> UIView{
      
        let view = UIView.init(frame:CGRect(x:0 , y : 0, width : DesignUtility.getValueFromRatio(414) , height : DesignUtility.getValueFromRatio(60)))
            
        CustomReferesh.imgLogoFooter.center = view.center
           view.addSubview( CustomReferesh.imgLogoFooter)
        CustomReferesh.imgLogoFooter.translatesAutoresizingMaskIntoConstraints = false
        
        CustomReferesh.imgLogoFooter.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        CustomReferesh.imgLogoFooter.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        CustomReferesh.imgLogoFooter.rotate()
        
        return view
    }
  

}
