//
//  JournalTableViewController.swift
//  CreativeCalendar
//
//  Created by Wes Bosman on 6/6/16.
//  Copyright © 2016 Wes Bosman. All rights reserved.
//

import UIKit


class JournalTableViewController: UITableViewController, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    fileprivate let journalIdentifier = "Journal Cells"
    fileprivate let db = DatabaseFunctions.sharedInstance
    fileprivate let journalDateFormatter = DateFormatter().dateWithoutTime
    weak var actionToEnable: UIAlertAction?
    fileprivate var selectedIndexPath: IndexPath?
    fileprivate var isExpanded: Bool = false
    fileprivate var cellHeightDictionary: Dictionary<Int, [CGFloat]> = [:]
    fileprivate var cellHeightArray: [CGFloat] = []
    fileprivate var previousSection = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Navigation Bar
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        let nav = self.navigationController?.navigationBar
        let barColor = UIColor().navigationBarColor
        nav?.barTintColor = barColor
        nav?.tintColor = UIColor.blue
        
        self.tableView.allowsSelectionDuringEditing = true
        self.tableView.allowsSelection = false
        
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        tableView.tableFooterView = UIView()

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
    override func viewDidAppear(_ animated: Bool) {
        previousSection = 0
        tableView.reloadData()
        self.tableView.estimatedRowHeight = 100
        self.tableView.setNeedsLayout()
        self.tableView.layoutIfNeeded()
    }
    
    // MARK - Empty Table View Methods
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        let str = "No Journals written"
        let attributes = [NSFontAttributeName: UIFont.preferredFont(forTextStyle: .headline)]
        return NSAttributedString(string: str, attributes: attributes)
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        let str = "Please click the add button to write a new Journal"
        let attributes = [NSFontAttributeName: UIFont.preferredFont(forTextStyle: .body)]
        return NSAttributedString(string: str, attributes: attributes)
    }
    
    func image(forEmptyDataSet scrollView: UIScrollView) -> UIImage? {
        let image = UIImage(named: "Journals")
        return image
    }


    // MARK: - Section Methods
    override func numberOfSections(in tableView: UITableView) -> Int {
        return GlobalJournalStructures.journalSections.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return GlobalJournalStructures.journalDictionary[GlobalJournalStructures.journalSections[section]]!.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
        if(!GlobalJournalStructures.journalSections[section].isEmpty){
            return GlobalJournalStructures.journalSections[section]
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
        header.contentView.backgroundColor = UIColor().journalColor
        header.textLabel?.textColor = UIColor.white
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: journalIdentifier, for: indexPath) as! JournalCell
        
        let tableSection = GlobalJournalStructures.journalDictionary[GlobalJournalStructures.journalSections[(indexPath as NSIndexPath).section]]
        let journalItem = tableSection![(indexPath as NSIndexPath).row] as JournalItem
        
        cell.journalCellTitle.text = journalItem.journalTitle
        cell.journalCellImage.image = UIImage(named: "Journals")
        cell.journalCellSubtitle.text = journalItem.journalEntry
        
//         The background is to let me know the size of what is stored in the cell
//        cell.journalCellTitle.backgroundColor = UIColor.cyan
//        cell.journalCellSubtitle.backgroundColor = UIColor.green
        
        cell.journalCellTitle.sizeToFit()
        cell.journalCellSubtitle.sizeToFit()
        
        return cell
    }
    
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            // Delete the row from the data source
            let tableSection = GlobalJournalStructures.journalDictionary[GlobalJournalStructures.journalSections[(indexPath as NSIndexPath).section]]
            let journalItemToDelete = tableSection![(indexPath as NSIndexPath).row] as JournalItem
            
            let deleteOptions = UIAlertController(title: "Delete Journal", message: "Are you sure you want to delete the following journal? : \n\(journalItemToDelete.journalEntry)", preferredStyle: .alert)
            deleteOptions.addTextField(configurationHandler: {(textField) in
                textField.placeholder = "Reason for Delete"
                textField.addTarget(self, action: #selector(self.textChanged(_:)), for: .editingChanged)
            })
            
            
            let deleteJournal = UIAlertAction(title: "Delete Journal", style: .destructive, handler: {(action: UIAlertAction) -> Void in

                let key = GlobalJournalStructures.journalSections[(indexPath as NSIndexPath).section]
                let journal = GlobalJournalStructures.journalDictionary[key]?.remove(at: (indexPath as NSIndexPath).row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                journal!.journalDeleted = true
                journal!.journalDeletedReason = deleteOptions.textFields![0].text!
                self.db.updateJournal(journal!, option: "delete")

                })
            
            let cancelDelete = UIAlertAction(title: "Exit Menu", style: .cancel, handler: nil)
            self.actionToEnable = deleteJournal
            deleteJournal.isEnabled = false
            deleteOptions.addAction(cancelDelete)
            deleteOptions.addAction(deleteJournal)
                
            self.present(deleteOptions, animated: true, completion: nil)
        }
    }
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        
        let selectedCell = tableView.cellForRow(at: indexPath) as! JournalCell
        selectedIndexPath = tableView.indexPath(for: selectedCell)
        
        if (selectedIndexPath! as NSIndexPath).row == (indexPath as NSIndexPath).row && (selectedIndexPath as NSIndexPath?)?.section == (indexPath as NSIndexPath).section{
            toggleExpanded()
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if isExpanded && (selectedIndexPath as NSIndexPath?)?.row == (indexPath as NSIndexPath).row && (selectedIndexPath as NSIndexPath?)?.section == (indexPath as NSIndexPath).section{
            return UITableViewAutomaticDimension
        }
        else{
            return super.tableView(tableView, heightForRowAt: indexPath)
        }
    }
    
    func textChanged(_ sender:UITextField) {
        self.actionToEnable?.isEnabled = (sender.text!.isEmpty == false)
    }
    
    func toggleExpanded(){
        isExpanded = !isExpanded
        tableView.beginUpdates()
        tableView.endUpdates()
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "editJournalSegue"{
            let destination = segue.destination as! JournalViewController
            let indexPath = tableView.indexPathForSelectedRow!
            let tableSection = GlobalJournalStructures.journalDictionary[GlobalJournalStructures.journalSections[(indexPath as NSIndexPath).section]]
            let journalItem = tableSection![(indexPath as NSIndexPath).row] as JournalItem
            
            destination.journalItemToEdit = journalItem
            
        }
    }

}
