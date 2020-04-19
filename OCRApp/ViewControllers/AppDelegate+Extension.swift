//
//  AppDelegate+Extension.swift
//  OCRApp
//

import Foundation



extension AppDelegate: NetworkManagerDelegate{
    func isConnected() {
       // self.uploadCard()
    }
    func isNotConnected() {
        
    }
}
extension AppDelegate : ClientDelegate {
    
    func getDictionaryObject(card : CardPending) -> [String : Any?] {
        
        let dict: [String : Any?] = ["cardId" : card.cardId,
                                     "cardStatus" : PendingCardStatus.processing.rawValue,
                                     "pendingImagePath" : card.pendingImagePath,
                                     ]
        
        return dict
        
    }
    
    func scheduleTimer() {
        guard (timer) == nil else {
            return
        }
        
        timer = Timer.scheduledTimer(timeInterval: 5.0,
                                 target: self,
                                 selector: (#selector(AppDelegate.uploadCard)),
                                 userInfo: nil,
                                 repeats: true)
    }
    
    @objc func uploadCard(){
        
        if(NetworkManager.sharedInstance.reachability.connection == .none){
            return
        }
        let realm = RealmService.shared.realm
        let cardCount = realm.objects(CardPending.self).filter(RealmFilter.pendingCard)
        print(cardCount.count)
        if (cardCount.count > 0 && isUploadingCard == false) {
            let data : CardPending = cardCount[0]
       // let data = cardCount[0]
//            for index in 0..<cardCount.count {
//                if(data.cardStatus == PendingCardStatus.failed.rawValue) {
//                    if (index == (cardCount.count - 1) ) {
//                        return
//                    }
//                }
//                else {
//                    data = cardCount[index]
//                    break
//                }
//            }
           // data.cardStatus = PendingCardStatus.processing.rawValue
            let dict: [String : Any?] = getDictionaryObject(card: data)
            print(dict)
            RealmService.shared.update(data, with:dict)
            //isShowScreen = false
            //client?.delegate = self
            isUploadingCard = true
            if client != nil {
                client?.delegate = self
                client = nil
                params = nil
            }
            client = Client.init(applicationID: MyApplicationID, password: MyPassword)
            params = ProcessingParams.init()
            client?.delegate = self
            client?.processImage(Utility.loadImageFromPath(data.pendingImagePath)!, with: params)
            
        }
    }
    
    func clientDidFinishUpload(_ sender: Client!) {
        print("clientDidFinishUpload")
    }
    func clientDidFinishProcessing(_ sender: Client!) {
        print("clientDidFinishProcessing")
    }
    func client(_ sender: Client!, didFinishDownloadData downloadedData: Data!) {
        print("didFinishDownloadData")
        isUploadingCard = false
        print(downloadedData.utf8String)
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
        
//        name = ""
//        email = ""
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
                           cardId: "1",
                           templateId: String(randomNum),
                           website:website,
                           note: "")
        
        newCard.cardId = newCard.IncrementaID()
        print(newCard.debugDescription)
        Singleton.sharedInstance.scanCard = newCard
        Singleton.sharedInstance.isCardScan = true
        
        
        
        let cardCount = RealmService.shared.realm.objects(CardPending.self).filter(RealmFilter.processingCard)
        
        print(name.count)
        print(email.count)
        if (name.isEmptyStr() && email.isEmptyStr()) {
            let data = cardCount[0]
            var dict: [String : Any?] = getDictionaryObject(card: data)
            dict["cardStatus"] = PendingCardStatus.failed.rawValue
            dict["card"] = newCard
            RealmService.shared.update(data, with:dict)
        }
        else {
           RealmService.shared.create(newCard)
            RealmService.shared.delete(cardCount[0])
        }
        
        
        
        client?.delegate = nil
        client = nil
        params = nil
        
    }
    
    func client(_ sender: Client!, didFailedWithError error: Error!) {
        isUploadingCard = false
//        let cardCount = RealmService.shared.realm.objects(CardPending.self).filter(RealmFilter.processingCard)
//        if (cardCount.count > 0) {
//            let data = cardCount[0]
//            var dict: [String : Any?] = getDictionaryObject(card: data)
//            dict["cardStatus"] = PendingCardStatus.failed.rawValue
//            RealmService.shared.update(data, with:dict)
//            
//        }
        print("didFailedWithError")
        client?.delegate = nil
        client = nil
        params = nil
    }
}
