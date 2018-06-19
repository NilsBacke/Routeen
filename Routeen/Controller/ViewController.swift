//
//  ViewController.swift
//  Routeen
//
//  Created by Nils Backe on 6/9/18.
//  Copyright © 2018 Nils Backe. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var streakLabel: UILabel!
    
    var streak = 0;
    var tasks:[Task] = []
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tasks = CoreDataHandler.fetchObject()
        tableView.reloadData()
        print("appear")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        print("load")
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationController?.navigationBar.topItem?.title = "Routeen"
        tasks = CoreDataHandler.fetchObject()
        
        calculateStreak()
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "cell")
        cell.textLabel?.text = tasks[indexPath.row].name
        cell.layer.cornerRadius = 10
        cell.layer.masksToBounds = true
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("\(indexPath.row)")
    }
    
    func calculateStreak() {
        // check for all completed
        var allCompleted = true;
        for task in tasks {
            if (!task.isCompleted) {
                allCompleted = false;
            }
        }
        if (allCompleted == true && !tasks.isEmpty) {
            streak += 1;
            // lock checkboxes and congratulate
        }
        
        // get date
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd"
        let today = formatter.string(from: date)
        
        // check for loss of streak
        for task in tasks {
            let dayDifference = Int(today)! - Int(task.date!)!
            // will not work if today is a new month
            // fix:
            // include month in the dateFormatter
            // if the two months are not equal
            // switch statement for how many days are in certain months
            if (dayDifference > 1) {
                streak = 0;
            }
        }
        
        
        streakLabel.text = String(streak)
    }
 
}

