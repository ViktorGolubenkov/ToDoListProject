//
//  AddTaskViewController.swift
//  To-DoList
//
//  Created by Viktor Golubenkov on 25.08.2020.
//  Copyright © 2020 Viktor Golubenkov. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications
// 1 
protocol AddTaskDelegate {
    func addTaskViewController(_ addTaskViewController: AddTaskViewController, task: Task)
}

class AddTaskViewController: UIViewController {
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var notificationPicker: UIDatePicker!
    // 2
    var delegate: AddTaskDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let borderColor: UIColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0)
        
        titleTextField.layer.borderWidth = 1.0
        titleTextField.layer.borderColor = borderColor.cgColor
        titleTextField.layer.cornerRadius = 5.0
        
        
        descriptionTextView.layer.borderWidth = 1.0
        descriptionTextView.layer.borderColor = borderColor.cgColor
        descriptionTextView.layer.cornerRadius = 5.0
        
        notificationPicker.minimumDate = Date()
    }

    @IBAction func saveTapped(_ sender: UIBarButtonItem) {
        print("Save button pressed!")
        
        let titleText = titleTextField.text ?? ""
        let descriptionText = descriptionTextView.text ?? " "
        let notification = notificationPicker.date

        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
    
        let newTask = Task(context: context)
        // 3
        delegate?.addTaskViewController(self, task: newTask)
        //-/
        newTask.titleText = titleText
        newTask.descriptionText = descriptionText
        newTask.notification = notification as Date?
        newTask.taskId = UUID().uuidString
        
        if let uniqueId = newTask.taskId {
            print("TaskID: \(uniqueId)")
        }
        
        do {
            try context.save()
            let message = "Time for \(titleText)"
            let content = UNMutableNotificationContent()
            content.body = message
            content.sound = UNNotificationSound.default
            
            
            var dateComponents = Calendar.current.dateComponents([.minute, .hour, .day], from: notification)
            dateComponents.hour = .none
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
            if let identifier = newTask.taskId {
                let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
                let center = UNUserNotificationCenter.current()
                center.add(request, withCompletionHandler: nil)
                
            }
        } catch let error {
            print("Error \(error)")
        }
        
        dismiss(animated: true, completion: nil)
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "update"), object: nil, userInfo: nil)
        
    }
    
    @IBAction func cancelTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    

    
}

