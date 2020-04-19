//
//  SwiftPages.swift
//  SwiftPages
//


import UIKit

// protocol delegate
protocol SwiftPagesDelegate : class {
    func SwiftPagesCurrentPageNumber(currentIndex: Int)
    func didEndDeceleratingPageNumber(currentIndex: Int)
}


// MARK: - SwiftPages

public class SwiftPages: UIView {
    // current page index and delegate
    var currentIndex: Int = 0
    weak var delegate : SwiftPagesDelegate?
    
  //  private var token: dispatch_once_t = 0
    
    // Items variables
    private var containerView: UIView!
    private var scrollView: UIScrollView!
    private var topBar: UIView!
    private var spacerView: UIView!
    private var animatedBar: UIView!
    private var viewControllerIDs = [String]()
    public var viewControllersArray = [UIViewController]()
    private var buttonTitles = [String]()
    private var buttonImages = [UIImage]()
    private var pageViews = [UIViewController?]()
    private var currentPage: Int = 0
    private var storyBoardName: String!
    private var storyBoard: UIStoryboard?
    private var pageCount: Int {
        return viewControllerIDs.count != 0 ? viewControllerIDs.count : viewControllersArray.count
    }
    
    // Container view position variables
    private var xOrigin: CGFloat = 0
    private var yOrigin: CGFloat = 64
    private var distanceToBottom: CGFloat = 0
    
    // Color variables
    private var animatedBarColor = UIColor(red: 28/255, green: 95/255, blue: 185/255, alpha: 1)
    private var topBarBackground = UIColor.white
    private var buttonsTextColor = UIColor.gray
    private var containerViewBackground = UIColor.white
    
    // Item size variables
    private var topBarHeight: CGFloat = 52
    private var animatedBarHeight: CGFloat = 3
    
    // Bar item variables
    private var topbarIsEnabled = true
    private var aeroEffectInTopBar = false //This gives the top bap a blurred effect, also overlayes the it over the VC's
    private var buttonsWithImages = false
    private var barShadow = true
    private var shadowView : UIView!
    private var shadowViewGradient = CAGradientLayer()
    private var buttonsTextFontAndSize = UIFont.init(name: "Poppins-Regular", size: DesignUtility.getFontSize(fSize: 16))!
       // UIFont(name: "HelveticaNeue", size: DesignUtility.getFontSize(fSize: 20))!
    private var blurView : UIVisualEffectView!
    private var barButtons = [UIButton?]()
    
    /// Custom colors
    let selectedColor = UIColor(red: 132/255, green: 7/255, blue: 25/255, alpha: 1)
    let unSelectedColor = UIColor(red: 182/255, green: 14/255, blue: 37/255, alpha: 1.0)
    
    // MARK: - Positions Of The Container View API -
    public func setOriginX (origin : CGFloat) { xOrigin = origin }
    public func setOriginY (origin : CGFloat) { yOrigin = origin }
    public func setDistanceToBottom (distance : CGFloat) { distanceToBottom = distance }
    
    // MARK: - API's -
    public func setAnimatedBarColor (color : UIColor) { animatedBarColor = color }
    public func setTopBarBackground (color : UIColor) { topBarBackground = color }
    public func setButtonsTextColor (color : UIColor) { buttonsTextColor = color }
    public func setContainerViewBackground (color : UIColor) { containerViewBackground = color }
    public func setTopBarHeight (pointSize : CGFloat) { topBarHeight = pointSize}
    public func setAnimatedBarHeight (pointSize : CGFloat) { animatedBarHeight = pointSize}
    public func setButtonsTextFontAndSize (fontAndSize : UIFont) { buttonsTextFontAndSize = fontAndSize}
    public func enableAeroEffectInTopBar (boolValue : Bool) { aeroEffectInTopBar = boolValue}
    public func enableButtonsWithImages (boolValue : Bool) { buttonsWithImages = boolValue}
    public func enableBarShadow (boolValue : Bool) { barShadow = boolValue}
    
    public func disableTopBar () { topbarIsEnabled = false }
    
    override public func draw(_ rect: CGRect) {
        
       //--ww dispatch_once(&token) {
         //--ww    DispatchQueue.once {
            let pagesContainerHeight = self.frame.height - self.yOrigin - self.distanceToBottom
            let pagesContainerWidth = self.frame.width
            
            let pageCount = self.pageCount
            
            // Set the notifications for an orientation change & BG mode
                let defaultNotificationCenter = NotificationCenter.default
                defaultNotificationCenter.addObserver(self, selector: #selector(SwiftPages.applicationWillEnterBackground), name: NSNotification.Name.UIApplicationWillResignActive, object: nil)
                defaultNotificationCenter.addObserver(self, selector: #selector(SwiftPages.orientationWillChange), name: NSNotification.Name.UIApplicationWillChangeStatusBarOrientation, object: nil)
                defaultNotificationCenter.addObserver(self, selector: #selector(SwiftPages.orientationDidChange), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
            
            // Set the containerView, every item is constructed relative to this view
            self.containerView = UIView(frame: CGRect(x: self.xOrigin, y: self.yOrigin, width: pagesContainerWidth, height: pagesContainerHeight))
            self.containerView.backgroundColor = self.containerViewBackground
            self.containerView.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(self.containerView)
            
            //Add the constraints to the containerView.
            if #available(iOS 9.0, *) {
                let horizontalConstraint = self.containerView.centerXAnchor.constraint(equalTo: self.centerXAnchor)
                let verticalConstraint = self.containerView.centerYAnchor.constraint(equalTo: self.centerYAnchor)
                let widthConstraint = self.containerView.widthAnchor.constraint(equalTo: self.widthAnchor)
                let heightConstraint = self.containerView.heightAnchor.constraint(equalTo: self.heightAnchor)
                NSLayoutConstraint.activate([horizontalConstraint, verticalConstraint, widthConstraint, heightConstraint])
            }
            
            
            // Set the scrollview
            if self.aeroEffectInTopBar {
                self.scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: self.containerView.frame.size.width, height: self.containerView.frame.size.height))
            } else {
                self.scrollView = UIScrollView(frame: CGRect(x: 0, y: self.topBarHeight, width: self.containerView.frame.size.width, height: self.containerView.frame.size.height - self.topBarHeight))
            }
                self.scrollView.isPagingEnabled = true
            self.scrollView.showsHorizontalScrollIndicator = false
            self.scrollView.showsVerticalScrollIndicator = false
            self.scrollView.delegate = self
                self.scrollView.backgroundColor = UIColor.clear
            self.scrollView.contentOffset = CGPoint(x: 0, y: 0)
            self.scrollView.translatesAutoresizingMaskIntoConstraints = false
            self.containerView.addSubview(self.scrollView)
            
            // Add the constraints to the scrollview.
            if #available(iOS 9.0, *) {
                let leadingConstraint = self.scrollView.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor)
                let trailingConstraint = self.scrollView.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor)
                let topConstraint = self.scrollView.topAnchor.constraint(equalTo: self.containerView.topAnchor)
                let bottomConstraint = self.scrollView.bottomAnchor.constraint(equalTo: self.containerView.bottomAnchor)
                NSLayoutConstraint.activate([leadingConstraint, trailingConstraint, topConstraint, bottomConstraint])
            }
            
            // Set the top bar
            self.topBar = UIView(frame: CGRect(x: 0, y: 0, width: self.containerView.frame.size.width, height: self.topBarHeight))
            self.topBar.backgroundColor = self.topBarBackground
            
            if self.aeroEffectInTopBar {
                // Create the blurred visual effect
                // You can choose between ExtraLight, Light and Dark
                self.topBar.backgroundColor = UIColor.clear
                
                let blurEffect: UIBlurEffect = UIBlurEffect(style: .light)
                self.blurView = UIVisualEffectView(effect: blurEffect)
                
                self.blurView.frame = self.topBar.bounds
                self.blurView.translatesAutoresizingMaskIntoConstraints = false
                self.topBar.addSubview(self.blurView)
            }
            self.topBar.translatesAutoresizingMaskIntoConstraints = false
            if self.topbarIsEnabled {
                self.containerView.addSubview(self.topBar)
            }
            
            // Set the top bar buttons
            // Check to see if the top bar will be created with images ot text
            if self.buttonsWithImages {
                var buttonsXPosition: CGFloat = 0
                
                for (index, image) in self.buttonImages.enumerated() {
                    let frame = CGRect(x: buttonsXPosition, y: 0, width: self.containerView.frame.size.width / CGFloat(pageCount), height: self.topBarHeight)
                    
                    let barButton = UIButton(frame: frame)
                    barButton.backgroundColor = UIColor.clear
                    barButton.imageView?.contentMode = .scaleAspectFit
                    barButton.setImage(image, for: .normal)
                    barButton.tag = index
                    barButton.addTarget(self, action: #selector(SwiftPages.barButtonAction), for: .touchUpInside)
                    self.topBar.addSubview(barButton)
                    self.barButtons.append(barButton)
                    
                    buttonsXPosition += self.containerView.frame.size.width / CGFloat(pageCount)
                }
            } else {
                var buttonsXPosition: CGFloat = 0
                
                for (index, title) in self.buttonTitles.enumerated() {
                    let frame = CGRect(x: buttonsXPosition, y: 0, width: self.containerView.frame.size.width / CGFloat(pageCount), height: self.topBarHeight)
                    
                    let barButton = UIButton(frame: frame)
                    barButton.backgroundColor = UIColor.clear
                    barButton.titleLabel!.font = self.buttonsTextFontAndSize
                    barButton.setTitle(title, for: .normal)
                    barButton.setTitleColor(self.buttonsTextColor, for: .normal)
                    barButton.tag = index
                    barButton.addTarget(self, action: #selector(SwiftPages.barButtonAction), for: .touchUpInside)
                    self.topBar.addSubview(barButton)
                    self.barButtons.append(barButton)
                    
                    buttonsXPosition += self.containerView.frame.size.width / CGFloat(pageCount)
                }
            }
            
                // Set up the animated UIView
                self.animatedBar = UIView(frame: CGRect(x: 0, y: self.topBarHeight - self.animatedBarHeight + 0, width: (self.containerView.frame.size.width / CGFloat(pageCount)) * 1.0 + 0, height: self.animatedBarHeight))
                self.animatedBar.center.x = self.containerView.frame.size.width / CGFloat(pageCount << 1)
                self.animatedBar.backgroundColor = self.animatedBarColor
                if self.topbarIsEnabled {
                    self.containerView.addSubview(self.animatedBar)
                }
            
            // Add the bar shadow (set to true or false with the barShadow var)
            if self.barShadow {
                self.shadowView = UIView(frame: CGRect(x: 0, y: self.topBarHeight, width: self.containerView.frame.size.width, height: 4))
                self.shadowViewGradient.frame = self.shadowView.bounds
                self.shadowViewGradient.colors = [UIColor(red: 150/255, green: 150/255, blue: 150/255, alpha: 0.28).cgColor, UIColor.clear.cgColor]
                self.shadowView.layer.insertSublayer(self.shadowViewGradient, at: 0)
                if self.topbarIsEnabled {
                    self.containerView.addSubview(self.shadowView)
                }
            }
                
                // add spacer view
                
                self.spacerView =  UIView(frame: CGRect(x: self.topBar.frame.size.width / 2 - 0.5, y: 0, width: 1, height: self.topBarHeight))
                self.spacerView.backgroundColor = UIColor(red: 184/255, green: 190/255, blue: 190/255, alpha: 1.0)
                
                
                self.topBar.addSubview(self.spacerView)
                
                self.topBar.bringSubview(toFront: self.spacerView)
                
            
            // Fill the array containing the VC instances with nil objects as placeholders
            for _ in 0..<pageCount {
                self.pageViews.append(nil)
            }
            
            // Defining the content size of the scrollview
            let pagesScrollViewSize = self.scrollView.frame.size
            self.scrollView.contentSize = CGSize(width: pagesScrollViewSize.width * CGFloat(pageCount), height: pagesScrollViewSize.height)
            
            // Load the pages to show initially
            self.loadVisiblePages()
            
            // Do the initial alignment of the subViews
            self.alignSubviews()
       //--ww }
    }
    
    // MARK: - Initialization Functions -
    
    public func initializeWithVCIDsArrayAndButtonTitlesArray (VCIDsArray: [String], buttonTitlesArray: [String], storyBoard: UIStoryboard) {
        self.storyBoard = storyBoard;
        initializeWithVCIDsArrayAndButtonTitlesArray (VCIDsArray: VCIDsArray, buttonTitlesArray: buttonTitlesArray)
    }
    
    public func initializeWithVCIDsArrayAndButtonImagesArray (VCIDsArray: [String], buttonImagesArray: [UIImage], storyBoard: UIStoryboard) {
        self.storyBoard = storyBoard
        initializeWithVCIDsArrayAndButtonImagesArray(VCIDsArray: VCIDsArray, buttonImagesArray: buttonImagesArray)
    }
    
    public func initializeWithVCsInstanciatedArrayAndButtonTitlesArray(VCsArray: [UIViewController], buttonTitlesArray: [String]) {
        // Important - Titles Array must Have The Same Number Of Items As The viewControllerIDs Array
        if VCsArray.count == buttonTitlesArray.count {
            viewControllersArray = VCsArray
            buttonTitles = buttonTitlesArray
            buttonsWithImages = false
        } else {
            print("Initilization failed, the VC array count does not match the button titles array count.")
        }
    }
    
    public func initializeWithVCsInstanciatedArrayAndButtonImagesArray(VCsArray: [UIViewController], buttonImagesArray: [UIImage]) {
        // Important - Titles Array must Have The Same Number Of Items As The viewControllerIDs Array
        if VCsArray.count == buttonImagesArray.count {
            viewControllersArray = VCsArray
            buttonImages = buttonImagesArray
            buttonsWithImages = true
        } else {
            print("Initilization failed, the VC array count does not match the button titles array count.")
        }
    }
    
    public func initializeWithVCIDsArrayAndButtonTitlesArray (VCIDsArray: [String], buttonTitlesArray: [String], storyBoardName: String = "Main") {
        // Important - Titles Array must Have The Same Number Of Items As The viewControllerIDs Array
        if VCIDsArray.count == buttonTitlesArray.count {
            viewControllerIDs = VCIDsArray
            buttonTitles = buttonTitlesArray
            buttonsWithImages = false
            self.storyBoardName = storyBoardName
        } else {
            print("Initilization failed, the VC ID array count does not match the button titles array count.")
        }
    }
    
    public func initializeWithVCIDsArrayAndButtonImagesArray (VCIDsArray: [String], buttonImagesArray: [UIImage], storyBoardName: String = "Main") {
        // Important - Images Array must Have The Same Number Of Items As The viewControllerIDs Array
        if VCIDsArray.count == buttonImagesArray.count {
            viewControllerIDs = VCIDsArray
            buttonImages = buttonImagesArray
            buttonsWithImages = true
            self.storyBoardName = storyBoardName
        } else {
            print("Initilization failed, the VC ID array count does not match the button images array count.")
        }
    }
    
    public func loadPage(page: Int) {
        // If it's outside the range of what you have to display, then do nothing
        guard page >= 0 && page < pageCount else { return }
        
        // Do nothing if the view is already loaded.
        guard pageViews[page] == nil else { return }
        
        print("Loading Page \(page)")
        
        // The pageView instance is nil, create the page
        var frame = scrollView.bounds
        frame.origin.x = frame.size.width * CGFloat(page)
        frame.origin.y = 0.0
        
        let newPageView = viewControllerForPage(page: page)
        newPageView.view.frame = frame
        scrollView.addSubview(newPageView.view)
        
        // Replace the nil in the pageViews array with the VC just created
        pageViews[page] = newPageView
    }
    
    public func viewControllerForPage(page: Int) -> UIViewController {
        //Look for the VC in the VC id list or in the VC object list
        if viewControllerIDs.count != 0 {
            return instanciateViewControllerWithIdentifier(identifier: viewControllerIDs[page])
        }
        return viewControllersArray[page]
    }
    
    public func instanciateViewControllerWithIdentifier(identifier: String) -> UIViewController {
        //If we have a storyboard created
        if let storyBoard = storyBoard {
            return storyBoard.instantiateViewController(withIdentifier: identifier)
        }
        return UIStoryboard(name: storyBoardName, bundle: nil).instantiateViewController(withIdentifier: identifier)
    }
    
    public func loadVisiblePages() {
        // First, determine which page is currently visible
        let pageWidth = scrollView.frame.size.width
        let page = Int(floor((scrollView.contentOffset.x * 2.0 + pageWidth) / (pageWidth * 2.0)))
        
        // make sure the delegate method called once
        if currentIndex != page {
            currentIndex = page;
            self.delegate?.SwiftPagesCurrentPageNumber(currentIndex: currentIndex)
        }
        
        // Work out which pages you want to load
        let firstPage = page - 1
        let lastPage = page + 1
        
        // Load pages in our range
        for index in firstPage...lastPage {
            loadPage(page: index)
        }
        
        if(currentIndex == 0){
            
            self.barButtons[1]?.backgroundColor = unSelectedColor
            self.barButtons[0]?.backgroundColor = selectedColor
            
            
        }else{
            self.barButtons[0]?.backgroundColor = unSelectedColor
            self.barButtons[1]?.backgroundColor = selectedColor
        }
    }
    
    @objc public func barButtonAction(sender: UIButton?) {
        
        let index = sender!.tag
        
        
        if(index == 1){
            
            self.barButtons[0]?.backgroundColor = unSelectedColor
            sender?.backgroundColor = selectedColor
            
            
        }else{
            self.barButtons[1]?.backgroundColor = unSelectedColor
            sender?.backgroundColor = selectedColor
            
        }
        
        let pagesScrollViewSize = scrollView.frame.size
        
        scrollView.setContentOffset(CGPoint(x: pagesScrollViewSize.width * CGFloat(index), y: 0), animated: true)
        
        currentPage = index
    }
    
    // MARK: - Orientation Handling Functions -
    
    public func alignSubviews() {
        
        // Setup the new frames
        scrollView.contentSize = CGSize(width: CGFloat(pageCount) * scrollView.bounds.size.width, height: scrollView.bounds.size.height)
        topBar.frame = CGRect(x: 0, y: 0, width: containerView.frame.size.width, height: topBarHeight)
        blurView?.frame = topBar.bounds
      //--ww  animatedBar.frame.size = CGSize(width: (containerView.frame.size.width / (CGFloat)(pageCount)) * 0.8, height: animatedBarHeight)
        animatedBar.frame.size = CGSize(width: (containerView.frame.size.width / (CGFloat)(pageCount)) * 1 - 1, height: animatedBarHeight)
        if barShadow {
            shadowView.frame.size = CGSize(width: containerView.frame.size.width, height: 4)
            shadowViewGradient.frame = shadowView.bounds
        }
        
        // Set the new frame of the scrollview contents
        for (index, controller) in pageViews.enumerated() {
            controller?.view.frame = CGRect(x: CGFloat(index) * scrollView.bounds.size.width, y: 0, width: scrollView.bounds.size.width, height: scrollView.bounds.size.height)
        }
        
        // Set the new frame for the top bar buttons
        var buttonsXPosition: CGFloat = 0
        for button in barButtons {
            button?.frame = CGRect(x: buttonsXPosition, y: 0, width: containerView.frame.size.width / CGFloat(pageCount), height: topBarHeight)
            buttonsXPosition += containerView.frame.size.width / CGFloat(pageCount)
        }
    }
    
    @objc func applicationWillEnterBackground() {
        //Save the current page
        currentPage = Int(scrollView.contentOffset.x / scrollView.bounds.size.width)
    }
    
    @objc func orientationWillChange() {
        //Save the current page
        currentPage = Int(scrollView.contentOffset.x / scrollView.bounds.size.width)
    }
    
    @objc func orientationDidChange() {
        //Update the view
        alignSubviews()
         spacerView.frame = CGRect(x: self.topBar.frame.size.width / 2 - 0.5, y: 0, width: 1, height: self.topBarHeight)
        scrollView.contentOffset = CGPoint(x: CGFloat(currentPage) * scrollView.frame.size.width, y: 0)
    }
    
    // MARK: - ScrollView delegate -
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
   let previousPage : NSInteger = currentPage
        let pageWidth : CGFloat = scrollView.frame.size.width
        let fractionalPage = scrollView.contentOffset.x / pageWidth
        let page : NSInteger = Int(round(fractionalPage))
        
        if (previousPage != page) {
            currentPage = page;
            delegate?.didEndDeceleratingPageNumber(currentIndex: currentPage)
        }
    }
    
    public func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        
      //  let previousPage : NSInteger = currentPage
      //  let pageWidth : CGFloat = scrollView.frame.size.width
      //  let fractionalPage = scrollView.contentOffset.x / pageWidth
       // let page : NSInteger = Int(round(fractionalPage))
        
       // if (previousPage != page) {
      //      currentPage = page;
            delegate?.didEndDeceleratingPageNumber(currentIndex: currentPage)
        //}
    }
    
    // MARK: - deinit -
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}


// MARK: - SwiftPages: UIScrollViewDelegate

extension SwiftPages: UIScrollViewDelegate {
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
     
        // Load the pages that are now on screen
        loadVisiblePages()
        
        // The calculations for the animated bar's movements
        // The offset addition is based on the width of the animated bar (button width times 0.8)
//        let offsetAddition = (containerView.frame.size.width / CGFloat(pageCount)) * 0.1
//        animatedBar.frame = CGRect(x: (offsetAddition + (scrollView.contentOffset.x / CGFloat(pageCount))), y: animatedBar.frame.origin.y, width: animatedBar.frame.size.width, height: animatedBar.frame.size.height)
        
        
        
        var offsetAddition = CGFloat(0.0)
        if(currentIndex == 1){
            offsetAddition = CGFloat(1.0)
        }
        animatedBar.frame = CGRect(x: (offsetAddition + (scrollView.contentOffset.x / CGFloat(pageCount))), y: animatedBar.frame.origin.y, width: animatedBar.frame.size.width, height: animatedBar.frame.size.height)
    }
}


public extension DispatchQueue {
    private static var _onceTracker = [String]()
    
    public class func once(file: String = #file, function: String = #function, line: Int = #line, block:()->Void) {
        let token = file + ":" + function + ":" + String(line)
        once(token: token, block: block)
    }
    
    /**
     Executes a block of code, associated with a unique token, only once.  The code is thread safe and will
     only execute the code once even in the presence of multithreaded calls.
     
     - parameter token: A unique reverse DNS style name such as com.vectorform.<name> or a GUID
     - parameter block: Block to execute once
     */
    public class func once(token: String, block:()->Void) {
        objc_sync_enter(self)
        defer { objc_sync_exit(self) }
        
        
        if _onceTracker.contains(token) {
            return
        }
        
        _onceTracker.append(token)
        block()
    }
}
