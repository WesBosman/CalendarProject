//
//  AppointmentTableViewController.swift
//  CreativeCalendar
//
//  Created by Wes on 2/12/16.
//  Followed a source code example on github for an accordian menu.
//  Copyright (c) 2016 Wes Bosman. All rights reserved.

import UIKit

class AppointmentTableViewController: UITableViewController{
    
    fileprivate let cellID = "AppointmentCells"
    fileprivate var appointmentList:[AppointmentItem] = GlobalAppointments.appointmentItems
    fileprivate var selectedIndexPath: IndexPath?
    fileprivate let db = DatabaseFunctions.sharedInstance
    fileprivate var appointmentDaySections: Dictionary<String, [AppointmentItem]> = GlobalAppointments.appointmentDictionary
    fileprivate let appointmentDateFormatter = DateFormatter().dateWithoutTime
    fileprivate var appointmentSections: [String] = GlobalAppointments.appointmentSections
    fileprivate let defaults = UserDefaults.standard
    weak var actionToEnable:UIAlertAction?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = editButtonItem
        let nav = self.navigationController?.navigationBar
        let barColor = UIColor().navigationBarColor
        nav?.barTintColor = barColor
        nav?.tintColor = UIColor.blue
        NotificationCenter.default
            .addObserver(self, selector: #selector(AppointmentTableViewController.refreshList), name: NSNotification.Name(rawValue: "AppointmentListShouldRefresh"), object: nil)
        tableView.allowsSelection = false
        
    }
    
    // Failable Initializer for tab bar controller
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // Initialize Tab Bar Item
        tabBarItem = UITabBarItem(title: "Appointments", image: UIImage(named: "Appointment"), tag: 2)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshList()
    }
    
    // Refresh the list do not let more than 64 notifications on screen at any one time.
    func refreshList(){
        
        // Get all appointments that are not marked as deleted.
        appointmentList = db.getAllAppointments()
        
        // Order the appointments based on their starting times.
        appointmentList = appointmentList.sorted(by: {$0.startingTime.compare($1.startingTime as Date) == ComparisonResult.orderedAscending})
        
        for app in appointmentList{
            // Get the date from the appointment
            let appointmentDateForSectionAsString = appointmentDateFormatter.string(from: app.startingTime)
            
            // If the appointment Date is not already in the appointment sections array add it
            if !appointmentSections.contains(appointmentDateForSectionAsString){
                appointmentSections.append(appointmentDateForSectionAsString)
            }
        }
        
        // Use the appointment sections array to get items from the database
        for str in appointmentSections{
            appointmentList = db.getAppointmentByDate(str, formatter: appointmentDateFormatter)
            
            // Add those items to the dictionary that the table view relies on
            appointmentDaySections.updateValue(appointmentList, forKey: str)
            
            // Set the global dictionary up
            GlobalAppointments.appointmentDictionary = appointmentDaySections
            
//            defaults.setObject(appointmentList as? AnyObject, forKey: str)
        }
        
        // If there are more than 64 appointments today do not let the user add more appointments
        if appointmentList.count > 64{
            self.navigationItem.rightBarButtonItem?.isEnabled = false
        }
        
        // This sets the bage number back to zero when the view loads.
        self.tabBarController!.tabBar.items?[1].badgeValue = nil
        
        tableView.reloadData()
    }

    // MARK Section Header Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appointmentDaySections[appointmentSections[section]]!.count
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return appointmentDaySections.keys.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        // Return the section title as a date
        if !appointmentSections[section].isEmpty{
            return appointmentSections[section]
        }
        return nil
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if tableView.dataSource?.tableView(tableView, numberOfRowsInSection: section) == 0{
            return 0.0
        }
        else{
            return 30.0
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if tableView.dataSource?.tableView(tableView, numberOfRowsInSection: section) == 0{
            return nil
        }
        else{
            return tableView.headerView(forSection: section)
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        header.contentView.backgroundColor = UIColor().defaultButtonColor
        header.textLabel?.textColor = UIColor.white
    }
    
    // Make a cell where the title and the start date are retrieved from the save button being pressed
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // The cell is a custom appointment cell that we have created.
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! AppointmentCell
        let tableSection = appointmentDaySections[appointmentSections[(indexPath as NSIndexPath).section]]
        let appItem = tableSection![(indexPath as NSIndexPath).row]
        
        // If the current time is later than the starting time of the appointment then the color is set to red.
        if (appItem.isOverdue) {
            cell.appointmentStart.textColor = UIColor.red
        }
        // If its not true that the event has happened the text should be black
        else {
            cell.appointmentStart.textColor = UIColor.black
        }
        
        let startFormatter = DateFormatter()
        let endFormatter = DateFormatter()
        startFormatter.dateFormat = "'Starting Time: ' MMM dd 'at' h:mm a"
        endFormatter.dateFormat = "'Ending Time:  ' MMM dd 'at' h:mm a"
        let startingTime = startFormatter.string(from: appItem.startingTime as Date)
        let endingTime = endFormatter.string(from: appItem.endingTime as Date)
        
        cell.appointmentCompleted(appItem)
        cell.appointmentTitle.text = "Event: \(appItem.title)"
        cell.appointmentType.text = "Type: \(appItem.type)"
        cell.appointmentStart.text = startingTime
        cell.appointmentEnd.text = endingTime
        cell.appointmentLocation.text = "Location: \(appItem.appLocation)"
        cell.appointmentAdditionalInfo.text = "Additional Info: \(appItem.additionalInfo)"
        cell.appointmentAlert.text = "Alert: \(appItem.alert)"
        
        return cell
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    
    override func tableView(_ tableView: UITableView, didEndEditingRowAt indexPath: IndexPath?) {
        tableView.reloadData()
    }
    
    // These are custom actions for dealing with the editing of an appointment
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let appointmentCellForAction = tableView.cellForRow(at: indexPath) as! AppointmentCell
        let tableSection = appointmentDaySections[appointmentSections[(indexPath as NSIndexPath).section]]
        var appointmentForAction = tableSection![(indexPath as NSIndexPath).row] as AppointmentItem
        let exitMenu = UIAlertAction(title: "Exit Menu", style: .cancel, handler: nil)
        
        // Make custom actions for delete, cancel and complete.
        let deletedAction = UITableViewRowAction(style: .default, title: "Delete", handler: {(action:UITableViewRowAction!, indexPath: IndexPath!) -> Void in
            
            let deleteOptions = UIAlertController(title: "Delete", message: "Are you sure you want to delete the appointment: \(appointmentForAction.title)?", preferredStyle: .alert)
            deleteOptions.addTextField(configurationHandler: {(textField) in
                textField.placeholder = "Reason for Delete"
                textField.addTarget(self, action: #selector(self.textChanged(_:)), for: .editingChanged)
            })
            
            let deleteAppointment = UIAlertAction(title: "Delete Appointment", style: .destructive, handler: {(action: UIAlertAction) -> Void in
                
                // Present an option to delete either only that appointment or all appointments of that type
                let deleteAllAppointmentController = UIAlertController(title: "Delete", message: "Would you like to delete all of the corresponding appointments of this type with this title?", preferredStyle: .alert)
                
                let yesAction = UIAlertAction(title: "Delete All Appointments", style: .destructive, handler: {(action: UIAlertAction) -> Void in
                    
                    print("Delete All Appointments")
                    
                    let confirmationController = UIAlertController(title: "Delete Confirmation", message: "Are you sure you want to delete this appointment?", preferredStyle: .alert)
                    let yesConfirmation = UIAlertAction(title: "Yes", style: .destructive, handler: {(action: UIAlertAction) -> Void in
                        // Get all elements with the same title and type
                        for key in self.appointmentDaySections.keys{
                            // Get the section key
                            if let k = self.appointmentDaySections[key]{
                                // Get the appointment based on the key
                                for app in k{
                                    // If the appointment title is equal to the one we are deleting
                                    // Then remove it
                                    if app.title == appointmentForAction.title
                                        && app.type == appointmentForAction.type
                                        && app.appLocation == appointmentForAction.appLocation
                                        && app.additionalInfo == appointmentForAction.additionalInfo{
                                        
                                        if let index = k.index(where: {$0.title == appointmentForAction.title}){
                                            self.appointmentDaySections[key]?.remove(at: index)
                                            
                                        }
                                    }
                                }
                            }
                        }
                        appointmentForAction.deleted = true
                        appointmentForAction.deletedReason = deleteOptions.textFields![0].text ?? ""
                        self.db.removeAllAppointmentsOfSameType(appointmentForAction, option: "delete")
                        self.tableView.reloadData()
                    })
                    let noConfirmation = UIAlertAction(title: "No", style: .cancel, handler: nil)

                    confirmationController.addAction(yesConfirmation)
                    confirmationController.addAction(noConfirmation)
                    self.present(confirmationController, animated: true, completion: nil)
                    
                    })
                
                let noAction = UIAlertAction(title: "Delete This Appointment", style: .destructive, handler: {(action: UIAlertAction) -> Void in
                    
                    let confirmationController = UIAlertController(title: "Delete Confirmation", message: "Delete only this appointment with title \(appointmentForAction.title)", preferredStyle: .alert)
                    let yesConfirmation = UIAlertAction(title: "Yes", style: .destructive, handler: {(action: UIAlertAction) -> Void in
                        
                        // Delete the row from the data source
                        let key = self.appointmentSections[indexPath.section]
                        print("Key for removal: \(key)")
                        self.appointmentDaySections[key]?.remove(at: indexPath.row)
                        tableView.deleteRows(at: [indexPath], with: .fade)
                        
                        //Delete from database
                        appointmentForAction.completed = false
                        appointmentForAction.canceled = false
                        appointmentForAction.deleted = true
                        appointmentForAction.deletedReason = deleteOptions.textFields![0].text ?? ""
                        self.db.updateAppointment(appointmentForAction)
                        
                    })
                    
                    let noConfirmation = UIAlertAction(title: "No", style: .cancel, handler: nil)
                    
                    confirmationController.addAction(yesConfirmation)
                    confirmationController.addAction(noConfirmation)
                    self.present(confirmationController, animated: true, completion: nil)
                    
                    })
                
                let exitAction = UIAlertAction(title: "Exit Menu", style: .cancel, handler: nil)
                
                deleteAllAppointmentController.addAction(noAction)
                deleteAllAppointmentController.addAction(yesAction)
                deleteAllAppointmentController.addAction(exitAction)
                self.present(deleteAllAppointmentController, animated: true, completion: nil)
                
            })
            self.actionToEnable = deleteAppointment
            deleteAppointment.isEnabled = false
            deleteOptions.addAction(deleteAppointment)
//            deleteOptions.addAction(deleteAllAppointments)
            deleteOptions.addAction(exitMenu)
            
            self.present(deleteOptions, animated: true, completion: nil)
        })
        
        
        let canceledAction = UITableViewRowAction(style: .default, title: "Cancel", handler: {(action:UITableViewRowAction!, indexPath: IndexPath!) -> Void in
            let cancelOptions = UIAlertController(title: "Cancel Appointment", message: "Would you like to cancel the appointment: \(appointmentForAction.title)", preferredStyle: .alert)
            
            cancelOptions.addTextField(configurationHandler: {(textField) in
                textField.placeholder = "Reason for Cancel"
                textField.addTarget(self, action: #selector(self.textChanged(_:)), for: .editingChanged)
            })
            
            // Appointment was canceled.
            let cancelAppointment = UIAlertAction(title: "Cancel Appointment", style: .destructive, handler: {(action: UIAlertAction) -> Void in
                
                // Cancel Appointment 
                appointmentForAction.completed = false
                appointmentForAction.canceled = true
                appointmentForAction.deleted = false
                appointmentForAction.canceledReason = cancelOptions.textFields![0].text ?? ""
                appointmentCellForAction.appointmentCompleted(appointmentForAction)
                self.db.updateAppointment(appointmentForAction)
                
            })
            self.actionToEnable = cancelAppointment
            cancelAppointment.isEnabled = false
            cancelOptions.addAction(cancelAppointment)
            cancelOptions.addAction(exitMenu)
            
            self.present(cancelOptions, animated: true, completion: nil)
        })
        
        
        let completedAction = UITableViewRowAction(style: .default, title: "Complete", handler: {(action:UITableViewRowAction!, indexPath: IndexPath!) -> Void in
            
            let completeOptions = UIAlertController(title: "Complete Appointment", message: "Have you completed appointment: \(appointmentForAction.title)", preferredStyle: .alert)
            
            // Appointment was completed.
            let completeAction = UIAlertAction(title: "Complete Appointment", style: .destructive, handler: {(action: UIAlertAction) -> Void in
                
                // Complete the appointment and update its image.
                appointmentForAction.completed = true
                appointmentForAction.canceled = false
                appointmentForAction.deleted = false
                appointmentCellForAction.appointmentCompleted(appointmentForAction)
                self.db.updateAppointment(appointmentForAction)
                
            })
            let completeCanceled = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            
            completeOptions.addAction(completeAction)
            completeOptions.addAction(completeCanceled)
                        
            self.present(completeOptions, animated: true, completion: nil)
        })
        
        completedAction.backgroundColor = UIColor.blue
        canceledAction.backgroundColor = UIColor.orange
        
        return [deletedAction, canceledAction, completedAction]
    
    }
    
    func textChanged(_ sender:UITextField) {
        self.actionToEnable?.isEnabled = (sender.text!.isEmpty == false)
    }

    
    // MARK: - Navigation
    /*
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the Home View.
        
        if segue.identifier == "Home"{
            let view = segue.destinationViewController as! HomeViewController
            let indexPath = sender as! NSIndexPath
        }
    }
    */
}
