//
//  TasksViewController.swift
//  ToDo
//
//  Created by Rusell on 06.02.2021.
//

import UIKit

class DetailTaskViewController: UIViewController {
    let storageService: StorageServiceProtocol = StorageService()
    
    var taskName: String?
    var taskNotes: String?
    var taskId: String?
    var taskImageName: String?
    
    var imagePicker = UIImagePickerController()
    
    @IBOutlet weak var taskImageView: UIImageView!
    @IBOutlet weak var taskTextFieldTask: UITextField!
    @IBOutlet weak var taskTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        setupNavBar()
        setupUI()
        taskTextView.layer.cornerRadius = 10
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.storageService.changedTaskData(id: taskId,
                                            name: taskTextFieldTask.text,
                                            notes: taskTextView.text,
                                            imageUrl: taskImageName)
    }
    
    @IBAction func pressedOnChooseImageButton(_ sender: Any) {
        showActionAlertChooseImageForTask()
    }
    
    @IBAction func didTapOnBack(_ sender: Any) {
        self.storageService.changedTaskData(id: taskId,
                                            name: taskTextFieldTask.text,
                                            notes: taskTextView.text,
                                            imageUrl: taskImageName)
    }
    
    @objc func tapGesture() {
        showActionAlertChooseImageForTask()
    }
    
    private func openUIImagePickerController(_ sourceType: UIImagePickerController.SourceType) {
        imagePicker.sourceType = sourceType
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    private func deleteImageInTask() {
        taskImageView.image = nil
        taskImageName = nil
    }
    
    private func setupNavBar() {
        title = Description.NavBar.titleDetailed
    }
    
    private func setupUI() {
        taskTextFieldTask.text = taskName
        taskTextView.text = taskNotes
        taskImageView.image = getSavedImage(named: taskImageName ?? "")
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self,
                                                         action: #selector(handleTap(_:))))
    }
    
    private func saveImage(image: UIImage, nameImage: String) -> Bool {
        guard let data = image.jpegData(compressionQuality: 1) ?? image.pngData() else {
            return false
        }
        
        guard let directory = try? FileManager.default.url(for: .documentDirectory,
                                                           in: .userDomainMask,
                                                           appropriateFor: nil,
                                                           create: false) as NSURL else {
            return false
        }
        
        do {
            try data.write(to: directory.appendingPathComponent(nameImage)!)
            return true
        } catch {
            print(error.localizedDescription)
            return false
        }
    }
    
    private func getSavedImage(named: String) -> UIImage? {
        if let dir = try? FileManager.default.url(for: .documentDirectory,
                                                  in: .userDomainMask,
                                                  appropriateFor: nil,
                                                  create: false) {
            return UIImage(contentsOfFile: URL(fileURLWithPath: dir.absoluteString).appendingPathComponent(named).path)
        }
        return nil
    }
    
}

//MARK: UINavigationControllerDelegate, UIImagePickerControllerDelegate
extension DetailTaskViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    internal func showActionAlertChooseImageForTask() {
        let alert = AlertController(title: nil, message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        let galleryAction = UIAlertAction(title: Description.Alert.changeImage,
                                          style: UIAlertAction.Style.default) {
            UIAlertAction in
            self.openUIImagePickerController(UIImagePickerController.SourceType.photoLibrary)
        }
        let deleteAction = UIAlertAction(title:  Description.Alert.removeImage,
                                         style: UIAlertAction.Style.default) {
            UIAlertAction in
            self.deleteImageInTask()
        }
        let cancelAction = UIAlertAction(title:  Description.Alert.cancel,
                                         style: .default, handler: nil)
        
        imagePicker.delegate = self as UIImagePickerControllerDelegate & UINavigationControllerDelegate
        alert.buttonBackgroundColor = UIColor.appColor(.viewAlert)
        alert.addAction(galleryAction)
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func imagePickerController(_ picker: UIImagePickerController,
                                     didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage,
              let imgUrl = info[UIImagePickerController.InfoKey.imageURL] as? URL else { return }
        DispatchQueue.main.async {
            self.taskImageView.contentMode = .scaleAspectFit
            self.taskImageView.image = pickedImage
        
        
            if self.saveImage(image: self.taskImageView.image!, nameImage: imgUrl.lastPathComponent) {
                self.taskImageName = imgUrl.lastPathComponent
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
}

extension DetailTaskViewController: UITextFieldDelegate, UITextViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        taskTextView.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @objc private func handleTap(_ gesture: UITapGestureRecognizer) {
        view.endEditing(true)
    }
}
