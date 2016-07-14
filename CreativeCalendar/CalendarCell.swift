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

extension UIColor {
    convenience init(colorWithHexValue value: Int, alpha:CGFloat = 1.0){
        self.init(
            red: CGFloat((value & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((value & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(value & 0x0000FF) / 255.0,
            alpha: alpha
        )
    }
}

@IBDesignable

class CalendarCell: JTAppleDayCellView{
    
    @IBInspectable var fillColorForCircle: UIColor = UIColor.blackColor()
    @IBOutlet weak var dayLabel: UILabel!
    var weekendDayColor = UIColor(colorWithHexValue: 0x574865)
    var normalDayColor = UIColor(colorWithHexValue: 0xECEAED)
    var isSelected = false
    
    override class func layerClass() -> AnyClass{
        return CAGradientLayer.self
    }
    var gradientLayer: CAGradientLayer{
        return layer as! CAGradientLayer
    }
    
    func setUpCellBeforeDisplay(cellState: CellState, date: NSDate){
        dayLabel.text = cellState.text
        configureTextColor(cellState)
    }
    
    func configureTextColor(cellState:CellState){
        if cellState.dateBelongsTo == .ThisMonth{
            
            // Change text and circle color.
            dayLabel.textColor = normalDayColor
            
            // Allow the cell to be clicked
            self.userInteractionEnabled = true
            
            // Dont hide the cell
            self.hidden = false
        }
        else{
            // Change text and circle color.
            dayLabel.textColor = weekendDayColor
            self.fillColorForCircle = UIColor.lightGrayColor()
            
            // Prevent the cell from being clicked
            self.userInteractionEnabled = false
            
            // Hide the cell
            self.hidden = true
        }
    }
    
    // Draw the view
    override func drawRect(rect: CGRect) {
        
        let path = UIBezierPath(ovalInRect: CGRect(x: 22.5 , y: 50 , width: 100, height: 100))
        fillColorForCircle.setFill()
        
//        let startColor = UIColor(red: 102/255.0, green: 204/255.0, blue: 128/255.0, alpha: 1.0).CGColor
//        let endColor = UIColor(red: 0.0, green: 24/255.0, blue: 1.0, alpha: 1.0).CGColor
//        self.gradientLayer.colors = [startColor, endColor]
        
        path.fill()
    }
    
    // MARK - Initialization methods
    
    override init(frame: CGRect) {
        super.init(frame: frame)
//        self.alpha = 0.5
//        self.layer.cornerRadius = self.frame.height / 2

    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}