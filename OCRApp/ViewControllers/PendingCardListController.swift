//
//  PendingCardListController.swift
//  OCRApp
//


import UIKit
import RealmSwift
class PendingCardListController: BaseViewController,StoryBoardHandler {

    
    static var myStoryBoard: (forIphone: String, forIpad: String?) = (Storyboards.main.rawValue , nil)
   @IBOutlet weak var collectionView: UICollectionView!
     var cards:Results<CardPending>!
    var notificationToken : NotificationToken?
    
    var selectedLongPressindex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupHeader()
        loadCards()
        registeredNibs()
        setupGesture()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.title = "Pending Cards"
        
    }
    func registeredNibs()
    {
        collectionView.register(UINib(nibName: "AdsListingCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "AdsListingCollectionViewCell")
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        notificationToken?.invalidate()
        RealmService.shared.stopObservingErrors(in: self)
    }
    func setupHeader() {
    
        self.addBarButtonItemWithImage(#imageLiteral(resourceName: "btnbackarrow"),CustomNavBarEnum.CustomBarButtonItemPosition.BarButtonItemPositionLeft, self, #selector(goBack))
    
    }
    
    func setupGesture() {
        
        let lpgr : UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action:#selector(PendingCardListController.handleLongPress(gestureRecognizer:)))
        lpgr.minimumPressDuration = 0.7
       // lpgr.delegate = self
        lpgr.delaysTouchesBegan = true
        self.collectionView?.addGestureRecognizer(lpgr)
    }
    
    @objc func handleLongPress(gestureRecognizer : UILongPressGestureRecognizer){
        
        if (gestureRecognizer.state != UIGestureRecognizerState.began){
            let p = gestureRecognizer.location(in: self.collectionView)
            
            if let inex : NSIndexPath = (self.collectionView?.indexPathForItem(at: p))! as NSIndexPath{
                print(inex.row)
                
                let data = cards[inex.row]
                if (data.cardStatus != PendingCardStatus.failed.rawValue) {
                    return
                }
                self.selectedLongPressindex = inex.row
                self.showCardOptions()
            }
        }
        
        
    }
    
    func showCardOptions() {
        let actionSheetController = UIAlertController(title:"Please Select", message:"", preferredStyle: .actionSheet)
        let cancelActionButton = UIAlertAction(title: "Cancel",  style: .cancel) { action -> Void in
        }
        actionSheetController.addAction(cancelActionButton)
        let saveActionButton = UIAlertAction(title: "Create/Edit Card", style: .default) { action -> Void in
            //  self.openCamera()
           self.editCard()
            
        }
        actionSheetController.addAction(saveActionButton)
        let deleteActionButton = UIAlertAction(title: "Delete Image", style: .default) { action -> Void in
           // self.deleteLongPressButtonPressed()
            self.deleteLongPressButtonPressed()
        }
        actionSheetController.addAction(deleteActionButton)
        
        self.present(actionSheetController, animated: true) {
        }
    }
    
    func deleteLongPressButtonPressed(){
        let data = cards[self.selectedLongPressindex]
        RealmService.shared.delete(data)
    }
    func editCard() {
        
        let  controller = ChooseTemplateController.loadVC()
        controller.isEditCard = true
        controller.editCard = self.cards[selectedLongPressindex].card!
        self.navigationController?.pushViewController(controller, animated: true)
        
    }
    override func goBack() {
        // self.pushOrPopViewController(navigationController: self.navigationController!, animation: true, viewControllerClass: PickCardController.self, viewControllerStoryboad: (Storyboards.main.rawValue,nil))
        self.navigationController?.popViewController(animated: true)
//        self.navigationController?.pushViewController(MyCardControlxler.loadVC(), animated: true)
        
    }
    
    func loadCards() {
        
            cards = realm.objects(CardPending.self)
        if(cards.count == 0) {
            Alert.showMsg(msg: "No cards are currently in the queue")
        }
        
        notificationToken = realm.observe { (notification, realm) in
            print(notification)
            print(realm)
            self.collectionView.reloadData()
        }
        RealmService.shared.observeRealmErrors(in: self) { (error) in
            //handle error
            print(error ?? "no error detected")
        }
        
        collectionView.reloadData()
//            if (cardCount.count > 0) {
//                let data = cardCount[0]
//                client?.delegate = self
//
//                let params = ProcessingParams.init()
//                print(Utility.loadImageFromPath(data.pendingImagePath)!)
//
//        }
        
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

extension PendingCardListController: UICollectionViewDelegate
{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
       // router.goToAdsDetail(from: self)
    }
}

extension PendingCardListController: UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return cards.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AdsListingCollectionViewCell", for: indexPath) as! AdsListingCollectionViewCell
        cell.setCardData(card: cards[indexPath.row])
        return cell
    }
}
extension PendingCardListController : UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        var size: CGSize!
        
        size = CGSize(width: (collectionView.bounds.width * 0.45), height: collectionView.bounds.height * 0.28)
        
        return size
    }
}
