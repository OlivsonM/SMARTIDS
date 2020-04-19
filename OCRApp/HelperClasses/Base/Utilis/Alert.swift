//
//  Alert.swift
//  BaseProject
//


import UIKit

public class Alert {
    
    private init(){
        
    }
    
    public static func showMsg(title : String = "", msg : String , btnActionTitle : String? = "Okay" , vc : UIViewController? = nil) -> Void{
        
        let alertController = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: btnActionTitle, style: .default) { (action) in
            
            alertController.dismiss(animated: true, completion: nil)
        }
        alertController .addAction(alertAction)
        
        DispatchQueue.main.async {
            if vc != nil {
                vc?.present(alertController, animated: true, completion: nil)
            }else{
                Alert.showOnWindow(alertController)
            }
        }
       
    }
    
    
    public static func showWithCompletion(title : String = "", msg : String , btnActionTitle : String? = "Okay" , completionAction: @escaping () -> Void , vc : UIViewController? = nil ) -> Void{
        
        let alertController = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: btnActionTitle, style: .default) { (action) in
            
            completionAction()
            alertController.dismiss(animated: true, completion: nil)
        }
        alertController .addAction(alertAction)
        
        DispatchQueue.main.async {
            if vc != nil {
                vc?.present(alertController, animated: true, completion: nil)
            }else{
                Alert.showOnWindow(alertController)
            }
        }
    }
    
    
    public static func showWithTwoActions(title : String = "" , msg : String , okBtnTitle : String , okBtnAction: @escaping () -> Void , cancelBtnTitle : String , cancelBtnAction: @escaping () -> Void , vc : UIViewController? = nil) -> Void {
        let alertController = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        let doneAction = UIAlertAction(title: okBtnTitle, style: .default, handler: { (action) in
    
            alertController.dismiss(animated: true, completion: nil)
            okBtnAction()
     
            })
        
        let cancelAction = UIAlertAction(title: cancelBtnTitle, style: .default, handler: { (action) in
    
            alertController.dismiss(animated: true, completion: nil)
             cancelBtnAction()
            })
       
        alertController .addAction(doneAction)
        alertController .addAction(cancelAction)
        
        
       DispatchQueue.main.async {
        
            if vc != nil {
                
                vc?.present(alertController, animated: true, completion: nil)
            }else{
                Alert.showOnWindow(alertController)
            }
        }
    }
    
    public static func showWithThreeActions( title : String , msg : String , FirstBtnTitle : String , FirstBtnAction: @escaping () -> Void , SecondBtnTitle : String , SecondBtnAction: @escaping () -> Void , cancelBtnTitle : String , cancelBtnAction: @escaping () -> Void ) -> Void{
        
        let alertController = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        
        let firstBtnAction = UIAlertAction(title: FirstBtnTitle, style: .default, handler: { (action) in
            
            FirstBtnAction()
        })
        
        
        let secondBtnAction = UIAlertAction(title: SecondBtnTitle, style: .default, handler: { (action) in
            
            SecondBtnAction()
        })
        
        
        let cancelAction = UIAlertAction(title: cancelBtnTitle, style: .default, handler: { (action) in
            
            alertController.dismiss(animated: true, completion: nil)
            cancelBtnAction()
        })
        
        alertController .addAction(firstBtnAction)
        alertController .addAction(secondBtnAction)
        alertController .addAction(cancelAction)
        
        
        
        Alert.showOnWindow(alertController)
        
    }
    
    private static func showOnWindow(_ alert : UIAlertController) {
        
        UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
        
    }
}
