 //
//  ScanCoderController.swift
//  Towdatos
//


import UIKit
import AVFoundation

class ScanCoderController: UIViewController, StoryBoardHandler, AVCaptureMetadataOutputObjectsDelegate {
    
    static var myStoryBoard: (forIphone: String, forIpad: String?) = (Storyboards.main.rawValue , nil)
    
    @IBOutlet weak var messageLabel:UILabel!
    var callback : ((Bool?) -> Void)?
    
    var player: AVAudioPlayer?
    var captureSession:AVCaptureSession?
    var videoPreviewLayer:AVCaptureVideoPreviewLayer?
    var qrCodeFrameView:UIView?
    
    @IBOutlet weak var btnSwitchCamera: UIButton!
    @IBOutlet weak var btnFlash: UIButton!
    @IBOutlet weak var btnCross: UIButton!
    @IBOutlet weak var lblTitle: BaseUILabel!
    @IBOutlet weak var mainBg: UIImageView!
    
    // Added to support different barcodes
    let supportedBarCodes = [AVMetadataObject.ObjectType.qr, AVMetadataObject.ObjectType.code128, AVMetadataObject.ObjectType.code39, AVMetadataObject.ObjectType.code93, AVMetadataObject.ObjectType.upce, AVMetadataObject.ObjectType.pdf417, AVMetadataObject.ObjectType.ean13, AVMetadataObject.ObjectType.aztec]
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        setupCamera()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
    
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    func setupCamera() {
        
//        showNormalHud("Loading Camera.....")
        // Do any additional setup after loading the view.
        
        let captureDevice = AVCaptureDevice.default(for: AVMediaType.video)
        
        do {
            // Get an instance of the AVCaptureDeviceInput class using the previous device object.
            //captureDevice?.torchMode = .off
            let input = try AVCaptureDeviceInput(device: captureDevice!)
          //  print(captureDevice?.torch)
            
            // Initialize the captureSession object.
            captureSession = AVCaptureSession()
            // Set the input device on the capture session.
            captureSession?.addInput(input)
            
            // Initialize a AVCaptureMetadataOutput object and set it as the output device to the capture session.
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession?.addOutput(captureMetadataOutput)
            
            // Set delegate and use the default dispatch queue to execute the call back
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            
            // Detect all the supported bar code
            captureMetadataOutput.metadataObjectTypes = supportedBarCodes
            
            // Initialize the video preview layer and add it as a sublayer to the viewPreview view's layer.
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession!)
            videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
            
            videoPreviewLayer?.frame = view.layer.bounds
            view.layer.addSublayer(videoPreviewLayer!)
            
            
            
            // Start video capture
            captureSession?.startRunning()
            
            
            // Initialize QR Code Frame to highlight the QR code
            qrCodeFrameView = UIView()
            
            if let qrCodeFrameView = qrCodeFrameView {
                qrCodeFrameView.layer.borderColor = UIColor.green.cgColor
                qrCodeFrameView.layer.borderWidth = 2
                view.addSubview(qrCodeFrameView)
                view.bringSubview(toFront: qrCodeFrameView)
            }
            
            view.bringSubview(toFront: mainBg)
            view.bringSubview(toFront: lblTitle)
            view.bringSubview(toFront: btnCross)
            view.bringSubview(toFront: btnFlash)
            view.bringSubview(toFront: btnSwitchCamera)
            view.bringSubview(toFront:messageLabel)
//            removeNormalHud()
            
        } catch {
            // If any error occurs, simply print it out and don't continue any more.
            print(error)
            return
        }
        
        
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        
        //        let orientation: UIDeviceOrientation = UIDevice.current.orientation
        //        print(orientation.isLandscape)
        //        print(orientation.isPortrait)
        //        if(orientation.isLandscape == false) {
        //            return
        //        }
        
        // Check if the metadataObjects array is not nil and it contains at least one object.
        
        if metadataObjects.count == 0 {
            qrCodeFrameView?.frame = CGRect.zero
            messageLabel.text = "No barcode/QR code is detected"
            return
        }
        
        // Get the metadata object.
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        // Here we use filter method to check if the type of metadataObj is supported
        // Instead of hardcoding the AVMetadataObjectTypeQRCode, we check if the type
        // can be found in the array of supported bar codes.
        if supportedBarCodes.contains(metadataObj.type) {
            //        if metadataObj.type == AVMetadataObjectTypeQRCode {
            // If the found metadata is equal to the QR code metadata then update the status label's text and set the bounds
            let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj)
            qrCodeFrameView?.frame = barCodeObject!.bounds
            
            if metadataObj.stringValue != nil {
                print("*******************")
                //                if Constants.USER_DEFAULTS.bool(forKey: "Vibrate") == true {
                //                AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
                //                }
                //                if Constants.USER_DEFAULTS.bool(forKey: "Sound") == true {
                //                playSound()
                //                }
                AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
                playSound()
                messageLabel.text = metadataObj.stringValue
                verifyCode(metadataObj.stringValue!)
                captureSession?.stopRunning()
                
            }
        }
        
        
        
    }
    
    
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        
//        let orientation: UIDeviceOrientation = UIDevice.current.orientation
//        print(orientation.isLandscape)
//        print(orientation.isPortrait)
//        if(orientation.isLandscape == false) {
//            return
//        }
        
        // Check if the metadataObjects array is not nil and it contains at least one object.
        if metadataObjects == nil || metadataObjects.count == 0 {
            qrCodeFrameView?.frame = CGRect.zero
            messageLabel.text = "No barcode/QR code is detected"
            return
        }
        
        // Get the metadata object.
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        // Here we use filter method to check if the type of metadataObj is supported
        // Instead of hardcoding the AVMetadataObjectTypeQRCode, we check if the type
        // can be found in the array of supported bar codes.
        if supportedBarCodes.contains(metadataObj.type) {
            //        if metadataObj.type == AVMetadataObjectTypeQRCode {
            // If the found metadata is equal to the QR code metadata then update the status label's text and set the bounds
            let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj)
            qrCodeFrameView?.frame = barCodeObject!.bounds
            
            if metadataObj.stringValue != nil {
                                print("*******************")
//                if Constants.USER_DEFAULTS.bool(forKey: "Vibrate") == true {
//                AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
//                }
//                if Constants.USER_DEFAULTS.bool(forKey: "Sound") == true {
//                playSound()
//                }
                AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
                playSound()
                messageLabel.text = metadataObj.stringValue
                verifyCode(metadataObj.stringValue!)
                captureSession?.stopRunning()
                
            }
        }
       
        
        
    }
    func playSound() {
        let url = Bundle.main.url(forResource: "beep-01a", withExtension: "wav")!
        print(url)
        do {
            player = try AVAudioPlayer(contentsOf: url)
            guard let player = player else { return }
            
            player.prepareToPlay()
            player.play()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    @IBAction func toggleFlash() {
        
        guard let device = AVCaptureDevice.default(for: AVMediaType.video)
            else {return}
        
        if device.hasTorch {
            do {
                try device.lockForConfiguration()
                
                if device.torchMode == .off {
                    device.torchMode = .on
                } else {
                    device.torchMode = .off
                }
                
                device.unlockForConfiguration()
            } catch {
                print("Torch could not be used")
            }
        } else {
            print("Torch is not available")
        }
        
    }
    func verifyCode(_ data : String) {
        
 //       QRCodeCallback!(data)
        callback?(true)
        if UIDevice.current.orientation.isPortrait {
            self.navigationController?.popViewController(animated: true)
        }else{
            self.navigationController?.popViewController(animated: false)
        }
        //_ = self.navigationController?.popViewController(animated: true)
        //dismiss(animated: true, completion: nil)
    }



    
    @IBAction func backPop(_ sender: UIButton) {
        
       // self.popViewController()
        
    }
    
    override var shouldAutorotate: Bool{
        return true
    }
    
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask{
       return UIInterfaceOrientationMask.portrait
        
    }
    
//    override func willMove(toParentViewController parent: UIViewController?){
//       
//        if parent == nil
//        {
//            AppUtility.lockOrientation(.all, andRotateTo: .portrait)
//            
//            //sleep(UInt32(0.5))
//            
//        }
//    }

    

}

