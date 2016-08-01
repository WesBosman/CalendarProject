//
//  JournalTableViewController.swift
//  CreativeCalendar
//
//  Created by Wes Bosman on 6/6/16.
//  Copyright © 2016 Wes Bosman. All rights reserved.
//

import UIKit

class JournalTableViewController: UITableViewController {
    private var journalItems:[JournalItem] = []
    private let journalIdentifier = "Journal Cells"
    private let db = DatabaseFunctions.sharedInstance
    private var journalDayForSection: Dictionary<String, [JournalItem]> = [:]
    private var journalSections: [String] = []
    private let journalDateFormatter = NSDateFormatter().dateWithoutTime

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = self.editButtonItem()
    }
    
    // Failable Initializer for tab bar controller
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // Initialize Tab Bar Item
        tabBarItem = UITabBarItem(title: "Journals", image: UIImage(named: "Journals"), tag: 4)
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        journalItems = db.getAllJournals()
        for journal in journalItems{
            let journalDate = journalDateFormatter.stringFromDate(journal.journalDate)
            
            if(!journalSections.contains(journalDate)){
                journalSections.append(journalDate)
                print("Journal Date: \(journalDate)")
            }
            self.journalSections = self.journalSections.sort(>)
        }
        
        for section in journalSections{
            journalItems = db.getJournalByDate(section)
            journalDayForSection.updateValue(journalItems, forKey: section)
        }
        tableView.reloadData()
    }

    // MARK: - Section Methods
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return journalSections.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return journalDayForSection[journalSections[section]]!.count
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if !journalSections[section].isEmpty{
            return journalSections[section]
        }
        return nil
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(journalIdentifier, forIndexPath: indexPath)

        // Configure the cell...
        let journalCell = journalItems[indexPath.row] 
        cell.textLabel!.text = journalCell.getSimplifiedDate()
//        print("Get simplified journal date \(journalCell.getSimplifiedDate())")
        cell.detailTextLabel?.lineBreakMode = .ByWordWrapping
        cell.detailTextLabel?.numberOfLines = 0
        cell.detailTextLabel!.text = journalCell.journalEntry
        return cell
    }

    
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            let journalItemToDelete = journalItems[indexPath.row]
            
            let deleteOptions = UIAlertController(title: "Delete Journal", message: "Are you sure you want to delete the following journal? : \n\(journalItemToDelete.journalEntry)", preferredStyle: .Alert)
                
            let deleteAppointment = UIAlertAction(title: "Delete Journal", style: .Destructive, handler: {(action: UIAlertAction) -> Void in
                    
//                    let journal = self.journalItems.removeAtIndex(indexPath.row)
                    let key = self.journalSections[indexPath.section]
                    let journal = self.journalDayForSection[key]?.removeAtIndex(indexPath.row)
                    tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
                    journal!.journalDeleted = true
                    self.db.updateJournal(journal!)
                })
                let cancelDelete = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
                
                deleteOptions.addAction(cancelDelete)
                deleteOptions.addAction(deleteAppointment)
                
                self.presentViewController(deleteOptions, animated: true, completion: nil)
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
