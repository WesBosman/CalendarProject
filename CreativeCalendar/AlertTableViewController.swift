//
//  AlertTableViewController.swift
//  CreativeCalendar
//
//  Created by Wes Bosman on 1/16/17.
//  Copyright © 2017 Wes Bosman. All rights reserved.
//

import UIKit

class AlertTableViewController: UITableViewController {
    let alertArray = ["At Time of Event",
                      "5 Minutes Before",
                      "15 Minutes Before",
                      "30 Minutes Before",
                      "1 Hour Before"]
    var alertToPass: String?{
        didSet{
            if let alert = alertToPass{
                selectedAlertIndex = alertArray.index(of: alert)!
            }
        }
    }
    var selectedAlertIndex: Int?
    let alertIdentifier = "AlertCellID"

    override func viewDidLoad() {
        super.viewDidLoad()

        // Select the first item in the alert array this is the default
        self.tableView.allowsMultipleSelection = false
        
//        let saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(AlertTableViewController.goBack))
//        self.navigationItem.rightBarButtonItem = saveButton

    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return alertArray.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: alertIdentifier, for: indexPath)
        cell.textLabel?.text = alertArray[indexPath.row]
        
        if selectedAlertIndex == indexPath.row{
            cell.accessoryType = .checkmark
        }
        else{
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        // Selecting another row so deselect this one
        if let index = selectedAlertIndex{
            let cell = tableView.cellForRow(at: IndexPath(row: index, section: 0))
            cell?.accessoryType = .none
        }
        
        alertToPass = alertArray[indexPath.row]
        print("Selected String to pass -> \(alertToPass)")

        // Update the checkmark
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = .checkmark
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        
        // Pass the selected object to the new view controller.
        if segue.identifier == "saveTaskAlert"{
            print("Preparing for save task alert segue")
            if let cell = sender as? UITableViewCell{
                let indexPath = tableView.indexPath(for: cell)
                if let index = indexPath?.row{
                    alertToPass = alertArray[index]
                }
            }
        }
        else if segue.identifier == "saveAppointmentAlert"{
            print("Preparing for appointment alert segue")
            if let cell = sender as? UITableViewCell{
                let indexPath = tableView.indexPath(for: cell)
                if let index = indexPath?.row{
                    alertToPass = alertArray[index]
                }
            }
        }
    }
}
