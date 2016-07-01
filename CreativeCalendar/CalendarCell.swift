//
//  CalendarCollectionViewCell.swift
//  CreativeCalendar
//
//  Created by Wes Bosman on 6/29/16.
//  Copyright © 2016 Wes Bosman. All rights reserved.
//  Followed Tutorial by by Michael Michailidis

import UIKit
import JTAppleCalendar

let cellColorDefault = UIColor(white: 0.0, alpha: 0.1)
let cellColorToday = UIColor(red: 254.0/255.0, green: 73.0/255.0, blue: 64.0/255.0, alpha: 0.3)
let borderColor = UIColor(red: 254.0/255.0, green: 73.0/255.0, blue: 64.0/255.0, alpha: 0.8)

class CalendarCell: JTAppleDayCellView{
    
    @IBOutlet weak var dayLabel: UILabel!
    var normalDayColor = UIColor.blackColor()
    var weekendDayColor = UIColor.grayColor()

    
    func setUpCellBeforeDisplay(cellState: CellState, date: NSDate){
        dayLabel.text = cellState.text
        configureTextColor(cellState)
    }
    
    func configureTextColor(cellState:CellState){
        if cellState.dateBelongsTo == .ThisMonth{
            dayLabel.textColor = normalDayColor
        }
        else{
            dayLabel.textColor = weekendDayColor
        }
    }
}



//class CalendarCell: UICollectionViewCell {
//    
//    @IBOutlet weak var dayLabel: UILabel!
//    
//    var eventsCount = 0 {
//        didSet {
//            for sview in self.dotsView.subviews {
//                sview.removeFromSuperview()
//            }
//            
//            let stride = self.dotsView.frame.size.width / CGFloat(eventsCount+1)
//            let viewHeight = self.dotsView.frame.size.height
//            let halfViewHeight = viewHeight / 2.0
//            
//            for _ in 0..<eventsCount {
//                let frm = CGRect(x: (stride+1.0) - halfViewHeight, y: 0.0, width: viewHeight, height: viewHeight)
//                let circle = UIView(frame: frm)
//                circle.layer.cornerRadius = halfViewHeight
//                circle.backgroundColor = UIColor.whiteColor()
//                self.dotsView.addSubview(circle)
//            }
//        }
//    }
//    
//    var isToday : Bool = false {
//        
//        didSet {
//            
//            if isToday == true {
//                self.pBackgroundView.backgroundColor = cellColorToday
//            }
//            else {
//                self.pBackgroundView.backgroundColor = cellColorDefault
//            }
//        }
//    }
//    
//    override var selected : Bool {
//        
//        didSet {
//            
//            if selected == true {
//                self.pBackgroundView.layer.borderWidth = 3.0
//                
//            }
//            else {
//                self.pBackgroundView.layer.borderWidth = 0.0
//            }
//            
//        }
//    }
//    
//    lazy var pBackgroundView : UIView = {
//        
//        var vFrame = CGRectInset(self.frame, 25.0, 25.0)
//        
//        let view = UIView(frame: vFrame)
//        
//        view.layer.cornerRadius = view.bounds.size.width/2
//        view.layer.borderColor = borderColor.CGColor
//        view.layer.borderWidth = 6.0
//
//        view.center = CGPoint(x: self.bounds.size.width * 0.90, y: self.bounds.size.height * 0.90)
//        
//        return view
//    }()
//    
//    lazy var textLabel : UILabel = {
//        
//        let lbl = UILabel()
//        lbl.textAlignment = NSTextAlignment.Center
//        lbl.textColor = UIColor.darkGrayColor()
//        
//        return lbl
//        
//    }()
//    
//    lazy var dotsView : UIView = {
//        
//        let frm = CGRect(x:self.frame.size.height - 10, y: self.frame.size.width - 10, width: self.frame.size.width, height: self.frame.size.height)
//        let dv = UIView(frame: frm)
//        
//        return dv
//    }()
//    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        self.addSubview(self.pBackgroundView)
//        self.textLabel.frame = self.bounds
//        self.addSubview(self.textLabel)
//        self.addSubview(dotsView)
//    }
//    
//    // This is the initial cell.
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//        self.layer.borderWidth = 2
//        self.layer.borderColor = UIColor.blackColor().CGColor
//        self.layer.cornerRadius = 8
//        
//        let viewOne = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height))
//        self.backgroundView = viewOne
//        self.backgroundView!.layer.borderColor = UIColor.blackColor().CGColor
//        
//        let viewTwo = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height ))
//        self.selectedBackgroundView = viewTwo
//        self.selectedBackgroundView?.addSubview(pBackgroundView)
//        self.selectedBackgroundView!.layer.borderWidth = 3.0
//        self.selectedBackgroundView?.layer.borderColor = UIColor.redColor().CGColor
//    }
//}
