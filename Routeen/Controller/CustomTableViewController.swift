//
//  CustomTableViewController.swift
//  Routeen
//
//  Created by Nils Backe on 6/14/18.
//  Copyright © 2018 Nils Backe. All rights reserved.
//

import UIKit
import CoreData

class CustomTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var addTaskTextField: UITextField!
    
 
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var items: [NSManagedObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView(frame: CGRect.zero)
    }
    
    @IBAction func addButtonTapped(_ sender: UIButton) {
        let entity = NSEntityDescription.entity(forEntityName: "Task", in: context)
       let  textFieldName = addTaskTextField.text!
        let managedObject = NSManagedObject(entity: (entity)!, insertInto: context)
        managedObject.setValue(textFieldName, forKey: "name")
    
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd"
        let today = formatter.string(from: date)
        
        managedObject.setValue(today, forKey: "date")
        managedObject.setValue(true, forKey:"completed" )
        
        do{
            try context.save()
            items.append(managedObject)
            
        }
        catch let err as NSError{
            print("failed to save an item", err)
        }
        
    
    }
    
  
//    func displayTask() {
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        let managerContext = appDelegate.persistentContainer.viewContext
//
//        let task = NSEntityDescription.insertNewObject(forEntityName: "Task", into: managerContext) as! Task
//        task.setValue(addTaskTextField.text!, forKey: "name")
//
//
//        let indexPath = IndexPath(row: tasks.count - 1, section: 0)
//        tableView.beginUpdates()
//        tableView.insertRows(at: [indexPath], with: .automatic)
//        tableView.endUpdates()
//        self.tasks.append(addTaskTextField.text!)
//
//        addTaskTextField.text = ""
//        do{
//            try managerContext.save()
//            print("saved")
//        }catch let error as NSError{
//            //errore salvataggio
//            print("Could not fetch \(error), \(error.userInfo) as Any")
//        }
//        view.endEditing(true)
//    }
//
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell") as! CustomTableViewCell
        let item = items[indexPath.row]
        cell.textLabel?.text = item.value(forKey: "name") as! String
       
    
        return cell
        
        
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            items.remove(at: indexPath.row)
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.endUpdates()
        }
        
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
