//
//  ViewController.swift
//  Routeen
//
//  Created by Nils Backe on 6/9/18.
//  Copyright © 2018 Nils Backe. All rights reserved.
//

import UIKit
import SCLAlertView

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var streakLabel: UILabel!
    @IBOutlet weak var keepItUp: UILabel!
    
    var streaks:[Streak] = []
    var tasks:[Task] = []
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("appear")
        streaks = CoreDataHandler.fetchStreak()
        if streaks.count > 0 && getToday() != streaks[0].dateLastCompleted {
            keepItUp.text = "Keep It Up!"
        } else {
            tasks.removeAll()
        }
        
        resetTasks()
        calculateStreak()
        
        print("\(tasks)")
        tableView.reloadData()
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
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("for row at")
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! CustomHomeScreenTableViewCell
        
        cell.layer.cornerRadius = 10
        cell.layer.masksToBounds = true
        
        let task = tasks[indexPath.row]
        cell.taskName.text = task.name
        if task.isCompleted {
            cell.isCompleted.text = "Completed"
            cell.isCompleted.textAlignment = .center
            cell.isCompleted.textColor = UIColor.green
            cell.layer.borderWidth = 2.0
            cell.layer.cornerRadius = 8
            cell.layer.borderColor = UIColor.blue.cgColor
        } else {
            cell.isCompleted.text = "Not Completed"
            cell.isCompleted.textColor = UIColor.red
            cell.layer.borderWidth = 0
        }
        print("\(cell)")
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
    }
    
    func calculateStreak() {
        print("calc")
        let today = getToday()
        streaks = CoreDataHandler.fetchStreak()
        
        print("Today: \(today)")
        
        // check for all completed
        let allCompleted = getAllCompleted()
        if (allCompleted == true && !tasks.isEmpty && streaks.count > 0) {
            if streaks[0].dateLastCompleted != today {
                let currentStreak = streaks[0].streak
                print("current streak: \(currentStreak)")
                if CoreDataHandler.alterStreak(streakObj: streaks[0], streak: Int(Int16(currentStreak + 1)), dateLastCompleted: today) {
                    streaks = CoreDataHandler.fetchStreak()
                    print("streak altered")
                    print("after fetch: \(streaks)")
                }
            }
            // clear table and congratulate
            showAlertView();
            tasks.removeAll()
            tableView.reloadData()
            keepItUp.text = "Come Back Tomorrow!"
        }
        
        
        // check for loss of streak
        streaks = CoreDataHandler.fetchStreak()
        for task in tasks {
            let dayDifference = Int(today)! - Int(task.date!)!
            // will not work if today is a new month
            // fix:
            // include month in the dateFormatter
            // if the two months are not equal
            // switch statement for how many days are in certain months
            
            // lost streak
            if (dayDifference > 1 && streaks[0].streak != 0) {
                showLossAlertView()
                if CoreDataHandler.alterStreak(streakObj: streaks[0], streak: 0, dateLastCompleted: today) {
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
    
    func resetTasks() {
        tasks = CoreDataHandler.fetchTask()
        if getAllCompleted() && getToday() != streaks[0].dateLastCompleted {
            if CoreDataHandler.completeAllTasks() {
                print("completed all")
            }
            tasks = CoreDataHandler.fetchTask()
        } else if getAllCompleted() {
            tasks.removeAll()
        }
        tableView.reloadData()
    }
    
    func getAllCompleted() -> Bool {
        let tasks = CoreDataHandler.fetchTask()
        var allCompleted = true;
        for task in tasks {
            if (!task.isCompleted) {
                allCompleted = false;
            }
        }
        return allCompleted
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
    
    func showLossAlertView() {
        SCLAlertView().showTitle("Sorry, you lost your streak.", subTitle: "Start up another one!", style: .warning, closeButtonTitle: "Close", colorStyle: 0x1dcaff)
    }
 
}

