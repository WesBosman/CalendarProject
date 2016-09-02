//
//  JournalTableViewController.swift
//  CreativeCalendar
//
//  Created by Wes Bosman on 6/6/16.
//  Copyright © 2016 Wes Bosman. All rights reserved.
//

import UIKit

struct GlobalJournals{
    static var journalDictionary: Dictionary<String, [JournalItem]> = [:]
}

class JournalTableViewController: UITableViewController {
    private var journalItems:[JournalItem] = []
    private let journalIdentifier = "Journal Cells"
    private let db = DatabaseFunctions.sharedInstance
    private var journalDayForSection: Dictionary<String, [JournalItem]> = [:]
    private var journalSections: [String] = []
    private let journalDateFormatter = NSDateFormatter().dateWithoutTime
    weak var actionToEnable: UIAlertAction?
    private var selectedIndexPath: NSIndexPath?
    private var isExpanded: Bool = false
    private var cellHeightDictionary: Dictionary<Int, [CGFloat]> = [:]
    private var cellHeightArray: [CGFloat] = []
    private var previousSection = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = self.editButtonItem()
        // Navigation bar
        let nav = self.navigationController?.navigationBar
        let barColor = UIColor().navigationBarColor
        nav?.barTintColor = barColor
        nav?.tintColor = UIColor.blueColor()

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
        
        // Reset previous section to zero
        previousSection = 0

        // Sort the journals based on their dates
        journalItems = journalItems.sort({$0.journalDate.compare($1.journalDate) == NSComparisonResult.OrderedAscending})
        
        for journal in journalItems{
            let journalDate = journalDateFormatter.stringFromDate(journal.journalDate)
            
            // If the journal sections array does not contain the date then add it
            if(!journalSections.contains(journalDate)){
                journalSections.append(journalDate)
            }
        }
        
        for section in journalSections{
            // Get journal items based on the date
            journalItems = db.getJournalByDate(section, formatter: journalDateFormatter)
            
            // Set the table view controllers dictionary
            journalDayForSection.updateValue(journalItems, forKey: section)
            
            // Set the global journal dictionary
            GlobalJournals.journalDictionary = journalDayForSection
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
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
        if !journalSections[section].isEmpty{
            return journalSections[section]
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
        let tableSection = journalDayForSection[journalSections[indexPath.section]]
        let journalItem = tableSection![indexPath.row] as JournalItem
        
        cell.journalCellTitle.text = journalItem.getSimplifiedDate()
        cell.journalCellImage.image = UIImage(named: "Journals")
        cell.journalCellSubtitle.text = journalItem.journalEntry
        
        // The background is to let me know the size of what is stored in the cell
//        cell.journalCellTitle.backgroundColor = UIColor.cyanColor()
//        cell.journalCellSubtitle.backgroundColor = UIColor.greenColor()
        cell.journalCellTitle.sizeToFit()
        cell.journalCellSubtitle.sizeToFit()
        
        let titleHeight = cell.journalCellTitle.frame.height
        let subtitleHeight = cell.journalCellSubtitle.frame.height
        let combinedHeight = titleHeight + subtitleHeight
        let section = indexPath.section
        
        createHeightForJournal(section, combinedHeight: combinedHeight)
        
//        print("Title Height: \(titleHeight)")
//        print("Subtitle Height: \(subtitleHeight)")
        
        cell.detailTextLabel?.backgroundColor = UIColor.cyanColor()
        return cell
    }
    
    func createHeightForJournal(section: Int, combinedHeight: CGFloat){
        // Set up the dictionary for each cell so we can adjust its height based on whats stored in the journal entry
        if previousSection == section{
            cellHeightArray.append(combinedHeight)
            cellHeightDictionary.updateValue(cellHeightArray, forKey: section)
        }
            // If there is a new section increment the previous section and create a new array for storing the height of elements in the next section
        else{
            previousSection += 1
            cellHeightArray = []
            cellHeightArray.append(combinedHeight)
        }
        
//        print("Title Height + Subtitle Height: \(combinedHeight)")
//        print("Section: \(section)")
//        print("Cell Height Array: \(cellHeightArray)")

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
            let tableSection = journalDayForSection[journalSections[indexPath.section]]
            let journalItemToDelete = tableSection![indexPath.row] as JournalItem
            
            let deleteOptions = UIAlertController(title: "Delete Journal", message: "Are you sure you want to delete the following journal? : \n\(journalItemToDelete.journalEntry)", preferredStyle: .Alert)
            deleteOptions.addTextFieldWithConfigurationHandler({(textField) in
                textField.placeholder = "Reason for Delete"
                textField.addTarget(self, action: #selector(self.textChanged(_:)), forControlEvents: .EditingChanged)
            })
            
            
            let deleteJournal = UIAlertAction(title: "Delete Journal", style: .Destructive, handler: {(action: UIAlertAction) -> Void in
                    
//                    let journal = self.journalItems.removeAtIndex(indexPath.row)
                    let key = self.journalSections[indexPath.section]
                    let journal = self.journalDayForSection[key]?.removeAtIndex(indexPath.row)
                    tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
                    journal!.journalDeleted = true
                    journal!.journalDeletedReason = deleteOptions.textFields![0].text!
                    self.db.updateJournal(journal!)
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
            for (key, value) in cellHeightDictionary{
                print("Key: \(key)")
                print("Value: \(value)")
            }
            if let heightArray = cellHeightDictionary[indexPath.section]{
                print("Height Array: \(heightArray)")
                print("Height Of Cell: \(heightArray[indexPath.row])")
                return heightArray[indexPath.row]
            }
            else{
                print("Return 350")
                return 350
            }
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
