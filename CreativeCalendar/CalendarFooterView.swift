//
//  CalendarFooterView.swift
//  CreativeCalendar
//
//  Created by Wes Bosman on 7/20/16.
//  Copyright © 2016 Wes Bosman. All rights reserved.
//

import UIKit

class CalendarFooterView: UIView {

        @IBInspectable var appointmentColor:UIColor = UIColor.redColor()
        @IBInspectable var taskColor:UIColor = UIColor.yellowColor()
        @IBInspectable var journalColor:UIColor = UIColor.greenColor()

    
        override func drawRect(rect: CGRect){
            let appointmentCircle = UIBezierPath(ovalInRect: CGRect(x: 35.0, y: 35.0, width: 25, height: 25))
            appointmentColor.setFill()
            appointmentCircle.fill()
            
            let taskCircle = UIBezierPath(ovalInRect: CGRect(x: 35.0, y: 85.0, width: 25, height: 25))
            taskColor.setFill()
            taskCircle.fill()
            
            
            let journalCircle = UIBezierPath(ovalInRect: CGRect(x: 35.0, y: 135.0, width: 25, height: 25))
            journalColor.setFill()
            journalCircle.fill()
            
        }
        
        // MARK - Initialization methods
        
        override init(frame: CGRect) {
            // Properties
            
            // Set up
            super.init(frame: frame)
            
            // Xib
//            xibSetup()
        }
        
        required init?(coder aDecoder: NSCoder) {
            // Properties
            
            // Set up
            super.init(coder: aDecoder)
            
            // Xib
//            xibSetup()
        }
        
        // Our custom view from the XIB file
//        var view: UIView!
//        
//        func xibSetup() {
//            view = loadViewFromNib()
//            
//            // use bounds not frame or it'll be offset
//            view.frame = bounds
//            
//            // Make the view stretch with containing view
//            view.autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleHeight]
//            // Adding custom subview on top of our view (over any custom drawing > see note below)
//            addSubview(view)
//        }
//        
//        func loadViewFromNib() -> UIView {
//            
//            let bundle = NSBundle(forClass: self.dynamicType)
//            let nib = UINib(nibName: "FooterView", bundle: bundle)
//            let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
//            
//            return view
//        }
}
