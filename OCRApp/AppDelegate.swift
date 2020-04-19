//
//  AppDelegate.swift
//  OCRApp
//


import UIKit
import IQKeyboardManagerSwift
import Fabric
import Crashlytics
import RealmSwift
import Realm
import GoogleSignIn
@UIApplicationMain


class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    var client : Client?
    var params : ProcessingParams?
    
    var timer : Timer!
//    var client = Client.init(applicationID: MyApplicationID, password: MyPassword)
//    let params = ProcessingParams.init()
    var isUploadingCard = false
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        print(url.absoluteString)
        
        
        
        
        if (LISDKCallbackHandler.shouldHandle(url)){
            
            return LISDKCallbackHandler.application(app, open: url, sourceApplication: options[.sourceApplication] as! String!, annotation: options[.annotation])
            
        }
        return GIDSignIn.sharedInstance().handle(url)
    }
    
    func application(_ application: UIApplication,
                     open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return GIDSignIn.sharedInstance().handle(url)
    }
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
       
        //--ww  getFontNames()
        setMigration()
        print(RealmService.shared.realm.configuration.fileURL!)
        IQKeyboardManager.sharedManager().enable = true
        UserDefaults.standard.setValue(false, forKey: "_UIConstraintBasedLayoutLogUnsatisfiable")
        getFontNames()
//        setHomeController()
        
        UserDefaults.standard.register(defaults: ["isAgreeTerms" : false])
//        UserDefaults.standard.setValue(false, forKey: "isAgreeTerms")
        Fabric.with([Crashlytics.self])

        NetworkManager.sharedInstance.observeReachability()
        NetworkManager.sharedInstance.delegate = self
        //client?.delegate = self
        print(Realm.Configuration.defaultConfiguration.fileURL)
        scheduleTimer()
        GIDSignIn.sharedInstance().clientID = "759207514587-a6ssvrfohn0i5kr8jq202nndusgf4erh.apps.googleusercontent.com"
        GIDSignIn.sharedInstance().delegate = self
        
        return true
    }
    
    func setMigration() {
        // Inside your application(application:didFinishLaunchingWithOptions:)
        
        let config = Realm.Configuration(
            // Set the new schema version. This must be greater than the previously used
            // version (if you've never set a schema version before, the version is 0).
            schemaVersion: 11,
            
            // Set the block which will be called automatically when opening a Realm with
            // a schema version lower than the one set above
            migrationBlock: { migration, oldSchemaVersion in
                // We haven’t migrated anything yet, so oldSchemaVersion == 0
                if (oldSchemaVersion < 1) {
                    // Nothing to do!
                    // Realm will automatically detect new properties and removed properties
                    // And will update the schema on disk automatically
                }
        })
        
        // Tell Realm to use this new configuration object for the default Realm
        Realm.Configuration.defaultConfiguration = config
        
        // Now that we've told Realm how to handle the schema change, opening the file
        // will automatically perform the migration
        //        let realm = try! Realm()
        let realm = try! Realm(configuration: config)
    }
    

    func getFontNames()  {
        for fontFamilyName in UIFont.familyNames{
            for fontName in UIFont.fontNames(forFamilyName: fontFamilyName){
                print("Family: \(fontFamilyName)     Font: \(fontName)")
            }
        }
    }
    
   
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

extension AppDelegate: GIDSignInDelegate  {
   func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
          withError error: Error!) {
    if let error = error {
        if (error as NSError).code == GIDSignInErrorCode.hasNoAuthInKeychain.rawValue {
            print("The user has not signed in before or they have since signed out.")
        } else {
            print("\(error.localizedDescription)")
        }
        return
    }
        print("Token", user.authentication.idToken)
        let userId = user.userID                  // For client-side use only!
        let idToken = user.authentication.idToken // Safe to send to the server
        let fullName = user.profile.name
        let givenName = user.profile.givenName
        let familyName = user.profile.familyName
        let email = user.profile.email
        LoginManager.onUpdateToken?()
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!,
          withError error: Error!) {
        LoginManager.onUpdateToken?()
  // Perform any operations when the user disconnects from app here.
  // ...
    }
}

