//
//  RepeatAppointmentTableViewCell.swift
//  CreativeCalendar
//
//  Created by Wes Bosman on 7/28/16.
//  Copyright © 2016 Wes Bosman. All rights reserved.
//

import UIKit

class RepeatTableViewCell: UITableViewCell, UITableViewDelegate, UITableViewDataSource {

    fileprivate let repeatIdentifier = "RepeatIdentifier"
    fileprivate let defaults = UserDefaults.standard
    let repeatDays = ["Never", "Every Day", "Every Week", "Every Two Weeks", "Every Month"]
    fileprivate var repeatTableView: UITableView?
    fileprivate var arrayOfDays:[String] = []
    fileprivate let firstIndexPath = IndexPath(row: 0, section: 0)
    fileprivate var previousCell: UITableViewCell?

    
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
        defaults.removeObject(forKey: repeatIdentifier)
        setUpTableView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        repeatTableView?.frame = CGRect(x: 0.2, y: 0.3, width: self.bounds.size.width-5, height: self.bounds.size.height-5)
    }
    
    func setUpTableView(){
        repeatTableView = UITableView(frame: CGRect.zero, style: UITableViewStyle.plain)
        repeatTableView?.delegate = self
        repeatTableView?.dataSource = self
        repeatTableView?.allowsMultipleSelection = false
        repeatTableView?.selectRow(at: firstIndexPath, animated: true, scrollPosition: UITableViewScrollPosition.top)
        let cell = repeatTableView?.cellForRow(at: firstIndexPath)
        previousCell = cell
        cell?.accessoryType = UITableViewCellAccessoryType.checkmark
        self.addSubview(repeatTableView!)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: repeatIdentifier)
        if(cell == nil){
            cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: repeatIdentifier)
        }
        cell?.textLabel?.text = repeatDays[(indexPath as NSIndexPath).row]
        return cell!
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repeatDays.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        // Remove the accessory checkmark from the previously selected cell
        previousCell?.accessoryType = UITableViewCellAccessoryType.none
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Add an accessory checkmark to the selected cell
        if (indexPath as NSIndexPath).row <= repeatDays.count && (indexPath as NSIndexPath).section == 0{
            if let cell = tableView.cellForRow(at: indexPath){
                previousCell = cell
                cell.accessoryType = UITableViewCellAccessoryType.checkmark
                let cellText = cell.textLabel?.text
                print("Repeat Cell Text: \(cellText!) At Index: \((indexPath as NSIndexPath).row) Repeat Identifier: \(repeatIdentifier)")
                defaults.setValue(cellText!, forKey: repeatIdentifier)
            }
        }
    }
}
