//
//  User.swift
//  ToDo
//
//  Created by Rusell on 31.01.2021.
//

import RealmSwift

class User: Object {
    @objc dynamic var login: String = ""
    @objc dynamic var password: String = ""
    
    convenience init(name: String, email: String) {
        self.init()
        
        self.login = login
        self.password = password
    }
}


