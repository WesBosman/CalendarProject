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
    let repeatDays = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
    var repeatTableView:UITableView?
    var arrayOfDays:[String] = []
    
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
        var cell: UITableViewCell? = tableView.dequeueReusableCellWithIdentifier("cellID")
        if(cell == nil){
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "cellID")
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
        arrayOfDays.removeAtIndex(indexPath.row)
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        cell?.accessoryType = UITableViewCellAccessoryType.Checkmark
        arrayOfDays.insert((cell?.textLabel?.text)!, atIndex: indexPath.row)
        print("Array Of Days: \((cell?.textLabel!.text)!) at index: \(indexPath.row)")
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
