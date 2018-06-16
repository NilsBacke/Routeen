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
    
    var tasks = ["Brush teeth", "Wash face", "Get Groceries", "Pickup Dog", "Shower", "Do Homework", "Schedule Meeting", "Eat"]
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "cell")
        cell.textLabel?.text = tasks[indexPath.row]
        cell.layer.cornerRadius = 10
        cell.layer.masksToBounds = true
        return cell
        

    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationController?.navigationBar.topItem?.title = "Routeen"
        self
    }
 
}

