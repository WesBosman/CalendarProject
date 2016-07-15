//
//  DotView.swift
//  CreativeCalendar
//
//  Created by Wes Bosman on 7/13/16.
//  Copyright © 2016 Wes Bosman. All rights reserved.
//  Dont think I need this anymore.

import UIKit

@IBDesignable

class DotView: UIView {
    var view = UIView()
    
    @IBInspectable var appointmentColor:UIColor = UIColor.redColor()
    @IBInspectable var taskColor: UIColor = UIColor.greenColor()
    @IBInspectable var journalColor : UIColor = UIColor.yellowColor()

    @IBInspectable var borderColor: UIColor = UIColor.clearColor(){
        didSet{
            layer.borderColor = borderColor.CGColor
        }
    }
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet{
            layer.borderWidth = borderWidth
        }
    }
    @IBInspectable var borderRadius: CGFloat = 0{
        didSet{
            layer.cornerRadius = borderRadius
        }
    }
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
        let appointmentCircle = UIBezierPath(ovalInRect: CGRect(x: 35.0, y: 3.0, width: 25.0, height: 25.0))
        let taskCircle = UIBezierPath(ovalInRect: CGRect(x: 65.0, y: 3.0, width: 25.0, height: 25.0))
        let journalCircle = UIBezierPath(ovalInRect: CGRect(x: 95.0, y: 3.0, width: 25.0, height: 25.0))
        appointmentColor.setFill()
        appointmentCircle.fill()
        
        taskColor.setFill()
        taskCircle.fill()
        
        journalColor.setFill()
        journalCircle.fill()
        
        self.layer.backgroundColor = UIColor.clearColor().CGColor
        
    }
    
    // MARK - Initialization    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
}
