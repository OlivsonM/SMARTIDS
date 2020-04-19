//
//  QRImages.swift
//  OCRApp
//


import Foundation
import  RealmSwift

@objcMembers class QRImages : Object, Codable{
    
    dynamic var cardId : Int = 0
    dynamic var QRImagePath : String = ""
    
    convenience init(cardId:Int, QRurl : String) {
        self.init()
        self.cardId = cardId
        self.QRImagePath = QRurl
        
        // self.cardId = cardId
        
    }
    
//    func IncrementaID() -> Int{
//        let realm = try! Realm()
//        if let retNext = realm.objects(Card.self).sorted(byKeyPath: "cardId").first?.cardId {
//            return retNext + 1
//        }else{
//            return 1
//        }
//    }
    
}
