//
//  MyCardController+Extension.swift
//  OCRApp
//

import Foundation
import MultipeerConnectivity
import RealmSwift
extension PickCardController {
    
    func initializePeerConnection() {
        peerID = MCPeerID(displayName: UIDevice.current.name)
        mcSession = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: .required)
        mcSession.delegate = self
    }
    
    
    func recieveCardData() {
        let mcBrowser = MCBrowserViewController(serviceType: "ba-td", session: self.mcSession)
        mcBrowser.delegate = self
        self.present(mcBrowser, animated: true, completion: nil)
        
    }
    func sendCardData() {
        self.mcAdvertiserAssistant = MCAdvertiserAssistant(serviceType: "ba-td", discoveryInfo: nil, session: self.mcSession)
        self.mcAdvertiserAssistant.start()
        
    }
    
    
    @IBAction func showConnectivityActions(_ sender: Any) {
        let actionSheet = UIAlertController(title: "ToDo Exchange", message: "Do you want to Host or Join a session?", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Host Session", style: .default, handler: { (action:UIAlertAction) in
            
            self.mcAdvertiserAssistant = MCAdvertiserAssistant(serviceType: "ba-td", discoveryInfo: nil, session: self.mcSession)
            self.mcAdvertiserAssistant.start()
            
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Join Session", style: .default, handler: { (action:UIAlertAction) in
            let mcBrowser = MCBrowserViewController(serviceType: "ba-td", session: self.mcSession)
            mcBrowser.delegate = self
            self.present(mcBrowser, animated: true, completion: nil)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(actionSheet, animated: true, completion: nil)
        
    }
    
    func sendMessage () {
        let cafe: Data? = "Cdaas".data(using: .utf8)
//         print(selectedCard)
//        let dic = selectedCard.toDictionary()
//        print(dic)
//        
//        print(dic)
         let pieceData = NSKeyedArchiver.archivedData(withRootObject:cafe)
        print(pieceData)
        if mcSession.connectedPeers.count > 0 {
                do {
                    
                    try mcSession.send(pieceData, toPeers: mcSession.connectedPeers, with: .reliable)
                }catch{
                    fatalError("Could not send todo item")
                }
            
        }else{
            print("you are not connected to another device")
        }
    }
    
    
}

extension PickCardController: MCSessionDelegate, MCBrowserViewControllerDelegate {
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        switch state {
        case MCSessionState.connected:
            print("Connected: \(peerID.displayName)")
            
        case MCSessionState.connecting:
            print("Connecting: \(peerID.displayName)")
            
        case MCSessionState.notConnected:
            print("Not Connected: \(peerID.displayName)")
        }
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        
        do {
           // let encodedData = try? JSONDecoder().decode(Card.self, from: data)
            let dictionary: Dictionary? = NSKeyedUnarchiver.unarchiveObject(with: data) as? [String : Any]
             print(dictionary)
            saveCardToDatabase(dictionary!)
//            let encodedData1 = try? JSONDecoder().decode(Card.self, from: data)
//            print(encodedData1?.name)
//            let todoItem = String(decoding: data, as: UTF8.self)
//            print(todoItem)
            
        }catch{
            fatalError("Unable to process recieved data")
        }
        
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        print("did receive")
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        print("did receive")
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        print("didFinishReceivingResourceWithName")
    }
    
    
    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
        print("didFinishReceivingResourceWithName")
        dismiss(animated: true, completion: nil)
    }
    
    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        print("didFinishReceivingResourceWithName")
        dismiss(animated: true, completion: nil)
    }
    
    
    func saveCardToDatabase(_ card : [String : Any]/*Card*/) {
        
        let newCard = Card(name: card["name"] as! String,
                           poition: card["poition"] as! String,
                           company: card["company"] as! String,
                           email: card["email"] as! String,
                           phone: card["phone"] as! String,
                           address: card["address"] as! String,
                           linkedIn: card["linkedIn"] as! String,
                           isMyCard: false,
                           cardColor: card["cardColor"] as! String,
                           cardId: "1",
                           templateId: card["templateCardId"] as! String,
                           website: card["website"] as! String,
                           note: card["note"] as! String)
        newCard.cardId = newCard.IncrementaID()
        newCard.isMyCard = false
        newCard.QRImagePath = ""
        //RealmService.shared.create(newCard)
        print(newCard)
        
         let realm1 = try! Realm()
        try! realm1.write {
            realm1.add(newCard)
            //  person.name = "Jane Doe"
        }
        DispatchQueue.main.async {
            self.configureRealm()
            self.collectionView.reloadData()
        }
        
//        try! realm.write {
//            realm.add(newCard)
//            //  person.name = "Jane Doe"
//        }
        /*
     //   let realm = try! Realm()
//        try! realm.write {
//            realm.add(newCard)
//        }
        let personRef = ThreadSafeReference(to: newCard)
        DispatchQueue(label: "com.example.myApp.bg").async {
            let realm = try! Realm()
            guard let person = realm.resolve(personRef) else {
                return // person was deleted
            }
            try! realm.write {
                realm.add(newCard)
              //  person.name = "Jane Doe"
            }
        }

        */
    }
    
    
//        //        isSuccessfullScan = true
//        // Alert.showMsg(msg: "Card added successfully")
//        self.dismiss(animated: true) {
//            print("dismiss")
//            //self.callback?(true)
//
//        }

    
}



