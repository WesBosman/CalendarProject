//
//  RepeatAppointmentTableViewCell.swift
//  CreativeCalendar
//
//  Created by Wes Bosman on 7/28/16.
//  Copyright © 2016 Wes Bosman. All rights reserved.
//

import UIKit

class RepeatTableViewCell: UITableViewCell, UITableViewDelegate, UITableViewDataSource {

    private let repeatIdentifier = "RepeatIdentifier"
    private let defaults = NSUserDefaults.standardUserDefaults()
    let repeatDays = ["Never", "Every Day", "Every Week", "Every Two Weeks", "Every Month"]
    private var repeatTableView: UITableView?
    private var arrayOfDays:[String] = []
    private let firstIndexPath = NSIndexPath(forRow: 0, inSection: 0)
    private var previousCell: UITableViewCell?

    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpTableView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUpTableView()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        defaults.removeObjectForKey(repeatIdentifier)
        setUpTableView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        repeatTableView?.frame = CGRectMake(0.2, 0.3, self.bounds.size.width-5, self.bounds.size.height-5)
    }
    
    func setUpTableView(){
        repeatTableView = UITableView(frame: CGRectZero, style: UITableViewStyle.Plain)
        repeatTableView?.delegate = self
        repeatTableView?.dataSource = self
        repeatTableView?.allowsMultipleSelection = false
        repeatTableView?.selectRowAtIndexPath(firstIndexPath, animated: true, scrollPosition: UITableViewScrollPosition.Top)
        let cell = repeatTableView?.cellForRowAtIndexPath(firstIndexPath)
        previousCell = cell
        cell?.accessoryType = UITableViewCellAccessoryType.Checkmark
        self.addSubview(repeatTableView!)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell? = tableView.dequeueReusableCellWithIdentifier(repeatIdentifier)
        if(cell == nil){
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: repeatIdentifier)
        }
        cell?.textLabel?.text = repeatDays[indexPath.row]
        return cell!
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repeatDays.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        // Remove the accessory checkmark from the previously selected cell
        previousCell?.accessoryType = UITableViewCellAccessoryType.None
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // Add an accessory checkmark to the selected cell
        if indexPath.row <= repeatDays.count && indexPath.section == 0{
            if let cell = tableView.cellForRowAtIndexPath(indexPath){
                previousCell = cell
                cell.accessoryType = UITableViewCellAccessoryType.Checkmark
                let cellText = cell.textLabel?.text
                print("Repeat Cell Text: \(cellText!) At Index: \(indexPath.row) Repeat Identifier: \(repeatIdentifier)")
                defaults.setValue(cellText!, forKey: repeatIdentifier)
            }
        }
    }
}
