//
//  RealmService.swift
//  RealmApp
//


import Foundation
import RealmSwift

class RealmService {
    
    private init() {}
    static let shared = RealmService()
    
    lazy var realm = try! Realm()
    
    func create<T: Object>(_ object: T) {
        
        do{
            try realm.write {
                realm.add(object)
            }
        }catch {
            print(error)
            post(error)
        }
    }
    
    func update<T: Object>(_ object: T, with dictionary: [String : Any?]) {
        do{
            try realm.write {
                for(key, value) in dictionary {
                    object.setValue(value, forKey: key)
                }
            }
        }catch {
            print(error)
            post(error)
        }
    }
    
    func delete<T: Object>(_ object: T) {
        do{
            try realm.write {
                realm.delete(object)
            }
        }catch {
            print(error)
            post(error)
        }
    }
    
    func post(_ error: Error) {
        NotificationCenter.default.post(name: NSNotification.Name("RealmError"), object: error)
    }
    
    func observeRealmErrors(in vc: UIViewController, completion: @escaping(Error?) -> Void) {
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name("RealmError"), object: nil, queue: nil) { (notification) in
            completion(notification.object as? Error)
        }
        
    }
    
    func stopObservingErrors(in vc: UIViewController) {
        
        NotificationCenter.default.removeObserver(vc, name: NSNotification.Name("RealmError"), object: nil)
    }
    
    
    
    
    static func getRealmJSON(realmObject: Object, realmType: Any) -> String {
        do {
            let realm = try Realm()
            let table = realm.objects(realmType as! Object.Type)
            if table.count == 0 {return "Empty Table"}
            let mirrored_object = Mirror(reflecting: realmObject)
            var properties = [String]()
            for (_, attr) in mirrored_object.children.enumerated() {
                if let property_name = attr.label as String! {
                    properties.append(property_name)
                }
            }
            var jsonObject = "["
            for i in 1...table.count {
                var str = "{"
                var insideStr = String()
                for property in properties {
                    let filteredTable = table.value(forKey: property) as! [Any]
                    insideStr += "\"\(property)\": \"\(filteredTable[i - 1])\","
                }
                let index = insideStr.index(insideStr.startIndex, offsetBy: (insideStr.count - 2))
                insideStr = String(insideStr[...index])
                str += "\(insideStr)},"
                jsonObject.append(str)
            }
            let index = jsonObject.index(jsonObject.startIndex, offsetBy: (jsonObject.count - 2))
            jsonObject = "\(String(jsonObject[...index]))]"
            return jsonObject
        }catch let error { print("\(error)") }
        return "Problem reading Realm"
    }
    
    
    
    
    
    
    
    
    
}




extension Object{

    
}
