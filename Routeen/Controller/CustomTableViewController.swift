//
//  CustomTableViewController.swift
//  Routeen
//
//  Created by Nils Backe on 6/14/18.
//  Copyright © 2018 Nils Backe. All rights reserved.
//

import UIKit

class CustomTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addTaskTextField: UITextField!
    
    var tasks:[Task] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        self.addTaskTextField.delegate = self
        
        tasks = CoreDataHandler.fetchObject()
    }
    
    @IBAction func addButtonTapped(_ sender: UIButton) {
        
      addButton()
        
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell") as! CustomTableViewCell
        let task = tasks[indexPath.row]
        cell.taskName.text = task.name
    
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if CoreDataHandler.deleteObject(task: tasks[indexPath.row]) {
                print("deleted")
            }
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tasks = CoreDataHandler.fetchObject()
            tableView.endUpdates()
        }

    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        addTaskTextField.resignFirstResponder()
        addButton()
        return true
    }
    
    
    func addButton() {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd"
        let today = formatter.string(from: date)
        
        let indexPath = IndexPath(row: tasks.count, section: 0)
        tableView.beginUpdates()
        
        if CoreDataHandler.saveObject(name: addTaskTextField.text!, date: today, isCompleted: false) {
            print("Saved \(addTaskTextField.text!)")
        }
        self.tasks = CoreDataHandler.fetchObject()
        tableView.insertRows(at: [indexPath], with: .automatic)
        tableView.endUpdates()
        print("\(tasks)")
        
        
        addTaskTextField.text = ""
        
    }


}
