//
//  Task.swift
//  ToDo
//
//  Created by Rusell on 31.01.2021.
//
import UIKit
import RealmSwift

class Task: Object {
    @objc dynamic var login = ""
    
    @objc dynamic var id = UUID().uuidString
    @objc dynamic var name = ""
    @objc dynamic var createdDateTime = NSDate()
    @objc dynamic var notes = ""
    @objc dynamic var isCompleted = false
    @objc dynamic var imageUrl = ""
    
    override class func primaryKey() -> String{
        return "id"
    }
    
    convenience init(login: String,
                     name: String,
                     createdDateTime: NSDate,
                     notes: String,
                     isCompleted: Bool,
                     imageUrl: String) {
        self.init()
        
        self.login = login
        self.name = name
        self.createdDateTime = createdDateTime
        self.notes = notes
        self.isCompleted = isCompleted
        self.imageUrl = imageUrl
    }
    
    func incrementID() -> Int {
        let realm = try! Realm()
        return (realm.objects(Task.self).max(ofProperty: "id") as Int? ?? 1) + 1
    }
    
}

