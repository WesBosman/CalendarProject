//
//  AppointmentTableViewController.swift
//  CreativeCalendar
//
//  Created by Wes on 2/12/16.
//  Followed a source code example on github for an accordian menu.
//  Copyright (c) 2016 Wes Bosman. All rights reserved.

import UIKit

class AppointmentTableViewController: UITableViewController, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate{
    
    fileprivate let cellID = "AppointmentCells"
    fileprivate var selectedIndexPath: IndexPath?
    fileprivate let db = DatabaseFunctions.sharedInstance
    fileprivate let appointmentDateFormatter = DateFormatter().dateWithoutTime
    fileprivate let defaults = UserDefaults.standard
    weak var actionToEnable:UIAlertAction?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set the left bar button to be an edit button
        navigationItem.leftBarButtonItem = editButtonItem
        // This call with refresh the table view when a notification arrives
        NotificationCenter.default
            .addObserver(self, selector: #selector(AppointmentTableViewController.refreshList), name: NSNotification.Name(rawValue: "AppointmentListShouldRefresh"), object: nil)
        tableView.allowsSelection = false
        
        // Set the Empty DataSource and Delegate
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        tableView.tableFooterView = UIView()
        
    }
    
    // Failable Initializer for tab bar controller
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // Initialize Tab Bar Item
//        tabBarItem = UITabBarItem(title: "Appointments", image: UIImage(named: "Appointment"), tag: 2)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshList()
    }
    
    // MARK - Empty Table View Methods
    
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        let str = "No Appointments scheduled"
        let attributes = [NSFontAttributeName: UIFont.preferredFont(forTextStyle: .headline)]
        return NSAttributedString(string: str, attributes: attributes)
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        let str = "Please click the add button to schedule Appointments"
        let attributes = [NSFontAttributeName: UIFont.preferredFont(forTextStyle: .body)]
        return NSAttributedString(string: str, attributes: attributes)
    }
    
    func image(forEmptyDataSet scrollView: UIScrollView) -> UIImage? {
        let image = UIImage(named: "Appointments")
        return image
    }

    
    // Refresh the list do not let more than 64 notifications on screen at any one time.
    func refreshList(){
        // Refresh the appointment list
        Appointments().setUpAppointmentDictionary()
        
        // If there are more than 64 appointments today do not let the user add more appointments
        if(Appointments.appointmentItems.count > 64){
            self.navigationItem.rightBarButtonItem?.isEnabled = false
        }
        
        tableView.reloadData()
    }

    // MARK Section Header Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Appointments.appointmentDictionary[Appointments.appointmentSections[section]]!.count
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return Appointments.appointmentDictionary.keys.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        // Return the section title as a date
        if !(Appointments.appointmentSections[section].isEmpty){
            return Appointments.appointmentSections[section]
        }
        return nil
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if(tableView.dataSource?.tableView(tableView, numberOfRowsInSection: section) == 0){
            return 0.0
        }
        else{
            return 30.0
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if(tableView.dataSource?.tableView(tableView, numberOfRowsInSection: section) == 0){
            return nil
        }
        else{
            return tableView.headerView(forSection: section)
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        header.contentView.backgroundColor = UIColor().appointmentColor
        header.textLabel?.textColor = UIColor.white
    }
    
    // Make a cell where the title and the start date are retrieved from the save button being pressed
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // The cell is a custom appointment cell that we have created.
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! AppointmentCell
        let tableSection = Appointments.appointmentDictionary[Appointments.appointmentSections[(indexPath as NSIndexPath).section]]
        let appointment = tableSection![(indexPath as NSIndexPath).row]
        
        // If the current time is later than the starting time of the appointment then the color is set to red.
        if (appointment.isOverdue) {
            cell.appointmentStart.textColor = UIColor.red
        }
        // If its not true that the event has happened the text should be black
        else {
            cell.appointmentStart.textColor = UIColor.black
        }
        
        cell.appointmentCompleted(appointment)
        cell.setTitle(title: appointment.title)
        cell.setType(type: appointment.type)
        cell.setStart(start: DateFormatter().dateWithTime.string(from: appointment.startingTime))
        cell.setEnd(end: DateFormatter().dateWithTime.string(from:appointment.endingTime))
        cell.setAlert(alert: appointment.alert)
        cell.setRepeat(rep: appointment.repeating)
        cell.setLocation(location: appointment.appLocation)
        cell.setAdditional(additional: appointment.additionalInfo)
        
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
        let tableSection = Appointments.appointmentDictionary[Appointments.appointmentSections[(indexPath as NSIndexPath).section]]
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
                        for key in Appointments.appointmentDictionary.keys{
                            // Get the section key
                            if let k = Appointments.appointmentDictionary[key]{
                                // Get the appointment based on the key
                                for app in k{
                                    // If the appointment title is equal to the one we are deleting
                                    // Then remove it
                                    if app.title == appointmentForAction.title
                                        && app.type == appointmentForAction.type
                                        && app.appLocation == appointmentForAction.appLocation
                                        && app.additionalInfo == appointmentForAction.additionalInfo{
                                        
                                        if let index = k.index(where: {$0.title == appointmentForAction.title}){
                                            Appointments.appointmentDictionary[key]?.remove(at: index)
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
                        let key = Appointments.appointmentSections[indexPath.section]
                        print("Key for removal: \(key)")
                        Appointments.appointmentDictionary[key]?.remove(at: indexPath.row)
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
    
    // This is for the selector for the confirmation on delete and cancel alert controller menus
    func textChanged(_ sender:UITextField) {
        self.actionToEnable?.isEnabled = (sender.text!.isEmpty == false)
    }
}
