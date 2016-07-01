//
//  CalendarHeaderView.swift
//  CreativeCalendar
//
//  Created by Wes Bosman on 6/29/16.
//  Copyright © 2016 Wes Bosman. All rights reserved.
//  Followed Tutorial by Michael Michailidis


import UIKit
import JTAppleCalendar

class CalendarHeaderView: JTAppleHeaderView{
    
    
    
}

//class CalendarHeaderView: UICollectionReusableView{
//        
//    // The month label
//    lazy var monthLabel : UILabel = {
//        let lbl = UILabel()
//        lbl.textAlignment = NSTextAlignment.Center
//        lbl.font = UIFont(name: "Helvetica", size: 25.0)
//        lbl.textColor = UIColor.blackColor()
//        
//        self.addSubview(lbl)
//        
//        return lbl
//    }()
//    
//    // The days of the week label
//    lazy var dayLabelContainerView : UIView = {
//        
//        let v = UIView()
//        
//        let formatter : NSDateFormatter = NSDateFormatter()
//
//        for index in 1...7 {
//            
//            let day : NSString = formatter.weekdaySymbols[index % 7] as NSString
//            
//            let weekdayLabel = UILabel()
//            
//            weekdayLabel.font = UIFont(name: "Helvetica", size: 14.0)
//            
//            weekdayLabel.text = day.substringToIndex(3).uppercaseString
//            weekdayLabel.textColor = UIColor.grayColor()
//            weekdayLabel.textAlignment = NSTextAlignment.Center
//            
//            v.addSubview(weekdayLabel)
//        }
//        
//        self.addSubview(v)
//        
//        return v
//        
//    }()
//    
//    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//    }
//    
//    override func layoutSubviews() {
//        
//        super.layoutSubviews()
//        
//        var frm = self.bounds
//        frm.origin.y += 5.0
//        frm.size.height = 40.0
//        
//        self.monthLabel.frame = frm
//        
//        
//        var labelFrame = CGRect(x: 0.0, y: self.bounds.size.height / 2.0, width: self.bounds.size.width / 7.0, height: self.bounds.size.height / 2.0)
//        
//        for lbl in self.dayLabelContainerView.subviews {
//            
//            lbl.frame = labelFrame
//            labelFrame.origin.x += labelFrame.size.width
//        }
//        
//        
//        
//    }
//}