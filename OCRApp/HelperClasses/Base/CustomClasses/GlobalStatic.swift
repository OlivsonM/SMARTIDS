//
//  GlobalStatic.swift
//  LaundryApp
//


import UIKit
class GlobalStatic {
    
    static func getFormatedAddress(add: String) -> String {
        let addArr = add.components(separatedBy: "|")
        var addString = addArr[0]
        for i in 1..<addArr.count {
            if !addArr[i].isEmptyStr() {
            addString = addString + ", " + addArr[i]
            }
        }
        return addString
    }
    
    class func showLoginAlert(vc : UIViewController){
        DispatchQueue.main.async {
            Alert.showWithTwoActions(msg: "You need to login for this feature!", okBtnTitle: "Login", okBtnAction: {
                //vc.navigationController?.setViewControllers([LoginViewController.loadVC()], animated: true)
            }, cancelBtnTitle: "Cancel", cancelBtnAction: {
                
            } , vc: vc)
        }
        
    }
}
