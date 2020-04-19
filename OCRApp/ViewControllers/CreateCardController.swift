//
//  CreateCardController.swift
//  OCRApp
//


import UIKit
 import ViewAnimator
import Spruce
import QRCode
class CreateCardController: BaseViewController,StoryBoardHandler {

    static var myStoryBoard: (forIphone: String, forIpad: String?) = (Storyboards.main.rawValue , nil)
    
    @IBOutlet weak var btnSubmit: CustomButton!
    @IBOutlet weak var websiteView: CustomTextFieldView!
    @IBOutlet weak var txtCompany: BaseUITextField!
    @IBOutlet weak var txtPosition: BaseUITextField!
    @IBOutlet weak var txtName: BaseUITextField!
    @IBOutlet weak var linkedInView: LinkedInTextFieldView!
    @IBOutlet weak var addressView: CustomTextFieldView!
    @IBOutlet weak var phoneView: CustomTextFieldView!
    @IBOutlet weak var emailView: CustomTextFieldView!
    @IBOutlet weak var noteView: LinkedInTextFieldView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    var isEditCard  = false
    var editCard : Card?
    static let arrColor = ["99FFCC","CCCC99","CCCCCC","CCCCFF","CCFF99","CCFFCC","CCFFFF","FFCC99","FFCCCC","FFFF99"]
    @IBOutlet weak var optionsView: OptionsView!
    
    var selectedCardId:Int? =  nil
    var selectedCardColor:String = "99FFCC"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureFields()
        configOptionsView()
        //self.navigationController?.hero.navigationAnimationType = .auto
        setupHeader()
        scrollView.isHidden = true
        if (selectedCardId != nil){
            optionsView.isHidden = true
        }
        
        if (Singleton.sharedInstance.isCardScan == true) {
            if let card = Singleton.sharedInstance.scanCard {
                prefilledData(card: card)
            }
        }
        
        if (isEditCard == true) {
            if ( editCard?.templateCardId != "") {
//                optionsView.isHidden = true
                //selectedCardId = Int((editCard?.templateCardId)!)
            }
            
        
           // optionsView.isHidden = true
            prefilledData(card: editCard!)
        }
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationItem.title = "Create Card"
        //self.navigationController?.isNavigationBarHidden = false
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.view.endEditing(true)
        //self.navigationController?.isNavigationBarHidden = true
    }
    override func viewDidDisappear(_ animated: Bool) {	
        super.viewDidDisappear(animated)
        self.view.endEditing(true)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        scrollView.isHidden = false

        scrollView.contentSize = CGSize(width: self.view.frame.size.width, height: btnSubmit.frame.origin.y + 100)

    }
    func setupHeader() {
        self.navigationController?.isNavigationBarHidden = false
        self.addBarButtonItemWithImage(#imageLiteral(resourceName: "btnbackarrow"),CustomNavBarEnum.CustomBarButtonItemPosition.BarButtonItemPositionLeft, self, #selector(goBack))
        self.addBarButtonItemWithImage(#imageLiteral(resourceName: "btnnavhome"),CustomNavBarEnum.CustomBarButtonItemPosition.BarButtonItemPositionRight, self, #selector(homeButtonPressed))
    }
    @IBAction func submitButtonPressed(_ sender: UIButton) {
        
        
        
    }
    
    override func goBack() {
        
        let navController = self.navigationController
        let viewController = navController?.viewControllers[(navController?.viewControllers.count)! - 2]
    
        if viewController is RecognitionController {
            self.navigationController?.popToViewController((navController?.viewControllers[(navController?.viewControllers.count)! - 4])!, animated: true)
        }
        else {
            self.navigationController?.popToViewController((navController?.viewControllers[(navController?.viewControllers.count)! - 2])!, animated: true)
        }
        
    }
    
    @objc func backButtonPressed() {
        
        print("cartButtonPressed")
        goBack()
        //   show(viewcontrollerInstance: CartPlaceholderViewController.loadVC())
    }
    
    @objc func homeButtonPressed() {
        
        print("cartButtonPressed")
       // self.pushOrPopViewController(navigationController: self.navigationController!, animation: true, viewControllerClass: MenuSelectionController.self, viewControllerStoryboad: (Storyboards.main.rawValue,nil))
        self.navigationController?.pushViewController(MenuSelectionController.loadVC(), animated: true)
    
    }
    func configureFields() {
    
        emailView.titleLabel.text = "E-mail:"
        phoneView.titleLabel.text = "Phone:"
        addressView.titleLabel.text = "Address:"
        linkedInView.titleLabel.text = "Add LinkedIn"
        websiteView.titleLabel.text = "Website"
        noteView.titleLabel.text = "Note"
        
        emailView.textField.rightImage = #imageLiteral(resourceName: "iconemail")
        phoneView.textField.rightImage = #imageLiteral(resourceName: "iconphone")
        addressView.textField.rightImage = #imageLiteral(resourceName: "iconaddress")
        websiteView.textField.rightImage = #imageLiteral(resourceName: "iconwebsite")
        linkedInView.textField.rightImage = nil
        noteView.textField.rightImage = #imageLiteral(resourceName: "noteicon")
        
        emailView.textField.placeholder = "Enter you e-mail address"
        phoneView.textField.placeholder = "Enter phone number"
        addressView.textField.placeholder = "Enter you address"
        linkedInView.textField.placeholder = "LinkedIn Profile(Highly Recommended)"
        websiteView.textField.placeholder = "Enter website"
        noteView.textField.placeholder = "Enter note"
        
        emailView.textField.keyboardType = .emailAddress
        phoneView.textField.keyboardType = .phonePad
        websiteView.textField.keyboardType = .URL
        linkedInView.textField.keyboardType = .URL
        
        //txtName.autocapitalizationType = .words
        
    }
    
    func prefilledData(card : Card) {
        
        txtName.text = card.name
        txtPosition.text = card.poition
        txtCompany.text = card.company
        emailView.textField.text = card.email
        phoneView.textField.text = card.phone
        addressView.textField.text = card.address
        linkedInView.textField.text = card.linkedIn
        websiteView.textField.text = card.website
        noteView.textField.text = card.note
        
    }
    
    func configOptionsView() {

        for hexColor in CreateCardController.arrColor {
            optionsView.dataArray.append(UIColor.init(hexString: hexColor))
        }
        
        optionsView.delegateOptions = self
        optionsView.colViewOptions.reloadData()
        
        optionsView.colViewOptions.selectItem(at:IndexPath.init(item: 0, section: 0), animated: false, scrollPosition: .centeredHorizontally)
    }
    
    @IBAction func submitCard(_ sender: CustomButton) {
    
         let status = validateForm()
        if status.0 == false {
            Alert.showMsg(msg: status.1)
            return
        }else {

            
        }
            var strCardId = ""
        
        if let cardID = selectedCardId {
            strCardId = String(cardID)
            selectedCardColor = ""
        }

        
            let newCard = Card(name: txtName.text!,
                               poition: txtPosition.text!,
                               company: txtCompany.text!,
                               email: emailView.textField.text!,
                               phone: phoneView.textField.text!,
                               address: addressView.textField.text!,
                               linkedIn: linkedInView.textField.text!,
                               isMyCard: false,
                               cardColor: selectedCardColor,
                               cardId: "0",
                               templateId: strCardId,
                               website: websiteView.textField.text!,
                               note: noteView.textField.text!)
        
        newCard.cardId = newCard.IncrementaID()
        let listCards =  realm.objects(Card.self).filter(RealmFilter.myCard)
        
        
        if(isEditCard == true) {
            newCard.cardId = (editCard?.cardId)!
            newCard.isMyCard = (editCard?.isMyCard)!
        }
        else {
            if(listCards.count <= 0 ) {
                newCard.isMyCard = true
            }
        }
        
            
            let encodedData = try? JSONEncoder().encode(newCard)
            var qrCode = QRCode(encodedData!)
            qrCode.size = CGSize(width: 500, height: 500)
        
            newCard.QRImagePath = saveQRImage(qrCode.image!)!
            print(newCard.debugDescription)
        
        if (isEditCard == true) {
            let dict: [String : Any?] = getDictionaryObject(card: newCard)
            print(dict)
            RealmService.shared.update(editCard!, with:dict)
        }
        else {
            RealmService.shared.create(newCard)
        }
        
         //Alert.showMsg(msg: "Card added successfully")
        Singleton.sharedInstance.isCardScan = false
        Singleton.sharedInstance.scanCard = nil
        if (newCard.isMyCard == true) {
            
            let controller = MyCardController.loadVC()
            controller.controllerType = .view
            controller.selectedCard = realm.objects(Card.self).filter(RealmFilter.myCard).first!
            
            self.navigationController?.pushViewController(controller, animated: true)
        }
        else {
            
           // self.pushOrPopViewController(navigationController: self.navigationController!, animation: true, viewControllerClass: PickCardController.self, viewControllerStoryboad: (Storyboards.main.rawValue,nil))
            
           self.navigationController?.pushViewController(PickCardController.loadVC(), animated: true)
        }
        
            
            
        }
    
    func getDictionaryObject(card : Card) -> [String : Any?] {
        
        let dict: [String : Any?] = ["name" : card.name,
                                     "poition" : card.poition,
                                     "company" : card.company,
                                     "email" : card.email,
                                     "phone" : card.phone,
                                     "address" : card.address,
                                     "linkedIn" : card.linkedIn,
                                     "isMyCard" : card.isMyCard,
                                     "cardColor" :card.cardColor,
                                     "cardId" : card.cardId,
                                     "templateCardId" : card.templateCardId,
                                     "website" : card.website,
                                     "QRImagePath" : card.QRImagePath,
                                     "note" : card.note,
                                     ]
        
        return dict
        
    }
    
    func saveQRImage(_ image : UIImage) -> String?{
        
        let imageData = UIImagePNGRepresentation(image) as Data?
        let timestampFilename = String(Int(Date().timeIntervalSince1970)) + "qr.png"
    
        
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

        
        
        
//        let filenamePath =  URL(fileReferenceLiteralResourceName: CreateCardController.getDocumentsDirectory().appendingPathComponent(timestampFilename))
//        let imgData = try! imageData?.write(to: filenamePath, options: [])
//        print(imgData)
        return nil
    }

    
    
    /* helper get Document Directory */
    class func getDocumentsDirectory() -> NSString {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        print("Path: \(documentsDirectory)")
        return documentsDirectory as NSString
    }
    
    func validateForm() -> (Bool , String)  {
        
        let name = txtName.text
        let postion = txtPosition.text
        let company = txtCompany.text
        let email = emailView.textField.text
        let phone = phoneView.textField.text
        let address = addressView.textField.text
        let linkedinUrl = linkedInView.textField.text
        let website = websiteView.textField.text
        let note = noteView.textField.text
        
        if (name?.isEmptyStr())!{
            return (false, "Kindly provide name")
        }else if (postion?.isEmptyStr())!{
            return (false, "Kindly provide position")
        }else if (company?.isEmptyStr())! {
            return (false, "Kindly provide company")
        }else if (email?.isEmptyStr())! {
            return (false, "Kindly provide e-mail address")
        }else if !(email?.isValidEmail())! {
            return (false, "Kindly provide a valid e-mail address")
        }
        else if (phone?.isEmptyStr())! {
            return (false, "Kindly provide phone")
        }
        else if (address?.isEmptyStr())! {
            return (false, "Kindly provide address")
        }
//        else if (website?.isEmptyStr())! {
//            return (false, "Kindly provide website")
//        }
//        else if (website?.isValidUrl())! {
//            return (false, "Kindly provide valid website URL")
//        }
//        else if (linkedinUrl?.isEmptyStr())! {
//            return (false, "Kindly provide linkedin URL")
//        }
        
        return (true, "")
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

}


extension CreateCardController {
    
}

extension CreateCardController : OptionsViewProtocol {
    
    func didSelectItemAtIndex(index: Int) {
        print(optionsView.dataArray[index])
        selectedCardColor = CreateCardController.arrColor[index]
    }
}
