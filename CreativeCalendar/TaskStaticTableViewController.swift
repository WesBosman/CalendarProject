//
//  TaskStaticTableViewController.swift
//  CreativeCalendar
//
//  Created by Wes on 5/14/16.
//  Copyright (c) 2016 Wes Bosman. All rights reserved.
//

import UIKit

class TaskStaticTableViewController: UITableViewController {
    
    @IBOutlet weak var taskNameTextField: UITextField!
    @IBOutlet weak var taskAdditionalInfoTextBox: UITextField!
    let db = DatabaseFunctions.sharedInstance

    override func viewDidLoad() {
        super.viewDidLoad()
        taskNameTextField.placeholder = "Task Name"
        taskAdditionalInfoTextBox.placeholder = "Additional Information"
    }
    
    // Save the information to pass it to the previous view
    @IBAction func saveTaskPressed(sender: AnyObject) {
        // Make sure there is atleast a task title in order to let the user save the task
        let current = NSDate()
        let dateFormat = NSDateFormatter()
        dateFormat.dateFormat = "EEEE MM/dd/yyyy hh:mm:ss a"
        let dateString = dateFormat.stringFromDate(current)
        
        if (!taskNameTextField.text!.isEmpty){
            let taskItem = TaskItem(dateMade: dateString,
                                    title: taskNameTextField.text!,
                                    info: taskAdditionalInfoTextBox.text!,
                                    completed: false,
                                    dateFinished: nil,
                                    UUID: NSUUID().UUIDString)
            
                        
            // add the task to the database.            
            if !(taskAdditionalInfoTextBox.text! == "Additional Information") {
                db.addToTaskDatabase(taskItem)
            }
            else{
                let newTaskItem = TaskItem(dateMade: dateString,
                                           title: taskItem.taskTitle,
                                           info: "",
                                           completed: false,
                                           dateFinished: nil,
                                           UUID: taskItem.UUID)
                db.addToTaskDatabase(newTaskItem)
            }
            
            self.navigationController?.popToRootViewControllerAnimated(true)
        }
        else{
            // This is similar to the code for the static appointment alert.
            let someFieldMissing = UIAlertController(title: "Missing Task Title", message: "One or more of the reqired fields marked with an asterisk has not been filled in", preferredStyle: .Alert)
            someFieldMissing.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { (UIAlertAction) in
                // Essentially do nothing. Unless we want to print some sort of log message.
            }))
            self.presentViewController(someFieldMissing, animated: true, completion: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
