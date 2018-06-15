//
//  CustomTableViewController.swift
//  Routeen
//
//  Created by Nils Backe on 6/14/18.
//  Copyright © 2018 Nils Backe. All rights reserved.
//

import UIKit

class CustomTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var addTaskTextField: UITextField!
    
    var tasks = ["Brush teeth", "Wash face", "Get Groceries", "Pickup Dog", "Shower", "Do Homework", "Schedule Meeting", "Eat"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView(frame: CGRect.zero)
    }
    
    @IBAction func addButtonTapped(_ sender: UIButton) {
        insertNewTask()
    }
    
    func insertNewTask() {
        tasks.append(addTaskTextField.text!)
        let indexPath = IndexPath(row: tasks.count - 1, section: 0)
        tableView.beginUpdates()
        tableView.insertRows(at: [indexPath], with: .automatic)
        tableView.endUpdates()
        
        addTaskTextField.text = ""
        view.endEditing(true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell") as! CustomTableViewCell
        cell.taskName.text = tasks[indexPath.row]
        cell.cellView.layer.cornerRadius = 10
        cell.cellView.layer.masksToBounds = true
        return cell
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
