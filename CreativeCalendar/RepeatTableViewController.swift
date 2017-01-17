//
//  RepeatTableViewController.swift
//  CreativeCalendar
//
//  Created by Wes Bosman on 1/16/17.
//  Copyright © 2017 Wes Bosman. All rights reserved.
//

import UIKit

class RepeatTableViewController: UITableViewController {
    let repeatArray = ["Never",
                       "Every Day",
                       "Every Week",
                       "Every Two Weeks",
                       "Every Month"]
    var repeatToPass: String?{
        didSet{
            if let selectedRepeat = repeatToPass{
                selectedRepeatIndex = repeatArray.index(of: selectedRepeat)!
            }
        }
    }
    var selectedRepeatIndex: Int?
    let repeatCellID = "RepeatCellID"

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.allowsMultipleSelection = false
        self.tableView.rowHeight = 60
        self.tableView.tableFooterView = UIView()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repeatArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: repeatCellID, for: indexPath)
        cell.textLabel?.text = repeatArray[indexPath.row]
        
        if selectedRepeatIndex == indexPath.row{
            cell.accessoryType = .checkmark
        }
        else{
            cell.accessoryType = .none
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let index = selectedRepeatIndex{
            let cell = tableView.cellForRow(at: IndexPath(row: index, section: 0))
            cell?.accessoryType = .none
            
        }
        
        repeatToPass = repeatArray[indexPath.row]
        print("Selected Repeat to Pass \(repeatToPass)")
        
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = .checkmark

    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "saveTaskRepeat"{
            print("Preparing for task repeat segue")
            if let cell = sender as? UITableViewCell{
                let indexPath = tableView.indexPath(for: cell)
                if let index = indexPath?.row{
                    repeatToPass = repeatArray[index]
                }
            }
            
        }
        else if segue.identifier == "saveAppointmentRepeat"{
            print("Preparing for appointment repeat segue")
            if let cell = sender as? UITableViewCell{
                let indexPath = tableView.indexPath(for: cell)
                if let index = indexPath?.row{
                    repeatToPass = repeatArray[index]
                }
            }
            
        }
    }
}
