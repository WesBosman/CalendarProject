//
//  AlertTableViewCell.swift
//  CreativeCalendar
//
//  Created by Wes Bosman on 8/10/16.
//  Copyright © 2016 Wes Bosman. All rights reserved.
//

import UIKit

class AlertTableViewCell: UITableViewCell, UITableViewDelegate, UITableViewDataSource {
    
    private let alertIdentifier = "AlertIdentifier"
    let alertArray = ["At Time of Event", "5 Minutes Before", "15 Minutes Before", "30 Minutes Before", "1 Hour Before"]
    private var alertTableView: UITableView?
    private let defaults = NSUserDefaults.standardUserDefaults()
    private let firstIndexPath = NSIndexPath(forRow: 0, inSection: 0)
    private var previousCell: UITableViewCell?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUpTableView()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        defaults.removeObjectForKey(alertIdentifier)
        setUpTableView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        alertTableView?.frame = CGRectMake(0.2, 0.3, self.bounds.size.width-5, self.bounds.size.height-5)
    }
    
    func setUpTableView(){
        alertTableView = UITableView(frame: CGRectZero, style: UITableViewStyle.Plain)
        alertTableView?.delegate = self
        alertTableView?.dataSource = self
        alertTableView?.allowsMultipleSelection = false
        alertTableView?.selectRowAtIndexPath(firstIndexPath, animated: true, scrollPosition: UITableViewScrollPosition.Top)
        let cell = alertTableView?.cellForRowAtIndexPath(firstIndexPath)
        previousCell = cell
        cell?.accessoryType = UITableViewCellAccessoryType.Checkmark
        self.addSubview(alertTableView!)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return alertArray.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // Set a checkmark on the newly selected cell and add the text to user defaults
        if indexPath.row <= alertArray.count && indexPath.section == 0{
            if let cell = tableView.cellForRowAtIndexPath(indexPath){
                previousCell = cell
                cell.accessoryType = UITableViewCellAccessoryType.Checkmark
                let cellText = cell.textLabel?.text
                print("Alert Cell Text: \(cellText!) At Index: \(indexPath.row) Alert Identifier: \(alertIdentifier)")
                defaults.setValue(cellText!, forKey: alertIdentifier)
            }
        }
    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        previousCell?.accessoryType = UITableViewCellAccessoryType.None
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 55
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:UITableViewCell? = tableView.dequeueReusableCellWithIdentifier(alertIdentifier)
        
        if (cell == nil){
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: alertIdentifier)
        }
        cell?.textLabel?.text = alertArray[indexPath.row]
        return cell!
    }

}
