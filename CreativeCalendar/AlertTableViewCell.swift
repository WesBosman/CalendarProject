//
//  AlertTableViewCell.swift
//  CreativeCalendar
//
//  Created by Wes Bosman on 8/10/16.
//  Copyright © 2016 Wes Bosman. All rights reserved.
//

import UIKit

class AlertTableViewCell: UITableViewCell, UITableViewDelegate, UITableViewDataSource {
    
    fileprivate let alertIdentifier = "AlertIdentifier"
    let alertArray = ["At Time of Event", "5 Minutes Before", "15 Minutes Before", "30 Minutes Before", "1 Hour Before"]
    fileprivate var alertTableView: UITableView?
    fileprivate let defaults = UserDefaults.standard
    fileprivate let firstIndexPath = IndexPath(row: 0, section: 0)
    fileprivate var previousCell: UITableViewCell?
    
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
        defaults.removeObject(forKey: alertIdentifier)
        setUpTableView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        alertTableView?.frame = CGRect(x: 0.2, y: 0.3, width: self.bounds.size.width-5, height: self.bounds.size.height-5)
    }
    
    func setUpTableView(){
        alertTableView = UITableView(frame: CGRect.zero, style: UITableViewStyle.plain)
        alertTableView?.delegate = self
        alertTableView?.dataSource = self
        alertTableView?.allowsMultipleSelection = false
        alertTableView?.selectRow(at: firstIndexPath, animated: true, scrollPosition: UITableViewScrollPosition.top)
        let cell = alertTableView?.cellForRow(at: firstIndexPath)
        previousCell = cell
        cell?.accessoryType = UITableViewCellAccessoryType.checkmark
        self.addSubview(alertTableView!)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return alertArray.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Set a checkmark on the newly selected cell and add the text to user defaults
        if (indexPath as NSIndexPath).row <= alertArray.count && (indexPath as NSIndexPath).section == 0{
            if let cell = tableView.cellForRow(at: indexPath){
                previousCell = cell
                cell.accessoryType = UITableViewCellAccessoryType.checkmark
                let cellText = cell.textLabel?.text
                print("Alert Cell Text: \(cellText!) At Index: \((indexPath as NSIndexPath).row) Alert Identifier: \(alertIdentifier)")
                defaults.setValue(cellText!, forKey: alertIdentifier)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        previousCell?.accessoryType = UITableViewCellAccessoryType.none
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell:UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: alertIdentifier)
        
        if (cell == nil){
            cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: alertIdentifier)
        }
        cell?.textLabel?.text = alertArray[(indexPath as NSIndexPath).row]
        return cell!
    }

}
