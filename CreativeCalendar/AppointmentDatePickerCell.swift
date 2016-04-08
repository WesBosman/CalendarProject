//
//  AppointmentDatePickerCell.swift
//  CreativeCalendar
//
//  Created by Wes on 4/8/16.
//  Copyright (c) 2016 Wes Bosman. All rights reserved.
//

import UIKit

class AppointmentDatePickerCell: UITableViewCell{
    
    
    //@IBOutlet weak var startLabel: UILabel!
    @IBOutlet weak var startDatePicker: UIView!
    class var expandedHeight: CGFloat { get { return 200} }
    class var defaultHeight: CGFloat { get { return 44 } }
    
    func checkHeight(){
        startDatePicker.hidden = (frame.size.height < AppointmentDatePickerCell.expandedHeight)
    }
    
    func watchFrameChanges(){
        addObserver(self, forKeyPath: "frame", options: .New, context: nil)
        checkHeight()
    }
    
    func ignoreFrameChanges(){
        removeObserver(self, forKeyPath: "frame")
    }
    
    override func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject : AnyObject], context: UnsafeMutablePointer<Void>) {
        if keyPath == "frame"{
            checkHeight()
        }
    }
}