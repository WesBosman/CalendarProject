//
//  TaskViewController.swift
//  CreativeCalendar
//
//  Created by student on 1/27/16.
//  Copyright (c) 2016 Wes Bosman. All rights reserved.
//

import UIKit

class TaskViewController: UIViewController {

    @IBOutlet weak var toDoLabel: UILabel!
    @IBOutlet weak var toDoListContainer: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        toDoLabel.text = "To-Do List"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

