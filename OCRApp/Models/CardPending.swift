//
//  Card.swift
//  RealmApp
//


import Foundation
import  RealmSwift

@objcMembers class CardPending : Object, Codable{
    
    dynamic var cardId : Int = 0
    dynamic var cardStatus : Int = 0
    dynamic var pendingImagePath : String = ""
    dynamic var card : Card? = nil
    convenience init(cardId:Int, path : String, status : Int) {
        self.init()
        self.cardId = cardId
        self.pendingImagePath = path
        self.cardStatus = status
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


/*
 let encodedData = try? JSONEncoder().encode(newCard)
 let encodedData1 = try? JSONDecoder().decode(Card.self, from: encodedData!)
 
 */
