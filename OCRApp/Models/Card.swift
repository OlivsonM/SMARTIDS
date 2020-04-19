//
//  Card.swift
//  RealmApp
//


import Foundation
import  RealmSwift

@objcMembers class Card : Object, Codable{
    
    dynamic var cardId : Int = 0
    dynamic var templateCardId : String = ""
    dynamic var name : String = ""
    dynamic var poition : String = ""
    dynamic var company : String = ""
    dynamic var email : String = ""
    dynamic var phone : String = ""
    dynamic var address : String = ""
    dynamic var website : String = ""
    dynamic var linkedIn : String = ""
    dynamic var isMyCard : Bool = false
    dynamic var cardColor : String = ""
    dynamic var QRImagePath : String = ""
    dynamic var groupName : String = ""
    dynamic var note : String = ""
    
    convenience init(name:String, poition:String, company:String, email:String, phone:String, address:String, linkedIn:String, isMyCard:Bool, cardColor:String, cardId:String,templateId : String, website: String, note: String) {
        self.init()
        self.name = name
        self.poition = poition
        self.company = company
        self.email = email
        self.phone = phone
        self.address = address
        self.linkedIn = linkedIn
        self.isMyCard = isMyCard
        self.cardColor = cardColor
        self.templateCardId = templateId
        self.website = website
        self.groupName = ""
        self.note = note
       // self.cardId = cardId
        
    }
    
    func IncrementaID() -> Int{
        let realm = try! Realm()
        if let retNext = realm.objects(Card.self).sorted(byKeyPath: "cardId").last?.cardId {
            return retNext + 1
        }else{
            return 1
        }
    }
    
}


/*
 let encodedData = try? JSONEncoder().encode(newCard)
 let encodedData1 = try? JSONDecoder().decode(Card.self, from: encodedData!)
 
 */
