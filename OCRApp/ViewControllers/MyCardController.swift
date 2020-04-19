//
//  MyCardController.swift
//  OCRApp
//


import UIKit
import RealmSwift
import MultipeerConnectivity
class MyCardController: BaseViewController,StoryBoardHandler {

    @IBOutlet weak var testImage: UIImageView!
    @IBOutlet weak var cardView: CardsView!
    static var myStoryBoard: (forIphone: String, forIpad: String?) = (Storyboards.main.rawValue , nil)
    
    var cards:Results<Card>!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var lblName: BaseUILabel!
    @IBOutlet weak var lblCardCounterTitle: BaseUILabel!
    @IBOutlet weak var lblCardCounter: BaseUILabel!
    @IBOutlet weak var btnDone: CustomButton!
    @IBOutlet weak var viewLinkedInField: CustomTextFieldView!
    var controllerType : MyCardType!
    var selectedCard : Card!
    
    
    
    
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
    
       // let lastView : UIView! = scrollView.subviews.last
        let height = lblCardCounter.frame.size.height
        let pos = lblCardCounter.frame.origin.y
        let sizeOfContent = height + pos + 10
        scrollView.contentSize.height = sizeOfContent
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //return
        configureFields()
        setupHeader()
        lblName.text = selectedCard.name
        testImage.image = Utility.loadImageFromPath(selectedCard.QRImagePath)
        
        let lpgr : UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action:#selector(PickCardController.handleLongPress(gestureRecognizer:)))
        lpgr.minimumPressDuration = 0.7
        lpgr.delegate = self
        lpgr.delaysTouchesBegan = true
        self.cardView?.addGestureRecognizer(lpgr)
        
        
    }
    @objc func handleLongPress(gestureRecognizer : UILongPressGestureRecognizer){
        
//        if (gestureRecognizer.state != UIGestureRecognizerState.ended){
//            return
//        }
        if (gestureRecognizer.state != UIGestureRecognizerState.began){
        
            let p = gestureRecognizer.location(in: self.cardView)
            
            self.showCardOptions()
        }
        
        
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
        self.present(actionSheetController, animated: true) {
        }
    }
    func editCard() {
        
        let  controller = ChooseTemplateController.loadVC()
        controller.isEditCard = true
        controller.editCard = selectedCard
        self.navigationController?.pushViewController(controller, animated: true)
        
        /*
        let  controller = CreateCardController.loadVC()
        controller.isEditCard = true
        controller.editCard = selectedCard
        self.navigationController?.pushViewController(controller, animated: true)
 */
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.navigationController?.isNavigationBarHidden = false
        if(controllerType == .view) {
            self.navigationItem.title = "My Card"
        }
        else if (controllerType == .create) {
            self.navigationItem.title = "John Doe"
        }
        
        if (selectedCard.isMyCard == true) {
            
        }
        else {
            
        }
        
        var selectedRow:Int? = nil
        if let row = selectedCard.templateCardId.toInt() {
            selectedRow =  row - 1
        }
        cardView.setCardData(data: selectedCard, row: selectedRow)
        if let data = selectedCard {
            viewLinkedInField.textField.text = data.linkedIn
        }
    }
    func configureFields() {
        
        viewLinkedInField.titleLabel.text = "LinkedIn Profile"
        viewLinkedInField.textField.rightImage = nil
        viewLinkedInField.textField.placeholder = "www.linkedin.com"
        viewLinkedInField.textField.isUserInteractionEnabled = false
        cards = realm.objects(Card.self).filter(RealmFilter.otherCard)
        
        
        if(controllerType == .view) {
            btnDone.isHidden = true
            lblName.text = "John Doe"
            print(cards.count)
            lblCardCounter.text = String(cards.count)
        }
        else if (controllerType == .create) {
            lblCardCounterTitle.isHidden = true
            lblCardCounter.isHidden = true
            lblName.text = "Digital Card"
            print(cards.count)
            lblCardCounter.text = String(cards.count)
        }
    }
    func setupHeader() {
        //   self.navigationController?.isNavigationBarHidden = false
        
        
      //  self.addBarButtonItemWithImage(#imageLiteral(resourceName: "menutopicon"),CustomNavBarEnum.CustomBarButtonItemPosition.BarButtonItemPositionRight, self, #selector(showPendingCardList))
        self.addBarButtonItemWithImage(#imageLiteral(resourceName: "pendingcardtop"),CustomNavBarEnum.CustomBarButtonItemPosition.BarButtonItemPositionRight, self, #selector(showPendingCardList))
        
        if(controllerType == .view) {
            self.addBarButtonItemWithImage(#imageLiteral(resourceName: "btnbackarrow"),CustomNavBarEnum.CustomBarButtonItemPosition.BarButtonItemPositionLeft, self, #selector(goBack))
            
            self.addBarButtonItemWithImage(#imageLiteral(resourceName: "topiconnewapp"),CustomNavBarEnum.CustomBarButtonItemPosition.BarButtonItemPositionRight, self, #selector(homeButtonPressed))
            
        }
        else if (controllerType == .create) {
            self.addBarButtonItemWithImage(#imageLiteral(resourceName: "topnavcamera"),CustomNavBarEnum.CustomBarButtonItemPosition.BarButtonItemPositionLeft, self, #selector(cameraButtonPressed))
            
            self.addBarButtonItemWithImage(#imageLiteral(resourceName: "iconcardtop"),CustomNavBarEnum.CustomBarButtonItemPosition.BarButtonItemPositionRight, self, #selector(cardButtonPressed))
        }
       
        //let imgView = UIImageView.init(image: UIImage.init(named: "logo-small-home"))
        //imgView.contentMode = .center
        //self.addCustomTitleView(imgView)
    }
    
    @objc func showPendingCardList() {
        
        print("cartButtonPressed")
        // self.pushOrPopViewController(navigationController: self.navigationController!, animation: true, viewControllerClass: MenuSelectionController.self, viewControllerStoryboad: (Storyboards.main.rawValue,nil))
        
        self.navigationController?.pushViewController(PendingCardListController.loadVC(), animated: true)
        
    }
    @objc func homeButtonPressed() {
        
        print("cartButtonPressed")
        // self.pushOrPopViewController(navigationController: self.navigationController!, animation: true, viewControllerClass: MenuSelectionController.self, viewControllerStoryboad: (Storyboards.main.rawValue,nil))
        
        self.navigationController?.pushViewController(MenuSelectionController.loadVC(), animated: true)
        
    }
    @objc func cameraButtonPressed() {
        
        print("cartButtonPressed")
        self.showOptions()
        //   show(viewcontrollerInstance: CartPlaceholderViewController.loadVC())
    }
    @objc func cardButtonPressed() {
       // goBack()
        print("cartButtonPressed")
       // self.pushOrPopViewController(navigationController: self.navigationController!, animation: true, viewControllerClass: PickCardController.self, viewControllerStoryboad: (Storyboards.main.rawValue,nil))
        self.navigationController?.pushViewController(PickCardController.loadVC(), animated: true)
    }
    
    
    @IBAction func saveCard(_ sender: CustomButton) {
        
       // self.pushOrPopViewController(navigationController: self.navigationController!, animation: true, viewControllerClass: PickCardController.self, viewControllerStoryboad: (Storyboards.main.rawValue,nil))
        
        self.navigationController?.pushViewController(PickCardController.loadVC(), animated: true)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func goBack() {
       // self.pushOrPopViewController(navigationController: self.navigationController!, animation: true, viewControllerClass: PickCardController.self, viewControllerStoryboad: (Storyboards.main.rawValue,nil))
        
        self.navigationController?.pushViewController(PickCardController.loadVC(), animated: true)
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func share(_ sender: Any) {
        self.sendMessage()
        
    }
    @IBAction func receiveCard(_ sender: UIButton) {
        self.recieveCardData()
    }
    @IBAction func sendCard(_ sender: UIButton) {
        self.initializePeerConnection()
        self.sendCardData()
    }
    
    

}

extension MyCardController: UIGestureRecognizerDelegate {
    
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



