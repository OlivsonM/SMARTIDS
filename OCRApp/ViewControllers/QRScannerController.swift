//
//  QRScannerController.swift
//  QRCodeReader
//


import UIKit
import AVFoundation

class QRScannerController: UIViewController,StoryBoardHandler {

    @IBOutlet weak var cameraView: UIView!
    static var myStoryBoard: (forIphone: String, forIpad: String?) = (Storyboards.main.rawValue , nil)
    @IBOutlet var messageLabel:UILabel!
//    @IBOutlet var topbar: UIView!
    var cardUpdated: () -> (String) = {
        return "card updated"
    }
    
    var callback : ((Bool?) -> Void)?
    var player: AVAudioPlayer?
    
    @IBOutlet weak var btnSwitchCamera: UIButton!
    @IBOutlet weak var btnFlash: UIButton!
    @IBOutlet weak var btnCross: UIButton!
    @IBOutlet weak var lblTitle: BaseUILabel!
    @IBOutlet weak var mainBg: UIImageView!
    var captureSession = AVCaptureSession()
    
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var qrCodeFrameView: UIView?

    var isSuccessfullScan = false
    private let supportedCodeTypes = [AVMetadataObject.ObjectType.upce,
                                      AVMetadataObject.ObjectType.code39,
                                      AVMetadataObject.ObjectType.code39Mod43,
                                      AVMetadataObject.ObjectType.code93,
                                      AVMetadataObject.ObjectType.code128,
                                      AVMetadataObject.ObjectType.ean8,
                                      AVMetadataObject.ObjectType.ean13,
                                      AVMetadataObject.ObjectType.aztec,
                                      AVMetadataObject.ObjectType.pdf417,
                                      AVMetadataObject.ObjectType.itf14,
                                      AVMetadataObject.ObjectType.dataMatrix,
                                      AVMetadataObject.ObjectType.interleaved2of5,
                                      AVMetadataObject.ObjectType.qr]
   
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        
        messageLabel.text = ""
        // Get the back-facing camera for capturing videos
        //AVCaptureDevice.default(.builtInWideAngleCamera, for: AVMediaType.video, position: .back)

        
        let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: AVMediaType.video, position: .back)
        
        guard let captureDevice = deviceDiscoverySession.devices.first else {
            print("Failed to get the camera device")
            return
        }
        
        do {
            // Get an instance of the AVCaptureDeviceInput class using the previous device object.
            let input = try AVCaptureDeviceInput(device: captureDevice)
            
            // Set the input device on the capture session.
            captureSession.addInput(input)
            
            // Initialize a AVCaptureMetadataOutput object and set it as the output device to the capture session.
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession.addOutput(captureMetadataOutput)
            
            // Set delegate and use the default dispatch queue to execute the call back
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            captureMetadataOutput.metadataObjectTypes = supportedCodeTypes
//            captureMetadataOutput.rectOfInterest = CGRect(x: 0, y: 0, width: 0.5, height: 0.5)
//            captureMetadataOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
            captureSession.startRunning()
        } catch {
            // If any error occurs, simply print it out and don't continue any more.
            print(error)
            return
        }
        
        // Initialize the video preview layer and add it as a sublayer to the viewPreview view's layer.
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
       // videoPreviewLayer?.frame = view.layer.bounds
        
        cameraView.layer.addSublayer(videoPreviewLayer!)
        videoPreviewLayer?.position = CGPoint(x: cameraView.frame.width/2, y: cameraView.frame.height/2)
        videoPreviewLayer?.bounds = cameraView.frame
        
        
        
        //view.layer.addSublayer(videoPreviewLayer!)
        
        // Start video capture.
        captureSession.startRunning()
        
        // Move the message label and top bar to the front
        
        view.bringSubview(toFront: mainBg)
        view.bringSubview(toFront: lblTitle)
        view.bringSubview(toFront: btnCross)
        view.bringSubview(toFront: btnFlash)
        view.bringSubview(toFront: btnSwitchCamera)
        view.bringSubview(toFront:messageLabel)
        
        // Initialize QR Code Frame to highlight the QR code
        qrCodeFrameView = UIView()
        
        if let qrCodeFrameView = qrCodeFrameView {
            qrCodeFrameView.layer.borderColor = UIColor.green.cgColor
            qrCodeFrameView.layer.borderWidth = 2
            view.addSubview(qrCodeFrameView)
            view.bringSubview(toFront: qrCodeFrameView)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Helper methods

    func launchApp(decodedURL: String) {
        
        if presentedViewController != nil {
            return
        }
        
        
        
        
        let alertPrompt = UIAlertController(title: "Open App", message: "You're going to open \(decodedURL)", preferredStyle: .actionSheet)
        let confirmAction = UIAlertAction(title: "Confirm", style: UIAlertActionStyle.default, handler: { (action) -> Void in
            
            if let url = URL(string: decodedURL) {
                if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            }
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil)
        
        alertPrompt.addAction(confirmAction)
        alertPrompt.addAction(cancelAction)
        
        present(alertPrompt, animated: true, completion: nil)
    }
    
    
    @IBAction func dismissScanner(_ sender: UIButton) {
        
        self.dismiss(animated: true) {
            print("dismiss")
        }
    }
    
    @IBAction func toggleFlash(_ sender: UIButton) {
        
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
    @IBAction func toggleCamera(_ sender: UIButton) {
        swapCamera()
    }
    
    fileprivate func swapCamera() {
        
        // Get current input
    
        guard let input = captureSession.inputs[0] as? AVCaptureDeviceInput else { return }
        
        // Begin new session configuration and defer commit
        captureSession.beginConfiguration()
        defer { captureSession.commitConfiguration() }
        
        // Create new capture device
        var newDevice: AVCaptureDevice?
        if input.device.position == .back {
            newDevice = captureDevice(with: .front)
        } else {
            newDevice = captureDevice(with: .back)
        }
        
        // Create new capture input
        var deviceInput: AVCaptureDeviceInput!
        do {
            deviceInput = try AVCaptureDeviceInput(device: newDevice!)
        } catch let error {
            print(error.localizedDescription)
            return
        }
        
        // Swap capture device inputs
        captureSession.removeInput(input)
        captureSession.addInput(deviceInput)
    }
    
    /// Create new capture device with requested position
    fileprivate func captureDevice(with position: AVCaptureDevice.Position) -> AVCaptureDevice? {
        
        let devices = AVCaptureDevice.DiscoverySession(deviceTypes: [ .builtInWideAngleCamera, .builtInMicrophone, .builtInDualCamera, .builtInTelephotoCamera ], mediaType: AVMediaType.video, position: .unspecified).devices
        
        for device in devices {
            if device.position == position {
                return device
            }
        }
//        if let devices = devices {
//            for device in devices {
//                if device.position == position {
//                    return device
//                }
//            }
//        }
        
        return nil
    }

}

extension QRScannerController: AVCaptureMetadataOutputObjectsDelegate {
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        // Check if the metadataObjects array is not nil and it contains at least one object.
        if metadataObjects.count == 0 {
            qrCodeFrameView?.frame = CGRect.zero
            //messageLabel.text = "No QR code is detected"
            return
        }
        
        // Get the metadata object.
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        if supportedCodeTypes.contains(metadataObj.type) {
            // If the found metadata is equal to the QR code metadata (or barcode) then update the status label's text and set the bounds
            let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj)
            qrCodeFrameView?.frame = barCodeObject!.bounds
            
            if metadataObj.stringValue != nil {
                var str = metadataObj.stringValue!
                var data = str.data(using: .utf8)
                
                AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
                playSound()
                
                
                let encodedData1 = try? JSONDecoder().decode(Card.self, from: data!)
                qrCodeFrameView?.frame = CGRect.zero
                if let data = encodedData1 {
                    messageLabel.text = "Successfully scanned"
                    saveCardToDatabase(data)
                }
                else {
                    messageLabel.text = "Invalid QR code scanned"
                    Utility.delay(seconds: 1.0) {
                        self.dismiss(animated: true) {
                            print("dismiss")
                            self.callback?(false)
                            
                        }
                    }
                    
                    
                }
                captureSession.stopRunning()
//                print(encodedData1?.name)
//                print(encodedData1?.cardId)
              //  launchApp(decodedURL: metadataObj.stringValue!)
                //messageLabel.text = metadataObj.stringValue
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
    func saveCardToDatabase(_ card : Card) {
        
        if (isSuccessfullScan == false) {
            card.cardId = card.IncrementaID()
            card.isMyCard = false
            card.QRImagePath = ""
            RealmService.shared.create(card)
            isSuccessfullScan = true
           // Alert.showMsg(msg: "Card added successfully")
            self.dismiss(animated: true) {
                print("dismiss")
                self.callback?(true)
                
            }
        }
        
    }
    
}
