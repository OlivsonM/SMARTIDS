//
//  ChooseTemplateController.swift
//  OCRApp
//

import UIKit

class ChooseTemplateController: BaseViewController,StoryBoardHandler {

    static var myStoryBoard: (forIphone: String, forIpad: String?) = (Storyboards.main.rawValue , nil)
    var isEditCard  = false
    var editCard : Card?
    @IBOutlet weak var viewCollection: CardCollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()

        viewCollection.delegateCards = self
        setupHeader()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationItem.title = "Template Card"
        //self.navigationController?.isNavigationBarHidden = false
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
    }
    
    func setupHeader() {
       // self.navigationController?.isNavigationBarHidden = false
        
        
        self.addBarButtonItemWithImage(#imageLiteral(resourceName: "topnavcamera"),CustomNavBarEnum.CustomBarButtonItemPosition.BarButtonItemPositionLeft, self, #selector(cameraButtonPressed))
        
        self.addBarButtonItemWithImage(#imageLiteral(resourceName: "btnnavhome"),CustomNavBarEnum.CustomBarButtonItemPosition.BarButtonItemPositionRight, self, #selector(homeButtonPressed))
        //let imgView = UIImageView.init(image: UIImage.init(named: "logo-small-home"))
        //imgView.contentMode = .center
        //self.addCustomTitleView(imgView)
    }
    @objc func cameraButtonPressed() {
        
        print("cartButtonPressed")
       // self.showOptions()
        Singleton.sharedInstance.isCardScan = false
      //  self.pushOrPopViewController(navigationController: self.navigationController!, animation: true, viewControllerClass: MenuSelectionController.self, viewControllerStoryboad: (Storyboards.main.rawValue,nil))
        self.navigationController?.pushViewController(MenuSelectionController.loadVC(), animated: true)
    }
    @objc func homeButtonPressed() {
        
        print("cartButtonPressed")
        Singleton.sharedInstance.isCardScan = false
       // self.pushOrPopViewController(navigationController: self.navigationController!, animation: true, viewControllerClass: PickCardController.self, viewControllerStoryboad: (Storyboards.main.rawValue,nil))
        self.navigationController?.pushViewController(PickCardController.loadVC(), animated: true)
       
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let controller = segue.destination as? CreateCardController
        if let sender = (sender as? Int) {
            controller?.selectedCardId = sender  + 1
            
        }
        
        if (isEditCard == true) {
            controller?.isEditCard = true
            controller?.editCard = editCard
        }
//        if segue.identifier == "mySegue" ,
//            let nextScene = segue.destination as? VehicleDetailsTableViewController ,
//            let indexPath = self.tableView.indexPathForSelectedRow {
//            let selectedVehicle = vehicles[indexPath.row]
//            nextScene.currentVehicle = selectedVehicle
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

extension ChooseTemplateController : CardViewProtocol {
    
    func didSelectItemAtIndex(index: Int) {
        print("INDEX \(index)")
        self.performSegue(withIdentifier: "createCard", sender: index)
    }
}
