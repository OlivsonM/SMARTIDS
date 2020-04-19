//
//  SplashViewController.swift
//  LaundryApp
//


import UIKit
import Shimmer
import Hero
class SplashViewController: BaseViewController, StoryBoardHandler {
    static var myStoryBoard: (forIphone: String, forIpad: String?) = (Storyboards.main.rawValue , nil)
    
    @IBOutlet weak var imgNewSplashIcon: UIImageView!
    @IBOutlet weak var imgSlogan: UIImageView!
    @IBOutlet weak var imgTextLogo: UIImageView!
    @IBOutlet weak var viewSplashContainer: FBShimmeringView!
    @IBOutlet weak var imgLogo: UIImageView!
    
    @IBOutlet weak var textLogo: UIImageView!
    
    @IBOutlet weak var iconLogoYconstraint: NSLayoutConstraint!
    
    @IBOutlet weak var overViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var textLogoWidthConstraint: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        //imgLogo.alpha = 0.0
        //imgTextLogo.alpha = 0.0
        //imgSlogan.alpha = 0.0
     self.navigationController?.isNavigationBarHidden = true
        //imgLogo.alpha = 0.0
      //  textLogo.isHidden = true
        self.navigationController?.hero.navigationAnimationType = .zoom
      }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        viewSplashContainer.isShimmering = true
        
//        print(viewSplashContainer.contentView)
//        viewSplashContainer.shimmeringSpeed = 120
        
        
//        viewSplashContainer.shimmeringBeginFadeDuration = 0.3;
//        viewSplashContainer.shimmeringOpacity = 0.3;
        
        //showAnimateImage1()
        //showAnimationImg2()
        self.viewSplashContainer.contentView = self.imgNewSplashIcon
        //            self.viewSplashContainer.contentView = self.imgTextLogo
        Utility.delay(seconds: 1.1, closure: {
            self.checkLogin()
        })
        
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
//            self.checkLogin()
//        }
        /*
        self.rotate(view: self.iconLogo)
        popInView(view: iconLogo)
        self.textLogo.isHidden = false
        UIView.animate(withDuration: 2, delay: 0.7, options: .curveLinear, animations: {
            self.overViewLeadingConstraint.constant = self.view.frame.width
            self.view.layoutIfNeeded()
        }) { (v) in
           DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.checkLogin()
            }
        }
        */
     
    }
    func showAnimateImage1()
    {
        
        self.imgLogo.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        UIView.animate(withDuration: 1.5, animations: {
            
            self.imgLogo.alpha = 1
            self.imgLogo.transform = CGAffineTransform(scaleX: 1, y: 1)
            
        })
        { (success) in
            
            UIView.animate(withDuration: 0.5, animations: {
                
                self.imgLogo.frame.origin.x = self.imgTextLogo.frame.size.width 
                //self.viewSplashContainer.frame.size.width - #imageLiteral(resourceName: "splashicon2").size.width
                
            }, completion: { (success) in
                
               // self.imgTextLogo.frame.origin = CGPoint(x: self.imgLogo.frame.maxX, y: self.imgLogo.frame.minY)
                self.showAnimationImg2()
                
            })
            
            
        }
    }
    func showAnimationImg2() {
        
        UIView.animate(withDuration: 1, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
            self.imgTextLogo.alpha = 1.0
            self.imgSlogan.alpha = 1.0
        }) { (success) in
           // self.showAnimationImg3()
            
            self.imgLogo.image = #imageLiteral(resourceName: "splashiconnew")
//            self.imgLogo.image = #imageLiteral(resourceName: "splashicon")
             self.viewSplashContainer.contentView = self.imgLogo
//            self.viewSplashContainer.contentView = self.imgTextLogo
            Utility.delay(seconds: 1.1, closure: {
                self.checkLogin()
            })
        }
    }
    func checkUserLoggedIn(){
        self.navigationController?.pushViewController(MenuSelectionController.loadVC(), animated: true)
        
        //self.pushOrPopViewController(navigationController: self.navigationController!, animation: true, viewControllerClass: MenuSelectionController.self, viewControllerStoryboad: (Storyboards.main.rawValue,nil))
    }
    func checkLogin(){
        
//        let userDefault = UserDefaults.standard
//        if userDefault.bool(forKey: Login.isLoggedIn) == true {
//            if let data = UserDefaults.standard.value(forKey: Login.userData) as? Data {
//                CurrentUser.data = try? PropertyListDecoder().decode(User.self, from: data)
//            }
//            CurrentUser.token = UserDefaults.standard.value(forKey: Login.token) as! String
//           self.navigationController?.setViewControllers([HomeViewController.loadVC()], animated: true)
//        }else{
//       self.navigationController?.setViewControllers([WalkThroughViewController.loadVC()], animated: true)
//        }
      
        
        let realm = RealmService.shared.realm
        //        let predicate = NSPredicate(format: "isMyCard = true")
        let cards = realm.objects(Card.self).filter(RealmFilter.myCard)
        print(cards.count)
        if(cards.count > 0) {
            //self.pushOrPopViewController(navigationController: self.navigationController!, animation: true, viewControllerClass: PickCardController.self, viewControllerStoryboad: (Storyboards.main.rawValue,nil))
            self.navigationController?.pushViewController(PickCardController.loadVC(), animated: true)
        }
        else {
            //self.pushOrPopViewController(navigationController: self.navigationController!, animation: true, viewControllerClass: MenuSelectionController.self, viewControllerStoryboad: (Storyboards.main.rawValue,nil))
            self.navigationController?.pushViewController(MenuSelectionController.loadVC(), animated: true)
        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func rotate(view : UIImageView) {
        let animation = CABasicAnimation(keyPath: "transform.rotation.z")
        animation.fromValue = 0
        animation.toValue = 2 * Double.pi
        animation.duration = 1 * 2
        animation.repeatCount = Float.infinity
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        view.layer.add(animation, forKey: animation.keyPath)
    }
 
    func popInView(view: UIView)  {
        
        view.isHidden = false
        view.alpha = 0.0
        
        
        
        view.transform = CGAffineTransform(scaleX: 0.001, y: 0.001);
        UIView.animate(withDuration: 0.5, delay: 0.5, options: .curveLinear, animations: {
            view.alpha = 1
            view.transform = CGAffineTransform(scaleX: 1.2, y: 1.2);
            
           
            
            
        }) { (finished) in
            
            UIView.animate(withDuration: 0.3, delay: 0.1, options: .curveLinear, animations: {
                
                view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0);
              
            }) { (finished) in
                
            }
            
        }
    }
    
}
