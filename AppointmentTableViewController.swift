//
//  AppointmentTableViewController.swift
//  CreativeCalendar
//
//  Created by Wes on 2/12/16.
//  Followed a source code example on github for an accordian menu.
//  Copyright (c) 2016 Wes Bosman. All rights reserved.
//

import UIKit

let cellID = "AppointmentCells"
let heightForHeader: CGFloat = 50
let heightForFooter: CGFloat = 1
var titleOfSections: NSMutableArray = NSMutableArray()
var typeOfEventDictionary: NSMutableDictionary = NSMutableDictionary()
var arrayOfBooleans: NSMutableArray = NSMutableArray()

class AppointmentTableViewController: UITableViewController, UIPopoverControllerDelegate{
    
    var dummyTestList=[String] ();
    var selectedIndexPath: NSIndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dummyTestList = ["Test 1" , "Test 2"]
        arrayOfBooleans = [0, 0]
        titleOfSections = ["Type Of Appointment", "Start Time"]
        let typeOfAppointments = ["Recreation", "Doctor", "Family"]
        
        var stringOne = titleOfSections.objectAtIndex(0) as? String
        var stringTwo = titleOfSections.objectAtIndex(1) as? String
        
        [typeOfEventDictionary.setValue(typeOfAppointments, forKey: stringOne!) ,
        typeOfEventDictionary.setValue(dummyTestList, forKey: stringTwo!)]
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.leftBarButtonItem = self.editButtonItem()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return titleOfSections.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        if arrayOfBooleans.objectAtIndex(section).boolValue == true{
            let sectionTitle = titleOfSections.objectAtIndex(section) as! String
            let countOne = (typeOfEventDictionary.valueForKey(sectionTitle)) as! NSArray
            return countOne.count
        }
        //return dummyTestList.count
        return 0
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Title..."
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return heightForHeader
    }
    
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return heightForFooter
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if (arrayOfBooleans.objectAtIndex(indexPath.section).boolValue == true){
            return 60
        }
        return 2
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRectMake(0, 0, tableView.frame.size.width, 44 ))
        headerView.tag = section
        
        let headerString = UILabel(frame: CGRectMake( 10, 10, tableView.frame.size.width - 10, 30)) as UILabel
        headerString.text = titleOfSections.objectAtIndex(section) as? String
        headerView.addSubview(headerString)
        
        let headerTapped = UITapGestureRecognizer(target: self, action: "sectionHeaderTapped:")
        headerView.addGestureRecognizer(headerTapped)
        
        return headerView
        
    }
    
    func sectionHeaderTapped(recognizer: UIGestureRecognizer){
        print("Tapped Working")
        print(recognizer.view?.tag)
        
        let indexPath: NSIndexPath = NSIndexPath (forRow: 0, inSection:(recognizer.view?.tag as Int!)!)
        if indexPath.row == 0{
            var collapsed = arrayOfBooleans.objectAtIndex(indexPath.section).boolValue
            collapsed = !collapsed;
            arrayOfBooleans.replaceObjectAtIndex(indexPath.section , withObject: collapsed)
            // Reload the current section and animate it
            let range = NSMakeRange(indexPath.section, 1)
            let sectionToReload = NSIndexSet(indexesInRange: range)
            self.tableView.reloadSections(sectionToReload, withRowAnimation: UITableViewRowAnimation.Automatic)
        }
        
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellID, forIndexPath: indexPath) as! AppointmentDatePickerCell //UITableViewCell
        // Configure the reusable cell
        //cell.textLabel?.text = dummyTestList[indexPath.row]
        var bgColorView = UIView()
        bgColorView.backgroundColor = UIColor(red:0.90, green:0.93, blue:0.98, alpha:1.00)
        cell.selectedBackgroundView = bgColorView
        
        let manyCells: Bool = arrayOfBooleans.objectAtIndex(indexPath.section).boolValue
        if( !manyCells){
            
        }
        else{
            let content = typeOfEventDictionary.valueForKey(titleOfSections.objectAtIndex(indexPath.section) as! String) as! NSArray
            cell.textLabel?.text = content.objectAtIndex(indexPath.row) as? String
            //cell.backgroundColor = UIColor.greenColor()
        }
        
        return cell
    }
/*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return false
    }
    

    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
    }
*/

/** FROM TUTORIAL NOT WORKING CORRECTLY

    override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        let previousIndexPath = selectedIndexPath
        if indexPath == selectedIndexPath{
            selectedIndexPath = nil
        }
        else {
            selectedIndexPath = indexPath
        }
        var indexPaths : Array<NSIndexPath> = []
        if let previous = previousIndexPath{
            indexPaths += [previous]
        }
        if let current = selectedIndexPath{
            indexPaths += [current]
        }
        if indexPaths.count > 0{
            tableView.reloadRowsAtIndexPaths(indexPaths, withRowAnimation: .Automatic)
        }
    }

    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        (cell as! AppointmentDatePickerCell).watchFrameChanges()
    }
    
    override func tableView(tableView: UITableView, didEndDisplayingCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        (cell as! AppointmentDatePickerCell).ignoreFrameChanges()
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath == selectedIndexPath{
            return AppointmentDatePickerCell.expandedHeight
        }
        else{
            return AppointmentDatePickerCell.defaultHeight
        }
    }
**/


    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation
/*
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.

    }
*/

}
