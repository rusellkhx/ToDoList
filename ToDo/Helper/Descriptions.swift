//
//  Descriptions.swift
//  CurrencyRates
//
//  Created by Rusell on 30.01.2021.
//

import Foundation

struct ShowMessage {
    
    enum ErrorRegistration {
        static let errorRegistarion = "Error registration, please repeat"
        static let errorPasswordRepeat = "The password must be the same, please repeat"
        static let errorLogin = "Login is already in use, please come up with a new one"
    }
    
    enum SuccessRegistration {
        static let successRegistration = "Successful registration"
    }
}

struct Description {
    
    enum NavBar {
        static let titleToDoList = "TODO List"
        static let titleDetailed = "Detailed"
    }
    
    enum Alert {
        static let cancel = "Cancel"
        static let changeImage = "Change Image"
        static let removeImage = "Remove Image"
        static let addNewTask = "Add New Task"
    }
    
    enum TableView {
        static let newTasks = "New tasks"
        static let doneTasks = "Done tasks"
    }
}

struct Storyboard {
    
    enum ID {
        static let registration = "RegistrationViewController"
        static let login = "LoginViewController"
        static let detailTask = "DetailTaskViewController"
        static let tasks = "TasksViewController"
    }
    
    enum Segue {
        static let goToTasks = "ShowTasks"
        static let goToDetailTask = "ShowDetailTask"
    }
}


