//
//  Storage.swift
//  ToDo
//
//  Created by Rusell on 31.01.2021.
//

import RealmSwift

protocol StorageServiceProtocol {
    func addUser(_ login: String, _ password: String) -> String
    func checkUser(user: String) -> Bool
    func verificationUser(user: String, password: String) -> Bool
    func addNewTAsk(user: String, task: String?)
    func getTasksIsCompleted(user: String) -> [Task]?
    func getTasksNoCompleted(user: String) -> [Task]?
    func deleteTask(indexTask: Task?)
    func changedStatusNoCompleted(indexTask: Task?)
    func changedStatusIsCompleted(indexTask: Task?)
    func changedTaskData(id: String?, name: String?, notes: String?, imageUrl: String?)
}

class StorageService: StorageServiceProtocol {
    
    private var realm: Realm
    
    init() {
        guard let realm = try? Realm() else {
            fatalError() }
        self.realm = realm
    }
    
    func addUser(_ login: String, _ password: String) -> String {
        if checkUser(user: login) {
            try! realm.write {
                let user = User()
                user.login = login
                user.password = password
                realm.add(user)
                print("\(user.login) - \(user.password)")
                realm.refresh()
            }
            return ShowMessage.SuccessRegistration.successRegistration
        }
        return ShowMessage.ErrorRegistration.errorLogin
    }
    
    func checkUser(user: String) -> Bool {
        let usersList = realm.objects(User.self)
        for someUser in usersList {
            if user == someUser.login {
                return false
            }
        }
        return true
    }
    
    func verificationUser(user: String, password: String) -> Bool {
        let usersList = realm.objects(User.self)
        for someUser in usersList {
            if user == someUser.login && password == someUser.password {
                return true
            }
        }
        return false
    }
    
    func addNewTAsk(user: String, task: String?) {
        guard let task = task else { return }
        let newTaskList = Task()
        
        newTaskList.login = user
        newTaskList.name = task
        newTaskList.isCompleted = false
        newTaskList.createdDateTime = NSDate()
        
        try! realm.write {
            realm.add(newTaskList)
            realm.refresh()
        }
    }
    
    func getTasksIsCompleted(user: String) -> [Task]? {
        let tasks = realm.objects(Task.self).filter({$0.login == user && $0.isCompleted})
        return tasks.sorted(by: {$0.createdDateTime > $1.createdDateTime })
    }
    
    func getTasksNoCompleted(user: String) -> [Task]? {
        let tasks = realm.objects(Task.self).filter({$0.login == user && !$0.isCompleted})
        return tasks.sorted(by: {$0.createdDateTime > $1.createdDateTime })
    }
    
    func deleteTask(indexTask: Task?) {
        guard let indexTask = indexTask else { return }
        try! realm.write {
            realm.delete(indexTask)
            realm.refresh()
        }
    }
    
    func changedStatusNoCompleted(indexTask: Task?) {
        guard let indexTask = indexTask else { return }
        try! realm.write({ () -> Void in
            indexTask.isCompleted = false
            realm.refresh()
        })
    }
    
    func changedStatusIsCompleted(indexTask: Task?) {
        guard let indexTask = indexTask else { return }
        try! realm.write({ () -> Void in
            indexTask.isCompleted = true
            indexTask.createdDateTime = NSDate()
            realm.refresh()
        })
    }
    
    func changedTaskData(id: String?, name: String?, notes: String?, imageUrl: String?) {
        guard let id = id, let name = name else { return }
        let taskInRealmDatabase = realm.objects(Task.self).filter("id == %@", id)
        let taskHas = taskInRealmDatabase

        try! realm.write({ () -> Void in
            taskHas[0].name = name
            taskHas[0].notes = notes ?? ""
            taskHas[0].imageUrl = imageUrl ?? ""
            realm.refresh()
        })
    }
    
}
