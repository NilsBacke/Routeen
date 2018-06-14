//
//  ViewController.swift
//  Routeen
//
//  Created by Nils Backe on 6/9/18.
//  Copyright © 2018 Nils Backe. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var tasks = ["Brush teeth", "Wash face", "Get Groceries", "Pickup Dog", "Shower", "Do Homework", "Schedule Meeting", "Eat"]
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "cell")
        cell.textLabel?.text = tasks[indexPath.row]
        return cell
        
//        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "cell")
//        let task = tasks[indexPath.row]
//        cell.taskTitleLabel.text = task.title
//        return cell
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
 
}

