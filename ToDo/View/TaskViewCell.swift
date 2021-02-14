//
//  TableViewCell.swift
//  ToDo
//
//  Created by Rusell on 30.01.2021.
//

import UIKit

protocol TaskViewCellProtocol: AnyObject {
    func displayShow(task: Task)
}

protocol TaskViewCellDelegate: AnyObject {
    func didSetOn(from cell: TaskViewCell)
    func didSetOff(from cell: TaskViewCell)
}

class TaskViewCell: UITableViewCell {
    
    weak var delegate: TaskViewCellDelegate?
    var task = Task()
    
    @IBOutlet var imageTask: UIImageView!
    @IBOutlet var labelDateTime: UILabel!
    @IBOutlet var labelTitleTask: UILabel!
    @IBOutlet var completedButton: ToggleButton!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

//MARK: Extension: ToggleButtonDelegate, TaskViewCellProtocol
extension TaskViewCell: ToggleButtonDelegate, TaskViewCellProtocol {
    func displayShow(task: Task) {
        self.task = task
        completedButton.delegate = self
        labelTitleTask.text = task.name
        labelDateTime.text = takeDateTime(dateTime: task.createdDateTime)
        completedButton.on = task.isCompleted
        imageTask.image = getSavedImage(named: task.imageUrl)
    }

    func onTouched() {
        delegate?.didSetOn(from: self)
    }
    
    func offTouched() {
        delegate?.didSetOff(from: self)
    }
}

extension TaskViewCell: ImageGet {
    
    func getSavedImage(named: String) -> UIImage? {
        if let dir = try? FileManager.default.url(for: .documentDirectory,
                                                  in: .userDomainMask,
                                                  appropriateFor: nil,
                                                  create: false) {
            return UIImage(contentsOfFile: URL(fileURLWithPath: dir.absoluteString).appendingPathComponent(named).path)
        }
        return nil
    }
}
