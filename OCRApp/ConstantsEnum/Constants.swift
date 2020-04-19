//
//  Constants.swift
//  LaundryApp
//


import UIKit

enum Constants {
    static let maximumLengthName = 20
    static let maximumLengthNumber = 20
    static let minimumLengthNumber = 6
    static let maximumLengthText = 50
    static let minimumLengthPwd = 6
    static let maximumLengthPwd = 20
    static let maximumLengthTextView = 500
    static let maximumLengthLinkedIn = 200
    static let networkSessionToken  = ""
    static let selectedColor = UIColor(red: 198/255, green: 0/255, blue: 37/255, alpha: 1)
}

enum FP {
    
    static var emailUser = ""
}

//enum CurrentUser{
//    static var data : User? = nil
//    static var token : String = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOjE4LCJpc3MiOiJodHRwOi8vbGF1bmRyeS5zdGFnaW5naWMuY29tL2FwaS9sb2dpbiIsImlhdCI6MTUxODYwMTQ5NiwiZXhwIjoxNTIyMjAxNDk2LCJuYmYiOjE1MTg2MDE0OTYsImp0aSI6IktlU0x2akJXQXV3QWkzbnkifQ.MZYbiH6Dkxf27_t1kT4w_rZxFPCYy70bBE4zuD58xmE"
//    static var userType : UserType = .registered
//
//}

enum Login {
    static let isLoggedIn : String = "isLoggedIn"
    static let userData : String = "userData"
    static let token : String = "token"
}


//enum CartData{
//    static var cartDict : [Int : (quantity : Int, amount: Int , item : SLItem , section :Int)]? = [:]
//    static var totalAmount : Int = 0
//    static var totalQuantity : Int = 0
//    static var params : [String : AnyObject] = [:]
//    static var orderDetail : [[String : AnyObject]] = [[:]]
//}

enum GoogleMap{
   static let key : String = "AIzaSyBbm5LaMZF6g7RcATzFsVyz9BuaPrrefxM" // "AIzaSyD7sU52onvkEkZd0NwlFXGbOQ-C791LVh4"
    
}

enum ServiceCodes {
    static let successCode : Int = 200
}

enum UserDefaultKey {
    static let isConfigurationSaved = "isConfigurationSaved"
}

enum UserType{
    case registered
    case guest
    
}

enum MyCardType {
    case none
    case view
    case create
}



enum CardsUITags:Int {
    case name = 1
    case position = 2
    case email = 3
    case phone = 4
    case location = 5
    case website = 6
    case mainStack = 7
    case cardImage = 8
    case QRCodeImage = 9
    case company = 10
    case notePin = 11
}



enum CardsUIColors:String {
    case color1 = "#99FFCC"
    case color2 = "#CCCC99"
    case color3 = "#CCCCCC"
    case color4 = "#CCCCFF"
    case color5 = "#CCFF99"
    case color6 = "#CCFFCC"
    case color7 = "#CCFFFF"
    case color8 = "#FFCC99"
    case color9 = "#FFCCCC"
    case color10 = "#FFFF99"
}


enum RealmFilter {
    
    static let myCard = NSPredicate(format: "isMyCard = true")
    static let otherCard = NSPredicate(format: "isMyCard = false")
    static let pendingCard = NSPredicate(format: "cardStatus = 1")
    static let processingCard = NSPredicate(format: "cardStatus = 2")
    
}

enum PendingCardStatus : Int {
    
    case pending = 1
    case processing = 2
    case uploaded = 3
    case failed = 4
    
}

