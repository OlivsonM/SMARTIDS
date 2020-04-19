//
//  CardGroup.swift
//  OCRApp
//

import Foundation
import  RealmSwift

@objcMembers class CardGroup : Object, Codable{
    
   // dynamic var cardId : Int = 0
    dynamic var groupName : String = ""
    
    convenience init(name : String) {
        self.init()
       // self.cardId = cardId
        self.groupName = name
        
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
