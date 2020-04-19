//
//  MenuSelectionController.swift
//  OCRApp
//


import UIKit
import FCAlertView
import Crashlytics
import GoogleSignIn
class MenuSelectionController: BaseViewController,StoryBoardHandler {

    static var myStoryBoard: (forIphone: String, forIpad: String?) = (Storyboards.main.rawValue , nil)
    
    let isAgreeTerms = UserDefaults.standard.bool(forKey: "isAgreeTerms")
    @IBOutlet weak var signInButton: GIDSignInButton!
    @IBOutlet weak var logOutButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.navigationController?.hero.navigationAnimationType = .none
        // Do any additional setup after loading the view.
   
        if (isAgreeTerms == false) {
            Utility.delay(seconds: 0.5) {
                self.loadTermsAndCondition()
            }
            
        }
        
        prepareGoogle()
        prepareHandlers()
    }
    
    func prepareHandlers() {
        LoginManager.onUpdateToken = { [weak self] in
            self?.updateSignInButton()
        }
    }
    
    func updateSignInButton() {
        let hasToken = GIDSignIn.sharedInstance()?.currentUser?.authentication?.idToken != nil
        signInButton.isHidden = hasToken
        logOutButton.isHidden = !hasToken
    }
    
    func prepareGoogle() {
        let shared = GIDSignIn.sharedInstance()
        
        shared?.presentingViewController = self
        shared?.restorePreviousSignIn()
  
        updateSignInButton()
    }
    
    func loadTermsAndCondition() {
        
        let popupView = PopUpView.init(frame: self.view.frame)
        self.view.addSubview(popupView)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.isNavigationBarHidden = true
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.navigationController?.hero.navigationAnimationType = .auto
    }
    
    @IBAction func crashButtonTapped(_ sender: AnyObject) {
        Crashlytics.sharedInstance().crash()
    }

    @IBAction func actionLogOut(_ sender: Any) {
        GIDSignIn.sharedInstance().signOut()
        updateSignInButton()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.navigationController?.isNavigationBarHidden = false
    }
    @IBAction func selectExisting(_ sender: UIButton) {
        
        print(self.navigationController?.viewControllers)
        self.showThreeOptions()
        //self.navigationController?.pushViewController(PickCardController.loadVC(), animated: true)
        //self.navigationController?.pushViewController(CreateCardController.loadVC(), animated: true)
    }
    
    @IBAction func createNewCard(_ sender: UIButton) {
         print(self.navigationController?.viewControllers)
        
        //self.pushOrPopViewController(navigationController: self.navigationController!, animation: true, viewControllerClass: ChooseTemplateController.self, viewControllerStoryboad: (Storyboards.main.rawValue,nil))
        self.navigationController?.pushViewController(ChooseTemplateController.loadVC(), animated: true)
        
    }
    func showThreeOptions(){
        
        let actionSheetController = UIAlertController(title:"Please Select", message:"", preferredStyle: .actionSheet)
        let cancelActionButton = UIAlertAction(title: "Cancel",  style: .cancel) { action -> Void in
        }
        actionSheetController.addAction(cancelActionButton)
        let saveActionButton = UIAlertAction(title: "Camera", style: .default) { action -> Void in
            self.openCamera()
        }
        actionSheetController.addAction(saveActionButton)
        let deleteActionButton = UIAlertAction(title: "Photo Library", style: .default) { action -> Void in
            //self.openLibrary(showDocumentForm: showDocumentForm)
            self.openGallery()
        }
        actionSheetController.addAction(deleteActionButton)
        
        let scanCodeButton = UIAlertAction(title: "Scan QR Code", style: .default) { action -> Void in
            //self.openLibrary(showDocumentForm: showDocumentForm)
            //self.openGallery()
//            self.navigationController?.pushViewController(ChooseTemplateController.loadVC(), animated: true)
           // let scanController = ScanCoderController.loadVC()
            let scanController = QRScannerController.loadVC()
            scanController.callback = {
                (isSuccess) in
                if(isSuccess == true) {
                    
                    let alert = FCAlertView.init()
                    alert.showAlert(inView: self, withTitle: "Success", withSubtitle: "Card scanned successfully and saved into your wallet", withCustomImage: #imageLiteral(resourceName: "splashicon2"), withDoneButtonTitle: nil, andButtons: nil)
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
                    
                   // self.pushOrPopViewController(navigationController: self.navigationController!, animation: true, viewControllerClass: PickCardController.self, viewControllerStoryboad: (Storyboards.main.rawValue,nil))
                    self.navigationController?.pushViewController(PickCardController.loadVC(), animated: true)
                }
                else {
                    let alert = FCAlertView.init()
                    alert.showAlert(inView: self, withTitle: "Error", withSubtitle: "Invalid QR Code scanned", withCustomImage: #imageLiteral(resourceName: "splashicon2"), withDoneButtonTitle: nil, andButtons: nil)
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
              //  print(beatCount)
            }
            self.present(scanController, animated: true, completion: {
                print("Complete")
                
                
            })
            
            
        }
        
        
        actionSheetController.addAction(scanCodeButton)
        self.present(actionSheetController, animated: true) {
        }
        //self.present(actionSheetController, animated: true, completi
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func openCamera1(){
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
            let picker = UIImagePickerController()
            picker.sourceType = UIImagePickerControllerSourceType.camera;
            picker.cameraDevice = .rear
//            picker.allowsEditing = true
            picker.navigationBar.tintColor = UIColor.black
            picker.delegate = self
            
            picker.modalPresentationStyle = .currentContext
            //            picker.navigationBar.tintColor = UIColor.black
            self.present(picker, animated: true, completion: {
            })
        }
    }
    
    
    func openGallery1(){
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
            
            let picker = UIImagePickerController()
            picker.sourceType = UIImagePickerControllerSourceType.photoLibrary;
            
            picker.delegate = self
            picker.modalPresentationStyle = .currentContext
            picker.navigationBar.tintColor = UIColor.black
            //            navigationController?.navigationBar.topItem?.rightBarButtonItem?.tintColor = UIColor.black
            self.present(picker, animated: true, completion: {
                
                //self.picker.navigationBar.topItem?.rightBarButtonItem?.tintColor = UIColor.black
            })
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension UIImagePickerController {
    open override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.navigationBar.topItem?.rightBarButtonItem?.tintColor = UIColor.black
        self.navigationBar.topItem?.rightBarButtonItem?.isEnabled = true
    }
}

