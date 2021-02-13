//
//  TableViewController.swift
//  ToDo
//
//  Created by Rusell on 06.02.2021.
//

import UIKit

class TasksViewController: UIViewController {
    
    let storageService: StorageServiceProtocol = StorageService()
    
    @IBOutlet weak var tableView: UITableView!
    
    private var openTasks: [Task] = []
    private var completedTasks: [Task] = []
    private var listTask: [Task] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupNavBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        readTasksAndUpdateUI()
    }
    
    //MARK: IBAction func
    @IBAction func logOut(_ sender: UIBarButtonItem) {
        UserDefaults.standard.setValue(nil, forKey: "uid")
        dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func addTask(_ sender: Any) {
        addTask(withTitle: Description.Alert.addNewTask, message: nil, style: .alert) { [weak self] (task) in
            
            guard let currentUser = self?.getCurrentUser() else { return }
            self?.storageService.addNewTAsk(user: currentUser, task: task)
            self?.readTasksAndUpdateUI()
            self?.reloadTableView()
        }
    }
    
    //MARK: Private func
    private func readTasksAndUpdateUI() {
        openTasks = storageService.getTasksNoCompleted(user: getCurrentUser())!
        completedTasks = storageService.getTasksIsCompleted(user: getCurrentUser())!
        self.reloadTableView()
    }
    
    private func setupTableView() {
        tableView.register(TaskViewCell.self)
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func setupNavBar() {
        title = Description.NavBar.titleToDoList
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.appFont(.extraBold, size: 24),
                                                                        NSAttributedString.Key(rawValue: NSAttributedString.Key.foregroundColor.rawValue): UIColor.appColor(.navBar)]
        navigationController?.navigationBar.tintColor = UIColor.appColor(.navBar)
    }
    
    private func getCurrentUser() -> String {
        guard let currentUser = (UserDefaults.standard.object(forKey: "uid")) as? String else { return "" }
        return currentUser
    }
    
    private func reloadTableView() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

//MARK: UITableViewDelegate, UITableViewDataSource
extension TasksViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return openTasks.count
        }
        return completedTasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.create(TaskViewCell.self, indexPath)
        
        var list = Task()
        if indexPath.section == 0 {
            list = openTasks[indexPath.row]
        } else {
            list = completedTasks[indexPath.row]
        }
        
        cell.imageTask.addTapGestureRecognizer { [weak self] in
            self?.pressedToGoDetailViewController(task: list)
        }
        
        cell.delegate = self
        cell.displayShow(task: list)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if section == 0 {
            return Description.TableView.newTasks
        }
        return Description.TableView.doneTasks
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .default, title: "Delete") { (deleteAction, indexPath) -> () in
            
            var taskToBeDeleted = Task()
            if indexPath.section == 0 {
                taskToBeDeleted = self.openTasks[indexPath.row]
            } else {
                taskToBeDeleted = self.completedTasks[indexPath.row]
            }
            
            self.storageService.deleteTask(indexTask: taskToBeDeleted)
            self.readTasksAndUpdateUI()
        }
        return [deleteAction]
    }
    
    @objc private func pressedToGoDetailViewController(task: Task?) {
        
        guard let task = task, let detailViewController = storyboard?.instantiateViewController(withIdentifier: Storyboard.ID.detailTask) as? DetailTaskViewController else { return }
        detailViewController.taskName = task.name
        detailViewController.taskNotes = task.notes
        detailViewController.taskId = task.id
        detailViewController.taskImageName = task.imageUrl
        self.navigationController?.pushViewController(detailViewController, animated: true)
    }
}

//MARK: TaskViewCellDelegate
extension TasksViewController: TaskViewCellDelegate {
    func didSetOn(from cell: TaskViewCell) {
        storageService.changedStatusIsCompleted(indexTask: cell.task)
        readTasksAndUpdateUI()
    }
    
    func didSetOff(from cell: TaskViewCell) {
        storageService.changedStatusNoCompleted(indexTask: cell.task)
        readTasksAndUpdateUI()
    }
    
}
