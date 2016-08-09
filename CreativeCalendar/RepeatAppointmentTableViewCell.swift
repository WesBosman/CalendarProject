//
//  RepeatAppointmentTableViewCell.swift
//  CreativeCalendar
//
//  Created by Wes Bosman on 7/28/16.
//  Copyright © 2016 Wes Bosman. All rights reserved.
//

import UIKit

class RepeatAppointmentTableViewCell: UITableViewCell, UITableViewDelegate, UITableViewDataSource {

    let repeatIdentifier = "RepeatAppointmentCell"
    let defaults = NSUserDefaults.standardUserDefaults()
    let repeatDays = ["Never", "Every Day", "Every Week", "Every Two Weeks", "Every Month"]
    var repeatTableView:UITableView?
    var arrayOfDays:[String] = []
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        repeatTableView?.allowsMultipleSelection = false
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
        repeatTableView?.allowsMultipleSelection = true
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
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        cell?.accessoryType = UITableViewCellAccessoryType.None
        let index = arrayOfDays.indexOf((cell?.textLabel?.text)!)
        print("Remove: \((cell?.textLabel?.text)!) from Array Of Days at index: \(index!)")
        arrayOfDays.removeAtIndex(index!)
        defaults.setValue(arrayOfDays, forKey: repeatIdentifier)
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("Section: \(indexPath.section) + Row:   \(indexPath.row)")
        
        if indexPath.row <= repeatDays.count && indexPath.section == 0{
            let cell = tableView.cellForRowAtIndexPath(indexPath)
            cell?.accessoryType = UITableViewCellAccessoryType.Checkmark
            arrayOfDays.append((cell?.textLabel?.text)!)
            print("Array Of Days: \((cell?.textLabel!.text)!) at index: \(indexPath.row)")
            defaults.setValue(arrayOfDays, forKey: repeatIdentifier)
        }
    }
    

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
