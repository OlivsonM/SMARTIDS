//
//  RecognitionController.swift
//  OCRApp
//

import UIKit
import FCAlertView
// Name of application you created
let MyApplicationID = "SmartIDMax"
// Password should be sent to your e-mail after application was created
let MyPassword = "r56nUM7kFvKLi5UYKF3uGgOD"
class RecognitionController: BaseViewController,StoryBoardHandler {

    static var myStoryBoard: (forIphone: String, forIpad: String?) = (Storyboards.main.rawValue , nil)
    var imgCard : UIImage!
    
    var scanCard : Card!
    let sdLoader = SDLoader()
    var client = Client.init(applicationID: MyApplicationID, password: MyPassword)
    var params : ProcessingParams?
    deinit {
        print("DEINIT")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupHeader()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationItem.title = "Recognizing Card"
        //self.navigationController?.isNavigationBarHidden = false
    }
    func setupHeader() {
        self.navigationController?.isNavigationBarHidden = false
        
        
     //   self.addBarButtonItemWithImage(#imageLiteral(resourceName: "btnbackarrow"),CustomNavBarEnum.CustomBarButtonItemPosition.BarButtonItemPositionLeft, self, #selector(goBack))
        
    
    }
    override func goBack() {
        
        let navController = self.navigationController
        let viewController = navController?.viewControllers[(navController?.viewControllers.count)! - 3]
        //print(viewController)
        client?.delegate = nil
        client = nil
        params = nil
        self.navigationController?.popToViewController(viewController!, animated: true)
        
    }
    func showLoader() {
        
        sdLoader.spinner?.lineWidth = 15
        sdLoader.spinner?.spacing = 0.2
        sdLoader.spinner?.sectorColor = UIColor.cyan.cgColor
        sdLoader.spinner?.textColor = UIColor.cyan
        sdLoader.spinner?.animationType = AnimationType.anticlockwise
        sdLoader.startAnimating(atView: self.view)
        sdLoader.spinner?.lblMessage?.text = "Image uploading..."
    }
    
    func hideLoader() {
        sdLoader.stopAnimation()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        setupOCR()
        showLoader()
        
    }
    
    func setupOCR() {
        
        showLoader()
        
        client?.delegate = self
        
        params = ProcessingParams.init()
        client?.processImage(imgCard, with: params)
       // sdLoader.spinner?.message = "Uploading image..."
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

extension RecognitionController : ClientDelegate {
    
    func clientDidFinishUpload(_ sender: Client!) {
        print("clientDidFinishUpload")
        
        sdLoader.spinner?.lblMessage?.text = "Processing image..."
    }
    func clientDidFinishProcessing(_ sender: Client!) {
        print("clientDidFinishProcessing")
       sdLoader.spinner?.lblMessage?.text = "Downloading result..."
    }
    func client(_ sender: Client!, didFinishDownloadData downloadedData: Data!) {
        print("didFinishDownloadData")
        print(downloadedData.utf8String)
        sdLoader.spinner?.lblMessage?.text = "Download complete..."
        let xml = SWXMLHash.config { // the xml variable is our XMLIndexer
            config in
            config.shouldProcessLazily = false
            }.parse(downloadedData.utf8String!)
    
//        print(xml["document"])
        print(xml["document"]["businessCard"])
//        print(xml["document"]["businessCard"]["field"])
        var name = ""
        var position = ""
        var company = ""
        var email = ""
        var phone = ""
        var address = ""
        var website = ""
        for ele in xml["document"]["businessCard"].children {
//            print(ele)
//            print(ele.element)
//            print(ele.element?.allAttributes)
//            print(ele.element?.attribute(by: "value"))
//            print(ele.element?.attribute(by: "type"))
           // print(ele.children)
            if let type = ele.element?.attribute(by: "type") {
                print(type.text)
                //print(type.name)
                if let value = ele.children[0].element?.text {
                    print(value)
                    if (type.text == "Phone") {
                        phone = value
                    }
                    if (type.text == "Mobile") {
                        phone = value
                    }
                    if (type.text == "Fax") {
                        
                    }
                    if (type.text == "Email") {
                        email = value
                    }
                    if (type.text == "Web") {
                        
                    }
                    if (type.text == "Address") {
                        address = value
                    }
                    if (type.text == "Name") {
                        name = value
                    }
                    if (type.text == "Company") {
                        company = value
                    }
                    if (type.text == "Job") {
                        position = value
                    }
                    if (type.text == "Website") {
                        website = value
                    }
                    if (type.text == "Web") {
                        website = value
                    }
                    if (type.text == "Text") {
                        
                    }
                }
            }
      
            
            
            
    }
    
        print(name)
        print(position)
        print(company)
        print(email)
        print(phone)
        print(address)
        print(website)
        let randomNum:Int = Int(arc4random_uniform(4)) + 1
        let newCard = Card(name: name,
                           poition: position,
                           company: company,
                           email: email,
                           phone: phone,
                           address: address,
                           linkedIn: "",
                           isMyCard: false,
                           cardColor: "",
                           cardId: "0",
                           templateId: String(randomNum),
                            website:website,
                            note: "")
        
        newCard.cardId = newCard.IncrementaID()
        print(newCard.debugDescription)
        Singleton.sharedInstance.scanCard = newCard
        Singleton.sharedInstance.isCardScan = true
//        RealmService.shared.create(newCard)
        hideLoader()
        
        let controller = CreateCardController.loadVC()
        
        
        controller.selectedCardId = randomNum
        
        client?.delegate = nil
        client = nil
        params = nil
        self.navigationController?.pushViewController(controller, animated: true)
        //self.navigationController?.pushViewController(ChooseTemplateController.loadVC(), animated: true)
        
    }
    
    func client(_ sender: Client!, didFailedWithError error: Error!) {
        print("didFailedWithError")
        
        var strMessage = "Invalid card scanned"
        if(NetworkManager.sharedInstance.reachability.connection == .none){
            strMessage =  "No internet connection available."
        }
        
        hideLoader()
        client?.delegate = self
        client = nil
        params = nil
        let alert = FCAlertView.init()
        alert.showAlert(inView: self, withTitle: "Error", withSubtitle: strMessage, withCustomImage: #imageLiteral(resourceName: "splashicon2"), withDoneButtonTitle: nil, andButtons: nil)
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
        goBack()
    }
}
//class ProcessingParams {
//    
//    func urlString() -> String {
//        
//        return "language=English&exportFormat=xml"
//        
//    }
//}


//extension  RecognitionController : XMLParserDelegate {
//
//    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
//
//    }
//    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
//
//    }
//    func parserDidEndDocument(_ parser: XMLParser) {
//
//    }
//}

extension Data {
    
    var utf8String: String? {
        return string(as: .utf8)
    }
    
    func string(as encoding: String.Encoding) -> String? {
        return String(data: self, encoding: encoding)
    }

}


class Singleton {
    
    static let sharedInstance = Singleton()
    
    //var userData:User!
    var deviceToken:String = ""
    var deviceId:String = ""
    var isCardScan = false
    var  scanCard:Card? = nil
    
    //var categories = [String]()
    //var categoriesId = [Int]()
    
    
//    var tagsData = [Tag]()
//    var categoriesData = [GetCategoriesCategories]()
//    var fieldData = [BaseFields]()
    
    
}
