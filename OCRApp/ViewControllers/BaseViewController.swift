//
//  BaseViewController.swift
//  LaundryApp
//

import UIKit
import PKCCrop

import MultipeerConnectivity
class BaseViewController: UIViewController {

    lazy var realm = RealmService.shared.realm
    //let picker = UIImagePickerController()
    lazy var choosenImage : UIImage? = nil
    
    
    
    var peerID:MCPeerID!
    var mcSession:MCSession!
    var mcAdvertiserAssistant:MCAdvertiserAssistant!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        PKCCropHelper.shared.degressBeforeImage = UIImage(named: "pkc_crop_rotate_left.png")
        PKCCropHelper.shared.degressAfterImage = UIImage(named: "pkc_crop_rotate_right.png")
        
        
        self.setupAppDefaultNavigationBar()
        self.hideKeyboardWhenTappedAround()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
     //   picker.delegate = self
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    //Mark : Customizing navigation bar, adding bar buttons and custom title view
    func setupAppDefaultNavigationBar()  {
        
        //Setting navigation bar background color, its font and title color
        let barBgColor = UIColor.white
        let titleFont = UIFont.init(name: "CabourgOT-Bold", size: DesignUtility.getFontSize(fSize: 17))
        
        self.navigationController?.navigationBar.setCustomNavigationBarWith(navigationBarTintColor: barBgColor, navigationBarTitleFont: titleFont!, navigationBarForegroundColor: UIColor.init(hexString:"#7b89a1"))
        
        self.navigationController?.view.backgroundColor = UIColor.white
        self.navigationItem.hidesBackButton = true
        
        self.navigationController?.navigationBar.layer.shadowColor = UIColor.lightGray.cgColor
        self.navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 0.0, height: 3.0)
        self.navigationController?.navigationBar.layer.shadowRadius = 3.0
        self.navigationController?.navigationBar.layer.shadowOpacity = 0.0
        self.navigationController?.navigationBar.layer.masksToBounds = false
        
        //If navigation controller have more than 1 view controller then add backbutton
        if self.navigationController != nil{
            
            self.setupSideButton()
        }
    }
    
    func setupSideButton(){
        
        if (self.navigationController?.viewControllers.count)! > 1{
            

            //Adding bar button items with given image and its position inside navigation bar and its selector
            
         //   (UIImage(named: "backBtn")?.maskWithColor(color: UIColor.white)?.withRenderingMode(.alwaysOriginal))!
            //self.addBarButtonItemWithImage(UIImage.init(named: "backBtn")!, CustomNavBarEnum.CustomBarButtonItemPosition.BarButtonItemPositionLeft, self, #selector(self.goBack))
        }
        
    }
    
    //Pop view controller
    @objc func goBack() {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    //Adding bar button items with given image and its position inside navigation bar and its selector
    func addBarButtonItemWithImage<T: CustomNavBarProtocol>(_ image:UIImage,_ postion: T, _ target:UIViewController, _ selector:Selector) {
        
        let btn1 = UIButton(type: .custom)
        btn1.setImage(image, for: .normal)
        btn1.frame = CGRect(x: 0, y: 0, width: DesignUtility.getValueFromRatio(44), height: DesignUtility.getValueFromRatio(44))
        btn1.addTarget(self, action: selector, for: .touchUpInside)
        
        let item1 = UIBarButtonItem(customView: btn1)
       
        
        if let postion = postion as? CustomNavBarEnum.CustomBarButtonItemPosition {
            
            switch postion {
            case .BarButtonItemPositionLeft:
                
                if self.navigationItem.leftBarButtonItem != nil{
                    
                    if (self.navigationItem.leftBarButtonItems?.count)! > 0{
                        
                        self.navigationItem.leftBarButtonItems?.append(item1)
                    }
                }
                else{
                    
                    self.navigationItem.leftBarButtonItem = item1
                }
                
            case .BarButtonItemPositionRight:
                
                if self.navigationItem.rightBarButtonItem != nil{
                    
                    if (self.navigationItem.rightBarButtonItems?.count)! > 0{
                        
                        self.navigationItem.rightBarButtonItems?.append(item1)
                    }
                }
                else{
                    
                    self.navigationItem.rightBarButtonItem = item1
                }
            }
        }
    }
    
    // Adding custom title view for navigation bar
    func addCustomTitleView(_ tileView:UIView) {
        
       // tileView.widthAnchor.constraint(equalToConstant: 150).isActive = true
        //tileView.heightAnchor.constraint(equalToConstant: 33).isActive = true
        
       // let titleView = UIView(frame: CGRect(x: 0, y: 0, width: 160, height: 20))
       // tileView.frame = titleView.bounds
    
       self.navigationItem.titleView = tileView
    }
    
    
    @objc func slideCell(cell : UITableViewCell) {
    
        Animations.slideView(view: cell)
    }
}

//Mark : - Custom delegate for accessing diferrent properties of navigation bar
protocol CustomNavBarProtocol { }

enum CustomNavBarEnum: CustomNavBarProtocol {
    
    enum CustomBarButtonItemPosition: Int, CustomNavBarProtocol {
        
        case  BarButtonItemPositionRight = 1
        case  BarButtonItemPositionLeft = 2
    }
}

//Customzing default navigation bar appearence
extension UINavigationBar
{
    
    func setCustomNavigationBarWith(navigationBarTintColor color:UIColor, navigationBarTitleFont titleFont:UIFont, navigationBarForegroundColor foregroundColor:UIColor)
    {
        //7b89a1
        //165    77    52
        barTintColor = color
        let titleDict: NSDictionary = [NSAttributedStringKey.foregroundColor: foregroundColor, NSAttributedStringKey.font: titleFont]
        titleTextAttributes = (titleDict as! [NSAttributedStringKey : Any])
    }
}

//Mark : - Delegate for pressing navigation controller toolbar buttons
protocol DelegateToolbarButtons {
    
    func chatButtonPressed()
    func forwardButtonPressed()
}



extension BaseViewController : UIImagePickerControllerDelegate,
UINavigationControllerDelegate {
    
    //Image selection option to pick image from camera or from photo library
    func showOptions(){
        
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
        self.present(actionSheetController, animated: true) {
        }
        //self.present(actionSheetController, animated: true, completi
    }
    
    
    //Image picker souce type check if it is camera
    func openCamera(){
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
            let picker = UIImagePickerController()
            picker.sourceType = UIImagePickerControllerSourceType.camera;
            picker.cameraDevice = .rear
           // picker.allowsEditing = true
            picker.navigationBar.tintColor = UIColor.black
            picker.delegate = self
            
            picker.modalPresentationStyle = .currentContext
//            picker.navigationBar.tintColor = UIColor.black
            self.present(picker, animated: true, completion: {
            })
        }
    }
    
    
    func openGallery(){
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
            
            let picker = UIImagePickerController()
            picker.sourceType = UIImagePickerControllerSourceType.photoLibrary;
           // picker.allowsEditing = true
             picker.delegate = self
             picker.modalPresentationStyle = .currentContext
            picker.navigationBar.tintColor = UIColor.black
//            navigationController?.navigationBar.topItem?.rightBarButtonItem?.tintColor = UIColor.black
            self.present(picker, animated: true, completion: {
               
                //self.picker.navigationBar.topItem?.rightBarButtonItem?.tintColor = UIColor.black
            })
        }
    }
    
    //MARK: - Delegates
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        choosenImage = info[UIImagePickerControllerOriginalImage] as? UIImage //2
        dismiss(animated:true, completion: nil)
        
        
        PKCCropHelper.shared.isNavigationBarShow = false
        let cropVC = PKCCropViewController(choosenImage!, tag: 1)
        cropVC.delegate = self
        self.navigationController?.pushViewController(cropVC, animated: true)
//        picker.pushViewController(cropVC, animated: true)
        
//        let controller = RecognitionController.loadVC()
//        controller.imgCard = choosenImage
//        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
}
extension BaseViewController : PKCCropDelegate{
    //return Crop Image & Original Image
    func pkcCropImage(_ image: UIImage?, originalImage: UIImage?) {
//        if let image = image{
//            self.widthConst.constant = image.size.width
//            self.heightConst.constant = image.size.height
//        }
//        self.imageView.image = image
        if(NetworkManager.sharedInstance.reachability.connection == .none){
            ///SHOW ALERT
            
            let card = CardPending.init(cardId: 0, path: savePendingCardImages(image!)!, status: PendingCardStatus.pending.rawValue)
            print("No network")
            RealmService.shared.create(card)
            // self.showPendingCardAlert()
            Alert.showMsg(msg: "Scan card has been added to the queue list.")
            self.navigationController?.popViewController(animated: true)
            return
        }
        
        let controller = RecognitionController.loadVC()
        controller.imgCard = image
        self.navigationController?.pushViewController(controller, animated: true)

        
    }
    
    //If crop is canceledx
    func pkcCropCancel(_ viewController: PKCCropViewController) {
        //viewController.navigationController?.popViewController(animated: true)
        let navController = self.navigationController
        self.navigationController?.popToViewController((navController?.viewControllers[(navController?.viewControllers.count)! - 2])!, animated: true)
        //viewController.navigationController?.popToRootViewController(animated: true)
    }
    
    //Successful crop
    func pkcCropComplete(_ viewController: PKCCropViewController) {
        if viewController.tag == 0{
            viewController.navigationController?.popViewController(animated: true)
        }else{
            viewController.dismiss(animated: true, completion: nil)
        }
    }
}

extension BaseViewController {
    
    func savePendingCardImages(_ image : UIImage) -> String?{
        
        let imageData = UIImagePNGRepresentation(image) as Data?
        let timestampFilename = String(Int(Date().timeIntervalSince1970)) + "_pending.png"
        
        
        let documentsDirectoryURL = try! FileManager().url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        // create a name for your image
        let fileURL = documentsDirectoryURL.appendingPathComponent(timestampFilename)
        
        
        if !FileManager.default.fileExists(atPath: fileURL.path) {
            do {
                try imageData!.write(to: fileURL)
                print("Image Added Successfully")
                return timestampFilename
                // return fileURL.path
            } catch {
                print(error)
                return nil
                
            }
        } else {
            print("Image Not Added")
            return nil
            
        }
        return nil
    }
    
    
   
}
