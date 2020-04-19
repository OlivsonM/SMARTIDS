//
//  ViewController.swift
//  OCRApp
//


import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
//        LISDKAPIHelper.sharedInstance().getRequest("https://api.linkedin.com/v1/people/~", success: { (test) in
//            print(test)
//        }) { (error) in
//            print(error)
//        }
        syncLinkedIn()
        
    }

    
    func syncLinkedIn()  {
        //LISDK_FULL_PROFILE_PERMISSION
        /*
         LISDK_BASIC_PROFILE_PERMISSION,LISDK_FULL_PROFILE_PERMISSION,LISDK_W_SHARE_PERMISSION,LISDK_CONTACT_INFO_PERMISSION,LISDK_EMAILADDRESS_PERMISSION
         */
        LISDKSessionManager.createSession(withAuth: [LISDK_BASIC_PROFILE_PERMISSION,LISDK_W_SHARE_PERMISSION,], state: "some state", showGoToAppStoreDialog: true, successBlock: { (returnState) in
            print("success called!")
            let session = LISDKSessionManager.sharedInstance().session
            print(session?.value())
            print((session?.isValid())! ? "yes":"no")
            
           // var text = NSMutableString()
            
            
            let text:NSMutableString = NSMutableString.init(string: (session?.accessToken.description)!)
            text.append("state'\'\(String(describing: returnState))'\'")
            print(text)
            self.getData()
            
        }) { (error) in
            print("error called!")
            print(error.debugDescription)
        }
        
        
    }
    
    
    func getData() {
        
        let body = ""
        LISDKAPIHelper.sharedInstance().apiRequest("https://api.linkedin.com/v1/people-search:first-name=bill&last-name=gates", method: "GET", body: body.data(using: .utf8), success: { (response) in
            print(response?.data)
        }) { (apiError) in
            print(apiError?.errorResponse())
        }
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

