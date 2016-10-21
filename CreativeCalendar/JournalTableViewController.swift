//
//  JournalTableViewController.swift
//  CreativeCalendar
//
//  Created by Wes Bosman on 6/6/16.
//  Copyright © 2016 Wes Bosman. All rights reserved.
//

import UIKit


class JournalTableViewController: UITableViewController {
    private let journalIdentifier = "Journal Cells"
    private let db = DatabaseFunctions.sharedInstance
    private let journalDateFormatter = NSDateFormatter().dateWithoutTime
    weak var actionToEnable: UIAlertAction?
    private var selectedIndexPath: NSIndexPath?
    private var isExpanded: Bool = false
    private var cellHeightDictionary: Dictionary<Int, [CGFloat]> = [:]
    private var cellHeightArray: [CGFloat] = []
    private var previousSection = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Navigation Bar
        self.navigationItem.leftBarButtonItem = self.editButtonItem()
        let nav = self.navigationController?.navigationBar
        let barColor = UIColor().navigationBarColor
        nav?.barTintColor = barColor
        nav?.tintColor = UIColor.blueColor()
        
        self.tableView.allowsSelectionDuringEditing = true
        self.tableView.allowsSelection = false

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
    
    // Should no longer require hitting the database
    override func viewDidAppear(animated: Bool) {
        previousSection = 0
        GlobalJournalStructures.journalHeightArray = []
        tableView.reloadData()
        self.tableView.estimatedRowHeight = 100
        self.tableView.setNeedsLayout()
        self.tableView.layoutIfNeeded()
    }

    // MARK: - Section Methods
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return GlobalJournalStructures.journalSections.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return GlobalJournalStructures.journalDictionary[GlobalJournalStructures.journalSections[section]]!.count
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
        if(!GlobalJournalStructures.journalSections[section].isEmpty){
            return GlobalJournalStructures.journalSections[section]
        }
        return nil
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if tableView.dataSource?.tableView(tableView, numberOfRowsInSection: section) == 0{
            return 0.0
        }
        else{
            return 30.0
        }
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if tableView.dataSource?.tableView(tableView, numberOfRowsInSection: section) == 0{
            return nil
        }
        else{
            return tableView.headerViewForSection(section)
        }
    }
    
    override func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        header.contentView.backgroundColor = UIColor().defaultButtonColor
        header.textLabel?.textColor = UIColor.whiteColor()
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(journalIdentifier, forIndexPath: indexPath) as! JournalCell
        
//        let tableSection = journalDayForSection[journalSections[indexPath.section]]
        let tableSection = GlobalJournalStructures.journalDictionary[GlobalJournalStructures.journalSections[indexPath.section]]
        let journalItem = tableSection![indexPath.row] as JournalItem
        
        cell.journalCellTitle.text = journalItem.getSimplifiedDate()
        cell.journalCellImage.image = UIImage(named: "Journals")
        cell.journalCellSubtitle.text = journalItem.journalEntry
        
        // The background is to let me know the size of what is stored in the cell
        cell.journalCellTitle.backgroundColor = UIColor.cyanColor()
        cell.journalCellSubtitle.backgroundColor = UIColor.greenColor()
        cell.journalCellTitle.sizeToFit()
        cell.journalCellSubtitle.sizeToFit()
        
//        let titleHeight = cell.journalCellTitle.frame.height
//        let subtitleHeight = cell.journalCellSubtitle.frame.height
//        let combinedHeight = titleHeight + subtitleHeight
//        print("CELL FOR ROW AT INDEX PATH Combined Height Cell: \(combinedHeight)")
//        
//        let section = indexPath.section
//        let row = indexPath.row
        
        // TODO fix the height of the journal cells
//        createHeightForJournal(section, row: row,  combinedHeight: combinedHeight)
//        
//        print("Title Height: \(titleHeight)")
//        print("Subtitle Height: \(subtitleHeight)")
        
        cell.detailTextLabel?.backgroundColor = UIColor.cyanColor()
        return cell
    }
    
    // This may need work!! TODO needs to be updated as soon as the journal gets added or edited
//    func createHeightForJournal(section: Int, row:Int,  combinedHeight: CGFloat){
//        // Set up the dictionary for each cell so we can adjust its height based on whats stored in the journal entry
//        
//        if(GlobalJournalStructures.journalHeightArray.indices.contains(row)){
//            var oldHeight = GlobalJournalStructures.journalHeightArray[row]
//            print("Old Combined Height value: \(oldHeight) at index: \(row)")
//            GlobalJournalStructures.journalHeightArray.insert(Float(combinedHeight), atIndex: row)
//            print("Combined Height: \(combinedHeight) added at index: \(row)")
//        }
//        else{
//            GlobalJournalStructures.journalHeightArray.append(Float(combinedHeight))
//            print("Combined Height added: \(combinedHeight) at index: \(row)")
//        }
//        
//        for(key, value) in GlobalJournalStructures.journalHeightDictionary{
//            print("Key in Global Height: \(key)")
//            print("Value in Global Height: \(value)")
//        }
//      
//        GlobalJournalStructures.journalHeightDictionary.updateValue(GlobalJournalStructures.journalHeightArray, forKey: section)
//    }

    
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            
            // Delete the row from the data source
            let tableSection = GlobalJournalStructures.journalDictionary[GlobalJournalStructures.journalSections[indexPath.section]]
            let journalItemToDelete = tableSection![indexPath.row] as JournalItem
            
            let deleteOptions = UIAlertController(title: "Delete Journal", message: "Are you sure you want to delete the following journal? : \n\(journalItemToDelete.journalEntry)", preferredStyle: .Alert)
            deleteOptions.addTextFieldWithConfigurationHandler({(textField) in
                textField.placeholder = "Reason for Delete"
                textField.addTarget(self, action: #selector(self.textChanged(_:)), forControlEvents: .EditingChanged)
            })
            
            
            let deleteJournal = UIAlertAction(title: "Delete Journal", style: .Destructive, handler: {(action: UIAlertAction) -> Void in

                let key = GlobalJournalStructures.journalSections[indexPath.section]
                let journal = GlobalJournalStructures.journalDictionary[key]?.removeAtIndex(indexPath.row)
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
                journal!.journalDeleted = true
                journal!.journalDeletedReason = deleteOptions.textFields![0].text!
                self.db.updateJournal(journal!, option: "delete")
                
                // Remove the height value stored in the height dictionary
//                var heightValues = GlobalJournalStructures.journalHeightDictionary[indexPath.section]
//                heightValues?.removeAtIndex(indexPath.row)

                })
            
            let cancelDelete = UIAlertAction(title: "Exit Menu", style: .Cancel, handler: nil)
            self.actionToEnable = deleteJournal
            deleteJournal.enabled = false
            deleteOptions.addAction(cancelDelete)
            deleteOptions.addAction(deleteJournal)
                
            self.presentViewController(deleteOptions, animated: true, completion: nil)
        }
    }
    
    override func tableView(tableView: UITableView, accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath) {
        
        let selectedCell = tableView.cellForRowAtIndexPath(indexPath) as! JournalCell
        selectedIndexPath = tableView.indexPathForCell(selectedCell)
        
        if selectedIndexPath!.row == indexPath.row && selectedIndexPath?.section == indexPath.section{
            toggleExpanded()
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if isExpanded && selectedIndexPath?.row == indexPath.row && selectedIndexPath?.section == indexPath.section{
            return UITableViewAutomaticDimension
        }
        else{
            return super.tableView(tableView, heightForRowAtIndexPath: indexPath)
        }
    }
    
    func textChanged(sender:UITextField) {
        self.actionToEnable?.enabled = (sender.text!.isEmpty == false)
    }
    
    func toggleExpanded(){
        isExpanded = !isExpanded
        tableView.beginUpdates()
        tableView.endUpdates()
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "editJournalSegue"{
//            let source = segue.sourceViewController as! JournalTableViewController
            let destination = segue.destinationViewController as! JournalViewController
            
            let indexPath = tableView.indexPathForSelectedRow!
//            let tableSection = journalDayForSection[journalSections[indexPath.section]]
            
            let tableSection = GlobalJournalStructures.journalDictionary[GlobalJournalStructures.journalSections[indexPath.section]]
            let journalItem = tableSection![indexPath.row] as JournalItem
            
            destination.journalItemToEdit = journalItem
            
        }
    }

}
