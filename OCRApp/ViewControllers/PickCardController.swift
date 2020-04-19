//
//  PickCardController.swift
//  OCRApp
//


import UIKit
import HFCardCollectionViewLayout
import Lightbox
import RealmSwift
import FCAlertView
struct CardInfo {
    var color: UIColor
    var icon: UIImage
    var imgCard : UIImage
}
struct CardLayoutSetupOptions {
    var firstMovableIndex: Int = 0
    var cardHeadHeight: CGFloat = DesignUtility.getValueFromRatio(65)
    var cardShouldExpandHeadHeight: Bool = false
    var cardShouldStretchAtScrollTop: Bool = true
    var cardMaximumHeight: CGFloat = DesignUtility.getValueFromRatio(247)
    var bottomNumberOfStackedCards: Int = 5
    var bottomStackedCardsShouldScale: Bool = true
    var bottomCardLookoutMargin: CGFloat = 0
    var bottomStackedCardsMaximumScale: CGFloat = 1.0
    var bottomStackedCardsMinimumScale: CGFloat = 0.94
    var spaceAtTopForBackgroundView: CGFloat = 0
    var spaceAtTopShouldSnap: Bool = true
    var spaceAtBottom: CGFloat = 0
    var scrollAreaTop: CGFloat = 120
    var scrollAreaBottom: CGFloat = 120
    var scrollShouldSnapCardHead: Bool = false
    var scrollStopCardsAtTop: Bool = true
    //DesignUtility.getValueFromRatio(414)
    var numberOfCards: Int = 4
    
}

class PickCardController:  BaseViewController,StoryBoardHandler {

    
    var cards:Results<Card>!
    var notificationToken : NotificationToken?
    
    
    static var myStoryBoard: (forIphone: String, forIpad: String?) = (Storyboards.main.rawValue , nil)
    @IBOutlet weak var viewSearch: CustomTextFieldView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    var cardCollectionViewLayout: HFCardCollectionViewLayout?
    var selectedLongPressindex = 0
    @IBOutlet var backgroundView: UIView?
    @IBOutlet var backgroundNavigationBar: UINavigationBar?
    
    var cardLayoutOptions: CardLayoutSetupOptions?
    var shouldSetupBackgroundView = false
    
    var cardArray: [CardInfo] = []
    
    var btnFilter:CustomButton1!
    var selectedCell: PickCardCell? = nil
    var newGroupText = ""
    var isAddCardToGroup = false
    override func viewDidLoad() {
        super.viewDidLoad()
//        collectionView.contentInsetAdjustmentBehavior = .never
//        self.contentInsetAdjustmentBehavior = .never
        self.collectionView.isHidden = true
        configureRealm()
        configureFields()
        setupHeader()
        
        self.view?.setNeedsLayout()
        self.view?.layoutIfNeeded()
        self.collectionView?.setNeedsLayout()
        self.collectionView?.layoutIfNeeded()
        self.collectionView?.reloadData()
        
        
         self.setupExample()
    
        let lpgr : UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action:#selector(PickCardController.handleLongPress(gestureRecognizer:)))
        lpgr.minimumPressDuration = 0.7
        lpgr.delegate = self
        lpgr.delaysTouchesBegan = true
        self.collectionView?.addGestureRecognizer(lpgr)
        
        // Do any additional setup after loading the view.
    }
    
    @objc func handleLongPress(gestureRecognizer : UILongPressGestureRecognizer){
        
//        if (gestureRecognizer.state != UIGestureRecognizerState.ended){
//            return
//        }

        if (gestureRecognizer.state != UIGestureRecognizerState.began){
            let p = gestureRecognizer.location(in: self.collectionView)
            
            if let inex : NSIndexPath = (self.collectionView?.indexPathForItem(at: p))! as NSIndexPath{
                //do whatever you need to do
                print(inex.row)
                self.selectedLongPressindex = inex.row
                //self.deleteLongPressButtonPressed()
                self.showCardOptions()
            }
        }
        
        
    }
    @objc func deleteLongPressButtonPressed() {
        
        let cardCount = realm.objects(Card.self).filter(RealmFilter.otherCard)
        if (cardCount.count <= 0) {
            Alert.showMsg(msg: "No card available to delete")
            return
        }
        let alert = FCAlertView.init()
        alert.showAlert(inView: self, withTitle: "Delete Card", withSubtitle: "Are you sure you want to delete card?", withCustomImage: #imageLiteral(resourceName: "splashicon2"), withDoneButtonTitle: nil, andButtons: ["Yes","No"])
        alert.delegate = self
        alert.dismissOnOutsideTouch = true
        alert.colorScheme = UIColor.blue
        alert.hideDoneButton = true
        alert.blurBackground = true
        //        alert.bounceAnimations = true
        alert.animateAlertInFromBottom = true
        alert.animateAlertOutToBottom = true
        alert.avoidCustomImageTint = true
        //        var index = 0
        //        if(self.cardCollectionViewLayout!.revealedIndex >= 0) {
        //            index = self.cardCollectionViewLayout!.revealedIndex
        //        }
        //        self.cardCollectionViewLayout?.flipRevealedCardBack(completion: {
        //            self.cardArray.remove(at: index)
        //            self.collectionView?.deleteItems(at: [IndexPath(item: index, section: 0)])
        //        })
    }
    
    @objc func createNewGroupPopUp() {
        
        let alert = FCAlertView.init()
        
        alert.addTextField(withPlaceholder: "Create Group") { (text) in
            print(text)
            self.newGroupText = text!
//            if (text?.isEmptyStr())!{
//                Alert.showMsg(msg: "Kindly provide group name")
//            }
//            else{
//
//            }
        }
        
        //alert.textFieldDidEndEditing(UITextField)
        alert.delegate = self
        alert.tag = 100
        alert.hideDoneButton = true
        alert.blurBackground = true
        //        alert.bounceAnimations = true
        alert.animateAlertInFromBottom = true
        alert.animateAlertOutToBottom = true
        alert.avoidCustomImageTint = true
        alert.showAlert(inView: self, withTitle: "New Group", withSubtitle: "Create group to add selected card in a group", withCustomImage: #imageLiteral(resourceName: "splashicon2"), withDoneButtonTitle: nil, andButtons: ["Done","Cancel"])
        
    }
    
    
    func createNewGroup() {
        
        let newGroup = CardGroup(name: self.newGroupText)
        let groupExists = NSPredicate(format: "groupName == %@", self.newGroupText)
        let listGroup =  realm.objects(CardGroup.self).filter(groupExists)
        print(listGroup)
        print(listGroup.count)
        if(listGroup.count > 0) {
            Alert.showMsg(msg: "Group is already created")
        }
        else{
            RealmService.shared.create(newGroup)
            if(isAddCardToGroup) {
                self.isAddCardToGroup = false
                self.updateCardGroup(group: newGroup)
            }
            //self.updateCardGroup(group: newGroup)
         
        }
    }
    
    func updateCardGroup(group : CardGroup? = nil) {
        let editCard = self.cards[selectedLongPressindex]
       // editCard.groupName = self.newGroupText
        var dict: [String : Any?] = getDictionaryObject(card: editCard)
        dict["groupName"] = self.newGroupText
        print(dict)
        RealmService.shared.update(editCard, with:dict)
        self.newGroupText = ""
    }
    @objc func addNotePopUp() {
        
        let alert = FCAlertView.init()
        
        let customField = UITextField.init()
        let editCard = self.cards[selectedLongPressindex]
        customField.text = editCard.note
//        UITextField *customField = [[UITextField alloc] init];
//        customField.autocapitalizationType = UITextAutocapitalizationTypeAllCharacters;
        
        alert.addTextField(withCustomTextField: customField, andPlaceholder: "Make/Change Note") { (text) in
            print(text)
            self.addNote(note: text)
            self.collectionView.reloadData()
        }
        
//        alert.addTextField(withPlaceholder: "Make/Change Note") { (text) in
//            print(text)
//            self.addNote(note: text)
//            self.collectionView.reloadData()
//        }
        
        //alert.textFieldDidEndEditing(UITextField)
       // alert.delegate = self
        alert.tag = 200
        alert.hideDoneButton = true
        alert.blurBackground = true
        //        alert.bounceAnimations = true
        alert.animateAlertInFromBottom = true
        alert.animateAlertOutToBottom = true
        alert.avoidCustomImageTint = true
        
        alert.showAlert(inView: self, withTitle: "Make/Change note", withSubtitle: "Enter/edit note for selected card", withCustomImage: #imageLiteral(resourceName: "splashicon2"), withDoneButtonTitle: nil, andButtons: ["Done","Cancel"])
        
    }
    func addNote(note : String? = nil) {
        let editCard = self.cards[selectedLongPressindex]
        // editCard.groupName = self.newGroupText
        var dict: [String : Any?] = getDictionaryObject(card: editCard)
        dict["note"] = note!
        print(dict)
        RealmService.shared.update(editCard, with:dict)
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
                                     //"groupName" : self.newGroupText,
                                     "groupName" : self.newGroupText,
                                     "note" : card.note,
                                     ]
        
        return dict
        
    }
    
    func addInExistingGroup() {
        
        
            
            print("filterPressed")
            let picker = TCPickerView()
            picker.title = "Groups"
            let listGroup =  realm.objects(CardGroup.self)
        var cars :  [String]  = []
        
        for grp in listGroup {
            cars.append(grp.groupName)
        }
       // picker.tag = 100
            let values = cars.map { TCPickerView.Value(title: $0) }
            picker.values = values
            picker.delegate = self
            picker.selection = .single
            //picker.itemsFont = UIFont.init(name: "CabourgOT-Regular", size: DesignUtility.getFontSize(fSize: 15))!
            picker.completion = { (selectedIndexes) in
                for i in selectedIndexes {
                    print(values[i].title)
                    self.newGroupText = values[i].title
                    self.updateCardGroup()
                    //self.applyFilter(i,value: values[i].title)
                   // self.btnFilter.updateButtonUI(filterName: values[i].title)
                }
            }
            picker.show()
        }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.title = "Filter"
        //self.navigationController?.isNavigationBarHidden = false
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        notificationToken?.invalidate()
        RealmService.shared.stopObservingErrors(in: self)
    }
    

    
    func setupHeader() {
     //   self.navigationController?.isNavigationBarHidden = false
        
         //self.addBarButtonItemWithImage(#imageLiteral(resourceName: "btnnavhome"),CustomNavBarEnum.CustomBarButtonItemPosition.BarButtonItemPositionLeft, self, #selector(homeButtonPressed))
        
        
        //self.addBarButtonItemWithImage(#imageLiteral(resourceName: "menuicon"),CustomNavBarEnum.CustomBarButtonItemPosition.BarButtonItemPositionLeft, self, #selector(homeButtonPressed))
        self.addBarButtonItemWithImage(#imageLiteral(resourceName: "topnavcamera"),CustomNavBarEnum.CustomBarButtonItemPosition.BarButtonItemPositionLeft, self, #selector(openScanCamaera))
        
        
        self.addBarButtonItemWithImage(#imageLiteral(resourceName: "shareappicon"),CustomNavBarEnum.CustomBarButtonItemPosition.BarButtonItemPositionLeft, self, #selector(shareButtonPressed))
       //self.addBarButtonItemWithImage(#imageLiteral(resourceName: "topnavcamera"),CustomNavBarEnum.CustomBarButtonItemPosition.BarButtonItemPositionLeft, self, #selector(cameraButtonPressed))
        
        //self.addBarButtonItemWithImage(#imageLiteral(resourceName: "topnavcard"),CustomNavBarEnum.CustomBarButtonItemPosition.BarButtonItemPositionRight, self, #selector(cardButtonPressed))
        
        self.addBarButtonItemWithImage(#imageLiteral(resourceName: "topnewmycard"),CustomNavBarEnum.CustomBarButtonItemPosition.BarButtonItemPositionRight, self, #selector(cardButtonPressed))
        
        self.addBarButtonItemWithImage(#imageLiteral(resourceName: "qriconnew"),CustomNavBarEnum.CustomBarButtonItemPosition.BarButtonItemPositionRight, self, #selector(showQrApp))
        
        //self.addBarButtonItemWithImage(#imageLiteral(resourceName: "topnavcarddelete"),CustomNavBarEnum.CustomBarButtonItemPosition.BarButtonItemPositionRight, self, #selector(openScanCamaera))
        
        //self.addBarButtonItemWithImage(#imageLiteral(resourceName: "topnavcamera"),CustomNavBarEnum.CustomBarButtonItemPosition.BarButtonItemPositionRight, self, #selector(openScanCamaera))
        
        
        //let button:UIButton = UIButton()
        let button:UIButton = UIButton(frame: CGRect(x: 0, y: 50, width: 220, height: 115))
        button.backgroundColor = .black
        button.setTitle("But", for: .normal)
         //self.navigationItem.titleView = button
        button.titleLabel?.font = UIFont(name: "PingFangSC-Thin", size: 5)
        self.navigationItem.titleView?.backgroundColor = UIColor.blue
        
        
        
        btnFilter = CustomButton1(title: "Filter", subtitle: "Subtitle")
        btnFilter.translatesAutoresizingMaskIntoConstraints = false
        self.navigationItem.titleView = btnFilter
        btnFilter.addTarget(self, action:#selector(self.filterPressed), for: .touchUpInside)
       // button.addTarget(self, action:#selector(self.buttonClicked), for: .touchUpInside)
       // self.view.addSubview(button)
        
        //let imgView = UIImageView.init(image: UIImage.init(named: "logo-small-home"))
        //imgView.contentMode = .center
        //self.addCustomTitleView(button)
    }
    
    @objc func showQrApp() {
        // Create an array of images.
        let images = [
//            LightboxImage(imageURL: URL(string: "https://cdn.arstechnica.net/2011/10/05/iphone4s_sample_apple-4e8c706-intro.jpg")!),
//            LightboxImage(
//                image: UIImage(named: "photo1")!,
//                text: "This is an example of a remote image loaded from URL"
//            ),
//            LightboxImage(
//                image: UIImage(named: "photo2")!,
//                text: "",
//                videoURL: URL(string: "https://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4")
//            ),
            
            LightboxImage(
                image: #imageLiteral(resourceName: "appqr"),
                text: "Visit our website by scaning the QR"
            )
        ]
        // Create an instance of LightboxController.
        let controller = LightboxController(images: images)
        
        // Set delegates.
//        controller.pageDelegate = self
//        controller.dismissalDelegate = self
        
        // Use dynamic background.
        controller.dynamicBackground = true
        
        // Present your controller.
        present(controller, animated: false, completion: nil)
    }
    
    @objc func shareButtonPressed() {
        
        print("cartButtonPressed")
        let someText:String = "SmartID "
        let objectsToShare:URL = URL(string: "https://itunes.apple.com/us/app/smartid/id1390685401?ls=1&mt=8")!
        let sharedObjects:[AnyObject] = [objectsToShare as AnyObject,someText as AnyObject]
        let activityViewController = UIActivityViewController(activityItems : sharedObjects, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        
     //   activityViewController.excludedActivityTypes = [ UIActivityType.airDrop, UIActivityType.postToFacebook,UIActivityType.postToTwitter,UIActivityType.mail]
        
        self.present(activityViewController, animated: true, completion: nil)
    
        
    }
    @objc func openScanCamaera() {
        
        showThreeOptions()
        
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
        
        
        let acceptCard = UIAlertAction(title: "Search Shared Card", style: .default) { action -> Void in
            //self.openLibrary(showDocumentForm: showDocumentForm)
            //self.openGallery()
            //var myCard = MyCardController()
            self.initializePeerConnection()
            self.recieveCardData()
            
            
            
        }
        actionSheetController.addAction(acceptCard)
        
        
        self.present(actionSheetController, animated: true) {
        }
        
        
        
        
        
        
        
        
        //self.present(actionSheetController, animated: true, completi
    }
    
    func showCardOptions() {
        let actionSheetController = UIAlertController(title:"Please Select", message:"", preferredStyle: .actionSheet)
        let cancelActionButton = UIAlertAction(title: "Cancel",  style: .cancel) { action -> Void in
        }
        actionSheetController.addAction(cancelActionButton)
        let saveActionButton = UIAlertAction(title: "Edit Card", style: .default) { action -> Void in
          //  self.openCamera()
            self.editCard()
            
            

            
        }
        actionSheetController.addAction(saveActionButton)
        let deleteActionButton = UIAlertAction(title: "Delete Card", style: .default) { action -> Void in
            self.deleteLongPressButtonPressed()
        }
        actionSheetController.addAction(deleteActionButton)
        
        let createGroupActionButton = UIAlertAction(title: "Create Group", style: .default) { action -> Void in
            self.isAddCardToGroup = true
            self.createNewGroupPopUp()
        }
        actionSheetController.addAction(createGroupActionButton)
        
        let createAddNoteButton = UIAlertAction(title: "Make/Change note", style: .default) { action -> Void in
           // self.isAddCardToGroup = true
            self.addNotePopUp()
        }
        actionSheetController.addAction(createAddNoteButton)
        
        let listGroup =  realm.objects(CardGroup.self)
        if (listGroup.count > 0) {
            let addExistingGroupActionButton = UIAlertAction(title: "Add in existing group", style: .default) { action -> Void in
                self.addInExistingGroup()
            }
            actionSheetController.addAction(addExistingGroupActionButton)
        }
        
        self.present(actionSheetController, animated: true) {
        }
    }
    
    
    func editCard() {
        
//        let  controller = CreateCardController.loadVC()
//        controller.isEditCard = true
//        controller.editCard = self.cards[selectedLongPressindex]
//        self.navigationController?.pushViewController(controller, animated: true)
        
        let  controller = ChooseTemplateController.loadVC()
        controller.isEditCard = true
        controller.editCard = self.cards[selectedLongPressindex]
        self.navigationController?.pushViewController(controller, animated: true)
        
    }
    
    func configureRealm() {
        
        notificationToken?.invalidate()
        RealmService.shared.stopObservingErrors(in: self)
        
        
        cards = realm.objects(Card.self).filter(RealmFilter.otherCard)
        print(cards.count)
        notificationToken = realm.observe { (notification, realm) in
            print(notification)
            print(realm)
            
        }
        RealmService.shared.observeRealmErrors(in: self) { (error) in
            //handle error
            print(error ?? "no error detected")
        }
        
    }
    @objc func filterPressed() {
        
        
        print("filterPressed")
        let picker = TCPickerView()
        picker.title = "Filters"
        var cars = [
            "A-Z",
            "Z-A",
            "Newest",
            "Oldest",
            //"Location added",
            "CEOs",
            "MDs",
            "By company name",
            "No LinkedIn profile",
            "Clear Filter"
        ]
        
        let listGroup =  realm.objects(CardGroup.self)
        for grp in listGroup {
            cars.append(grp.groupName)
        }
        
        cars.append("Create Group")
        let values = cars.map { TCPickerView.Value(title: $0) }
        picker.values = values
        picker.delegate = self
        picker.selection = .single
        //picker.itemsFont = UIFont.init(name: "CabourgOT-Regular", size: DesignUtility.getFontSize(fSize: 15))!
        picker.completion = { (selectedIndexes) in
            for i in selectedIndexes {
                print(values[i].title)
                
                self.applyFilter(i,value: values[i].title, count: cars.count)
                if(i != cars.count - 1) {
                    self.btnFilter.updateButtonUI(filterName: values[i].title)
                }
                
            }
        }
        picker.show()
    
    
     //   btnFilter.updateButtonUI()
        //self.showOptions()
        //   show(viewcontrollerInstance: CartPlaceholderViewController.loadVC())
    }
    
    
    func applyFilter(_ index : Int, value : String, count : Int) {
        
        switch index {
        case 0:
            cards = realm.objects(Card.self).sorted(byKeyPath: "name", ascending: true)
            break
        case 1:
            cards = realm.objects(Card.self).sorted(byKeyPath: "name", ascending: false)
            break
        case 2:
            cards = realm.objects(Card.self).sorted(byKeyPath: "cardId", ascending: false)
            
            break
        case 3:
            print("Will see")
            cards = realm.objects(Card.self).sorted(byKeyPath: "cardId", ascending: true)
//            cards = (realm.objects(Card.self))
            break
//        case 4:
//            //cards = (realm.objects(Card.self))
//            break
        case 4:
            cards = realm.objects(Card.self).filter(NSPredicate(format: "poition ==[c] 'CEO' OR poition ==[c] 'Chief Executive Officer'"))
            break
        case 5:
            cards = realm.objects(Card.self).filter(NSPredicate(format: "poition ==[c] 'MD' OR poition ==[c] 'Managing Director'"))
            break
        case 6:
            cards = realm.objects(Card.self).sorted(byKeyPath: "company", ascending: true)
            break
        case 7:
            cards = realm.objects(Card.self).filter(NSPredicate(format: "linkedIn = ''"))
            break
        case 8:
            cards = (realm.objects(Card.self))
            
            break
        case count - 1:
           self.createNewGroupPopUp()
            break
        default:
            print(value)
            cards = realm.objects(Card.self).filter(NSPredicate(format: "groupName = %@",value))
            print(cards)
            print("Clear")
        }
        cards = cards.filter(RealmFilter.otherCard)
        self.collectionView.reloadData()
        self.cardCollectionViewLayout?.unrevealRevealedCardAction()
        
        
    }
    
    @objc func cameraButtonPressed() {
        
        print("cartButtonPressed")
        self.showOptions()
        
        

        //   show(viewcontrollerInstance: CartPlaceholderViewController.loadVC())
    }
    @objc func cardButtonPressed() {
        let controller = MyCardController.loadVC()
        controller.controllerType = .view
        let rowCount = realm.objects(Card.self).filter(RealmFilter.myCard).count
    
        if (rowCount  <= 0) {
            
            Alert.showWithTwoActions(msg: "You dont have your card to view. Do you want to create a new card?", okBtnTitle: "Yes", okBtnAction: {
               // self.pushOrPopViewController(navigationController: self.navigationController!, animation: true, viewControllerClass: ChooseTemplateController.self, viewControllerStoryboad: (Storyboards.main.rawValue,nil))
                self.navigationController?.pushViewController(ChooseTemplateController.loadVC(), animated: true)
            }, cancelBtnTitle: "No", cancelBtnAction:  {
                
            })
            
        }
        else {
           controller.selectedCard = realm.objects(Card.self).filter(RealmFilter.myCard).first!
            self.navigationController?.pushViewController(controller, animated: true)
            //self.pushOrPopViewController(navigationController: self.navigationController!, animation: true, viewControllerClass: ChooseTemplateController.self, viewControllerStoryboad: (Storyboards.main.rawValue,nil))
        }
        
        //self.navigationController?.hero.navigationAnimationType = .none
        
        print("cartButtonPressed")
        
        //   show(viewcontrollerInstance: CartPlaceholderViewController.loadVC())
    }
    
    @objc func homeButtonPressed() {
        
        print("cartButtonPressed")
       // self.pushOrPopViewController(navigationController: self.navigationController!, animation: true, viewControllerClass: MenuSelectionController.self, viewControllerStoryboad: (Storyboards.main.rawValue,nil))
        
        self.navigationController?.pushViewController(MenuSelectionController.loadVC(), animated: true)
        
    }
    @objc func deleteButtonPressed() {
        
        let cardCount = realm.objects(Card.self).filter(RealmFilter.otherCard)
        if (cardCount.count <= 0) {
            Alert.showMsg(msg: "No card available to delete")
            return
        }
        let alert = FCAlertView.init()
        alert.showAlert(inView: self, withTitle: "Delete Card", withSubtitle: "Are you sure you want to delete card", withCustomImage: #imageLiteral(resourceName: "splashicon2"), withDoneButtonTitle: nil, andButtons: ["Yes","No"])
        alert.delegate = self
        alert.dismissOnOutsideTouch = true
        alert.colorScheme = UIColor.blue
        alert.hideDoneButton = true
        alert.blurBackground = true
//        alert.bounceAnimations = true
        alert.animateAlertInFromBottom = true
        alert.animateAlertOutToBottom = true
        alert.avoidCustomImageTint = true
        //        var index = 0
        //        if(self.cardCollectionViewLayout!.revealedIndex >= 0) {
        //            index = self.cardCollectionViewLayout!.revealedIndex
        //        }
        //        self.cardCollectionViewLayout?.flipRevealedCardBack(completion: {
        //            self.cardArray.remove(at: index)
        //            self.collectionView?.deleteItems(at: [IndexPath(item: index, section: 0)])
        //        })
    }
    func configureFields() {
        
        viewSearch.titleLabel.removeFromSuperview()
//        viewSearch.titleLabel.text = "Email:"
        viewSearch.textField.rightImage = #imageLiteral(resourceName: "iconsearch")
        viewSearch.textField.placeholder = "Search Card"
        viewSearch.textField.addTarget(self, action: #selector(PickCardController.textFieldDidChange(_:)), for: UIControlEvents.editingChanged)

        
    }
    @objc func textFieldDidChange(_ textField: UITextField) {
        
        print(textField.text)
        if(textField.text?.count == 0) {
            cards = (realm.objects(Card.self)).filter(RealmFilter.otherCard)
        }
        else {
            cards = (realm.objects(Card.self)).filter(NSPredicate(format: "name contains[c] %@",textField.text!)).filter(RealmFilter.otherCard)
           // cards = cards.filter(NSPredicate(format: "any name contains[c] %@",textField.text!)).filter(RealmFilter.otherCard)
            //cards = cards.filter(NSPredicate(format: "name contains[c] \(textField.text!)")).filter(RealmFilter.otherCard)
        }
        
        self.collectionView.reloadData()
    }
    func createLayoutOptions() {
        
        var layoutOptions = CardLayoutSetupOptions()
        cardLayoutOptions = layoutOptions
        
    }
    
    private func setupExample() {
        
        createLayoutOptions()
        
        if let cardCollectionViewLayout = self.collectionView?.collectionViewLayout as? HFCardCollectionViewLayout {
            self.cardCollectionViewLayout = cardCollectionViewLayout
        }
//        if(self.shouldSetupBackgroundView == true) {
//            self.setupBackgroundView()
//        }
        if let cardLayoutOptions = self.cardLayoutOptions {
            self.cardCollectionViewLayout?.firstMovableIndex = cardLayoutOptions.firstMovableIndex
            self.cardCollectionViewLayout?.cardHeadHeight = cardLayoutOptions.cardHeadHeight
            self.cardCollectionViewLayout?.cardShouldExpandHeadHeight = cardLayoutOptions.cardShouldExpandHeadHeight
            self.cardCollectionViewLayout?.cardShouldStretchAtScrollTop = cardLayoutOptions.cardShouldStretchAtScrollTop
            self.cardCollectionViewLayout?.cardMaximumHeight = cardLayoutOptions.cardMaximumHeight
            self.cardCollectionViewLayout?.bottomNumberOfStackedCards = cardLayoutOptions.bottomNumberOfStackedCards
            self.cardCollectionViewLayout?.bottomStackedCardsShouldScale = cardLayoutOptions.bottomStackedCardsShouldScale
            self.cardCollectionViewLayout?.bottomCardLookoutMargin = cardLayoutOptions.bottomCardLookoutMargin
            self.cardCollectionViewLayout?.spaceAtTopForBackgroundView = cardLayoutOptions.spaceAtTopForBackgroundView
            self.cardCollectionViewLayout?.spaceAtTopShouldSnap = cardLayoutOptions.spaceAtTopShouldSnap
            self.cardCollectionViewLayout?.spaceAtBottom = cardLayoutOptions.spaceAtBottom
            self.cardCollectionViewLayout?.scrollAreaTop = cardLayoutOptions.scrollAreaTop
            self.cardCollectionViewLayout?.scrollAreaBottom = cardLayoutOptions.scrollAreaBottom
            self.cardCollectionViewLayout?.scrollShouldSnapCardHead = cardLayoutOptions.scrollShouldSnapCardHead
            self.cardCollectionViewLayout?.scrollStopCardsAtTop = cardLayoutOptions.scrollStopCardsAtTop
            self.cardCollectionViewLayout?.bottomStackedCardsMinimumScale = cardLayoutOptions.bottomStackedCardsMinimumScale
            self.cardCollectionViewLayout?.bottomStackedCardsMaximumScale = cardLayoutOptions.bottomStackedCardsMaximumScale
            
            //let count = cardLayoutOptions.numberOfCards
            let count = self.cards.count
            
//            let newItem1 = CardInfo(color: self.getRandomColor(), icon: #imageLiteral(resourceName: "iconsearch"), imgCard : #imageLiteral(resourceName: "pickcard4"))
//            let newItem2 = CardInfo(color: self.getRandomColor(), icon: #imageLiteral(resourceName: "iconsearch"), imgCard : #imageLiteral(resourceName: "pickcard2"))
//            let newItem3 = CardInfo(color: self.getRandomColor(), icon: #imageLiteral(resourceName: "iconsearch"), imgCard : #imageLiteral(resourceName: "pickcard3"))
//            let newItem4 = CardInfo(color: self.getRandomColor(), icon: #imageLiteral(resourceName: "iconsearch"), imgCard : #imageLiteral(resourceName: "pickcard1"))
//
//            self.cardArray.insert(newItem1, at: 0)
//            self.cardArray.insert(newItem2, at: 1)
//            self.cardArray.insert(newItem3, at: 2)
//            self.cardArray.insert(newItem4, at: 3)
            
//            for index in 0..<count {
//                self.cardArray.insert(createCardInfo(), at: index)
//            }
        }
        
        Utility.delay(seconds: 0.5) {
            self.collectionView.isHidden = false
        }
        
    }
    
    private func createCardInfo() -> CardInfo {
        let icons: [UIImage] = [#imageLiteral(resourceName: "iconsearch"), #imageLiteral(resourceName: "iconsearch"), #imageLiteral(resourceName: "iconsearch"), #imageLiteral(resourceName: "iconsearch"), #imageLiteral(resourceName: "iconsearch"), #imageLiteral(resourceName: "iconsearch")]
        let icon = icons[Int(arc4random_uniform(6))]
        let newItem = CardInfo(color: self.getRandomColor(), icon: icon, imgCard : #imageLiteral(resourceName: "pickcard1"))
        return newItem
    }
    private func setupBackgroundView() {
        if(self.cardLayoutOptions?.spaceAtTopForBackgroundView == 0) {
            self.cardLayoutOptions?.spaceAtTopForBackgroundView = 44 // Height of the NavigationBar in the BackgroundView
        }
        if let collectionView = self.collectionView {
            collectionView.backgroundView = self.backgroundView
            self.backgroundNavigationBar?.shadowImage = UIImage()
            self.backgroundNavigationBar?.setBackgroundImage(UIImage(), for: .default)
        }
    }
    private func getRandomColor() -> UIColor{
        let randomRed:CGFloat = CGFloat(drand48())
        let randomGreen:CGFloat = CGFloat(drand48())
        let randomBlue:CGFloat = CGFloat(drand48())
        return UIColor(red: randomRed, green: randomGreen, blue: randomBlue, alpha: 1.0)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
 

}


extension PickCardController: HFCardCollectionViewLayoutDelegate,UICollectionViewDelegate, UICollectionViewDataSource {

    
    func cardCollectionViewLayout(_ collectionViewLayout: HFCardCollectionViewLayout, willRevealCardAtIndex index: Int) {
        if let cell = self.collectionView?.cellForItem(at: IndexPath(item: index, section: 0)) as? PickCardCell {
            cell.cardCollectionViewLayout = self.cardCollectionViewLayout
            print("willRevealCardAtIndex")
            //print(index)
            print(cell.imgCard.frame)
            //cell.cardIsRevealed(true)
            selectedCell = cell
          //  self.collectionView.reloadData()
        }
       /// collectionView.reloadData()
    }
    
    func cardCollectionViewLayout(_ collectionViewLayout: HFCardCollectionViewLayout, willUnrevealCardAtIndex index: Int) {
        if let cell = self.collectionView?.cellForItem(at: IndexPath(item: index, section: 0)) as? PickCardCell {
            cell.cardCollectionViewLayout = self.cardCollectionViewLayout
            print("willUnrevealCardAtIndex")
            //print(index)
            print(cell.imgCard.frame)
           // cell.cardIsRevealed(false)
       //     self.collectionView.reloadData()
        }
       /// collectionView.reloadData()
    }
    
     func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(collectionView.contentSize)
        return self.cards.count
        //return self.cardArray.count
    }

    
     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardCell", for: indexPath) as! PickCardCell
       
//        cell.configCell(card: self.cardArray[indexPath.item])
        cell.configCell(card: self.cards[indexPath.row])
        print(cell.frame)
        // cell.backgroundColor = self.cardArray[indexPath.item].color
        //cell.imageIcon?.image = self.cardArray[indexPath.item].icon
        return cell
    }
    
     func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.cardCollectionViewLayout?.revealCardAt(index: indexPath.item)
    }
    
     func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let tempItem = self.cardArray[sourceIndexPath.item]
        self.cardArray.remove(at: sourceIndexPath.item)
        self.cardArray.insert(tempItem, at: destinationIndexPath.item)
    }
    
    
    

    
}
class CustomButton1: UIButton {
    
    let style = NSMutableParagraphStyle()
    //let
    var title = ""
    
    required init(title: String, subtitle: String) {
        super.init(frame: CGRect.zero)
        
        style.alignment = NSTextAlignment.center
        style.lineBreakMode = NSLineBreakMode.byWordWrapping
//        let titleAttributes: [NSAttributedStringKey : Any] = [
//           // NSAttributedStringKey.underlineStyle : NSUnderlineStyle.styleSingle.rawValue,
//            NSAttributedStringKey.font : UIFont.init(name: "CabourgOT-Bold", size: DesignUtility.getFontSize(fSize: 17))!,
//            NSAttributedStringKey.foregroundColor : UIColor.init(hexString:"#7b89a1"),
//            NSAttributedStringKey.paragraphStyle : style
//        ]
//        let subtitleAttributes = [
//            NSAttributedStringKey.font : UIFont.init(name: "CabourgOT-Bold", size: DesignUtility.getFontSize(fSize: 10))!,
//            NSAttributedStringKey.foregroundColor : UIColor.init(hexString:"#7b89a1"),
//            NSAttributedStringKey.paragraphStyle : style
//        ]
        
        self.title = title
      //  let titleAttributes = self.titleAttribute()
        let attributedString = NSMutableAttributedString(string: self.title, attributes: self.titleAttribute())
        //attributedString.append(NSAttributedString(string: "\n"))
        //attributedString.append(NSAttributedString(string: subtitle, attributes: subtitleAttributes))
        
        setAttributedTitle(attributedString, for: UIControlState.normal)
        titleLabel?.numberOfLines = 1
        titleLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
        
        self.setImage(#imageLiteral(resourceName: "droparrow"), for: .normal)
        self.imageEdgeInsets.right = -15
        self.semanticContentAttribute = .forceRightToLeft
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func titleAttribute() ->  [NSAttributedStringKey : Any]!{
        
        let titleAttributes: [NSAttributedStringKey : Any] = [
            // NSAttributedStringKey.underlineStyle : NSUnderlineStyle.styleSingle.rawValue,
            NSAttributedStringKey.font : UIFont.init(name: "CabourgOT-Bold", size: DesignUtility.getFontSize(fSize: 17))!,
            NSAttributedStringKey.foregroundColor : UIColor.init(hexString:"#7b89a1"),
            NSAttributedStringKey.paragraphStyle : style
        ]
        
        return titleAttributes
    }
    func subTitleAttribute()  ->  [NSAttributedStringKey : Any]! {
        
        let subtitleAttributes = [
            NSAttributedStringKey.font : UIFont.init(name: "CabourgOT-Bold", size: DesignUtility.getFontSize(fSize: 10))!,
            NSAttributedStringKey.foregroundColor : UIColor.init(hexString:"#7b89a1"),
            NSAttributedStringKey.paragraphStyle : style
        ]
        return subtitleAttributes
    }
    func emptyAttribute() {
        
        let attr = NSMutableAttributedString(attributedString: (self.titleLabel?.attributedText)!)
        let originalRange = NSMakeRange(0, attr.length)
        attr.setAttributes([:], range: originalRange)
        self.titleLabel?.attributedText = attr
        setAttributedTitle(NSMutableAttributedString(string: "", attributes: [:]), for: UIControlState.normal)
        
    }
    
    
    func updateButtonUI(filterName : String) {
        
        if(filterName == "Clear Filter") {
            self.titleLabel?.numberOfLines = 1
            self.emptyAttribute()
            let attributedString = NSMutableAttributedString(string: self.title, attributes: self.titleAttribute())
            setAttributedTitle(attributedString, for: UIControlState.normal)
            //attributedString.append(NSAttributedString(string: "\n"))
            //attributedString.append(NSAttributedString(string: subtitle, attributes: subtitleAttributes))
            
        }
        else {
            self.titleLabel?.numberOfLines = 2
            self.emptyAttribute()
            let attributedString = NSMutableAttributedString(string: self.title, attributes: self.titleAttribute())
            attributedString.append(NSAttributedString(string: "\n"))
            attributedString.append(NSAttributedString(string: filterName, attributes: self.subTitleAttribute()))
            setAttributedTitle(attributedString, for: UIControlState.normal)
        }
        
        
    }
}

extension PickCardController: TCPickerViewOutput {

    
    func pickerView(_ pickerView: TCPickerViewInput, didSelectRowAtIndex index: Int) {
    
    }
}

extension PickCardController: FCAlertViewDelegate {
    
    
    func fcAlertView(_ alertView: FCAlertView!, clickedButtonIndex index: Int, buttonTitle title: String!) {
        
        
        if(alertView.tag == 100) {
            print(index)
            if (index == 0) {
                if (newGroupText.isEmptyStr()){
                    Alert.showMsg(msg: "Kindly provide group name")
                }
                else {
                    print(self.newGroupText)
                    self.createNewGroup()
                    
                }
            }
            
            
            return
        }
        
        if(alertView.tag == 200) {
            print(index)
            if (index == 0) {
//                if (newGroupText.isEmptyStr()){
//                    Alert.showMsg(msg: "Kindly provide group name")
//                }
//                else {
//                    print(self.newGroupText)
//                    self.createNewGroup()
//
//                }
            }
            
            
            return
        }
        
        if (index == 0) {
            
                    var index = selectedLongPressindex
//                    if(self.cardCollectionViewLayout!.revealedIndex >= 0) {
//                        index = self.cardCollectionViewLayout!.revealedIndex
//                    }
                    self.cardCollectionViewLayout?.flipRevealedCardBack(completion: {
                        
                        print(self.cards.count)
                        RealmService.shared.delete(self.cards[index])
//                        self.cardArray.remove(at: index)
                        print(self.cards.count)
//                        self.selectedCell?.cardIsRevealed(false)
                        
                        self.collectionView?.deleteItems(at: [IndexPath(item: index, section: 0)])
                        //self.cards = self.realm.objects(Card.self).filter(RealmFilter.otherCard)
                        //self.collectionView.reloadData()
                        self.cardCollectionViewLayout?.unrevealCard(completion: {
                            if(self.cards.count == 1) {
                                self.cardCollectionViewLayout?.revealCardAt(index: 0)
                            }
                        })
                    })
            
        }
        else {
            
        }
        
        
        

        
        //alertView.autoHideSeconds = 2
       // alertView.dismiss()
    }
}




extension PickCardController: UIGestureRecognizerDelegate {
    
//    if (gestureRecognizer.state != UIGestureRecognizerState.Ended){
//    return
//    }
//
//    let p = gestureRecognizer.locationInView(self.collectionView)
//
//    if let indexPath : NSIndexPath = (self.collectionView?.indexPathForItemAtPoint(p))!{
//        //do whatever you need to do
//    }

    
}

