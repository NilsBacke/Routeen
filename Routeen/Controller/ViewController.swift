//
//  ViewController.swift
//  Routeen
//
//  Created by Nils Backe on 6/9/18.
//  Copyright © 2018 Nils Backe. All rights reserved.
//

import UIKit
import SCLAlertView

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var streakLabel: UILabel!
    
    var streaks:[Streak] = []
    var tasks:[Task] = []
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tasks = CoreDataHandler.fetchTask()
        streaks = CoreDataHandler.fetchStreak()
        tableView.reloadData()
        print("appear")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        print("load")
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationController?.navigationBar.topItem?.title = "Routeen"
        tasks = CoreDataHandler.fetchTask()
        streaks = CoreDataHandler.fetchStreak()
        let today:Int = Int(getToday())! - 1
        if streaks.count == 0 {
            if CoreDataHandler.saveStreak(streak: 0, dateLastCompleted: String(today)) {
                print("streak saved")
            }
        }
        calculateStreak()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! CustomHomeScreenTableViewCell
        
        cell.layer.cornerRadius = 10
        cell.layer.masksToBounds = true
        
        let task = tasks[indexPath.row]
        cell.taskName.text = task.name
        if task.isCompleted {
            cell.isCompleted.text = "Completed"
            cell.layer.borderWidth = 2.0
            cell.layer.cornerRadius = 8
            cell.layer.borderColor = UIColor.blue.cgColor
        } else {
            cell.isCompleted.text = "Not Completed"
            cell.layer.borderWidth = 0
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("\(indexPath.row)")
        if CoreDataHandler.completeTask(task: tasks[indexPath.row]) {
            print("altered")
        }
        tasks = CoreDataHandler.fetchTask()
        tableView.reloadData()
        calculateStreak()
        print("\(tasks)")
    }
    
    func calculateStreak() {
        let today = getToday()
        streaks = CoreDataHandler.fetchStreak()
        // check for all completed
        var allCompleted = true;
        for task in tasks {
            if (!task.isCompleted) {
                allCompleted = false;
            }
        }
        if (allCompleted == true && !tasks.isEmpty && streaks.count > 0 && streaks[0].dateLastCompleted != today) {
            
            let currentStreak = streaks[0].streak
            if CoreDataHandler.alterStreak(streak: Int(Int16(currentStreak + 1)), dateLastCompleted: today) {
                print("streak altered")
            }
            // clear table and congratulate
            tasks.removeAll()
            tableView.reloadData()
            showAlertView();
        }
        
        
        // check for loss of streak
        for task in tasks {
            let dayDifference = Int(today)! - Int(task.date!)!
            // will not work if today is a new month
            // fix:
            // include month in the dateFormatter
            // if the two months are not equal
            // switch statement for how many days are in certain months
            if (dayDifference > 1) {
                if CoreDataHandler.alterStreak(streak: 0, dateLastCompleted: today) {
                    print("reset")
                }
            }
        }
        
        streaks = CoreDataHandler.fetchStreak()
        if streaks.count != 0 {
            streakLabel.text = String(streaks[0].streak)
        }
        print("\(streaks)")
    }
    
    func getToday() -> String {
        // get date
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd"
        return formatter.string(from: date)
    }
    
    func showAlertView() {
        SCLAlertView().showTitle("Congratulations!", subTitle: "You have completed all of today's tasks. Come back tomorrow to continue your streak.", style: .success, closeButtonTitle: "Done", colorStyle: 0x1dcaff)
    }
 
}

