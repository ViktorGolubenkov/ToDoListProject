//
//  StorageTableViewController.swift
//  To-DoList
//
//  Created by Viktor Golubenkov on 27.08.2020.
//  Copyright © 2020 Viktor Golubenkov. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications

class StorageTableViewController: UITableViewController, AddTaskDelegate {
   
    var tasks = [Task]()
    
    let dateFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = Task.fetchRequest() as NSFetchRequest<Task>
        // sort by Date(notifications):
        let sortDescriptor = NSSortDescriptor(key: "notification", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do {
            tasks = try context.fetch(fetchRequest)
            //tableView.reloadData()
        } catch let error {
            print("Error: \(error)")
        }
        // sort by title: "let sortDescriptor = NSSortDescriptor(key: "titleText", ascending: true)
        // sort by description: "let sortDescriptor = NSSortDescriptor(key: "descriptionText", ascending: true)
        //***********//  tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskCellIdentifier", for: indexPath)
        let task = tasks[indexPath.row]
        
        let titleText = task.titleText ?? ""
        let descriptionText = task.descriptionText ?? " "
        cell.textLabel?.text = titleText + " " + descriptionText

        if let date = task.notification as Date? {
            cell.detailTextLabel?.text = dateFormatter.string(from: date)
        } else {
            cell.detailTextLabel?.text = " "
        }
       
        return cell
    }

    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
        
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if tasks.count > indexPath.row {
            let task = tasks[indexPath.row]
            
            if let identifier = task.taskId {
                let center = UNUserNotificationCenter.current()
                center.removePendingNotificationRequests(withIdentifiers: [identifier])
            }
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
    
            context.delete(task)
            tasks.remove(at: indexPath.row)
            do {
                try context.save()
            } catch let error {
                print("Error: \(error)")
            }
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        }    
    


// MARK: - AddTaskDelegate (didAddTask task: Task)
    
    func addTaskViewController(_ addTaskViewController: AddTaskViewController, task: Task) {
        
        tasks.append(task)
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let navigationController = segue.destination as! UINavigationController
        let addTaskViewController = navigationController.topViewController as! AddTaskViewController
        addTaskViewController.delegate = self
    }


}
