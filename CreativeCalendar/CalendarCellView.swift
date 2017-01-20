//
//  CalendarCellView.swift
//  CreativeCalendar
//
//  Created by Wes Bosman on 1/18/17.
//  Copyright © 2017 Wes Bosman. All rights reserved.
//

import UIKit

@IBDesignable

class CalendarCellView: UIView {
    
//    @IBInspectable
//    public var cornerRadius: CGFloat {
//        didSet{
//            self.layer.cornerRadius  = cornerRadius
//        }
//    }
//    
//    @IBInspectable
//    public var firstColor: UIColor = UIColor.flatRed
//    
//    @IBInspectable
//    public var secondColor: UIColor = UIColor.flatBlue
//    
//    @IBInspectable
//    public var thirdColor: UIColor = UIColor.white
    
//    @IBInspectable
//    public var cellX: CGFloat?{
//        didSet{
//            self.cellx = cellX
//        }
//    }
//    
//    @IBInspectable
//    public var cellY:CGFloat?{
//        didSet{
//            self.celly = cellY
//        }
//    }
    
//    @IBInspectable
//    override public var backgroundColor: UIColor? {
//        didSet{
//            self.layer.backgroundColor = backgroundColor as! CGColor?
//        }
//    }
    
//    var label: UILabel
//    var imageView: UIImageView
//    let path = UIBezierPath(rect: CGRect(x: 30, y: 30, width: 10, height: 10)).cgPath
//    
//    public override init(frame: CGRect) {
//        self.cornerRadius = 0
//        self.label = UILabel()
//        self.imageView = UIImageView()
//        
//        super.init(frame: frame)
//        addSubviews()
//        
//    }
//    public required init?(coder aDecoder: NSCoder) {
//        self.cornerRadius = 0
//        self.label = UILabel()
//        self.imageView = UIImageView()
//        
//        super.init(coder: aDecoder)
//        addSubviews()
//    }
//    
//    override func prepareForInterfaceBuilder() {
//        super.prepareForInterfaceBuilder()
//    }
//
//    // Only override draw() if you perform custom drawing.
//    // An empty implementation adversely affects performance during animation.
//    override func draw(_ rect: CGRect) {
//        // Drawing code
//        addSubviews()
//        
//    }
//    
//    func addSubviews(){
//        label = UILabel()
//        label.text = "This is a test"
//        addSubview(label)
//    }
//    
//    func addCircle(path: CGPath, color: UIColor, start: CGFloat, end: CGFloat){
//        let stroke = CAShapeLayer()
//        stroke.path = path
//        stroke.fillColor = color.cgColor
//        stroke.strokeStart = start
//        stroke.strokeEnd = end
//        self.layer.addSublayer(stroke)
//    }
    
//    func addCircle(arcRadius: CGFloat, capRadius: CGFloat, color: UIColor){
//        let midX = self.bounds.midX
//        let midY = self.bounds.midY
//        
//        let pathBottom = UIBezierPath(ovalIn: CGRect(x: (midX - (arcRadius/2)), y: (midY - (arcRadius/2)), width: arcRadius, height: arcRadius)).cgPath
//        self.addOval(lineWidth: 20.0, path: pathBottom, strokeStart: 0, strokeEnd: 0.5, strokeColor: color, fillColor: UIColor.clear, shadowRadius: 0, shadowOpacity: 0, shadowOffset: CGSize.zero)
//        
//        let pathMiddle = UIBezierPath(ovalIn: CGRect(x: (midX - (capRadius/2)) - (arcRadius/2), y: (midY - (capRadius/2)), width: capRadius, height: capRadius)).cgPath
//        self.addOval(lineWidth: 0.0, path: pathMiddle, strokeStart: 0, strokeEnd: 1.0, strokeColor: color, fillColor: color, shadowRadius: 5.0, shadowOpacity: 0.5, shadowOffset: CGSize.zero)
//
//        let pathTop = UIBezierPath(ovalIn: CGRect(x: (midX - (arcRadius/2)), y: (midY - (arcRadius/2)), width: arcRadius, height: arcRadius)).cgPath
//        self.addOval(lineWidth: 20.0, path: pathTop, strokeStart: 0.5, strokeEnd: 1.0, strokeColor: color, fillColor: UIColor.clear, shadowRadius: 0, shadowOpacity: 0, shadowOffset: CGSize.zero)
//
//    }
//    
//    func addOval(lineWidth: CGFloat, path:CGPath, strokeStart: CGFloat, strokeEnd: CGFloat, strokeColor: UIColor, fillColor: UIColor, shadowRadius: CGFloat, shadowOpacity: Float, shadowOffset: CGSize){
//        
//        let arc = CAShapeLayer()
//        arc.lineWidth     = lineWidth
//        arc.path          = path
//        arc.strokeStart   = strokeStart
//        arc.strokeEnd     = strokeEnd
//        arc.strokeColor   = strokeColor.cgColor
//        arc.fillColor     = fillColor.cgColor
//        arc.shadowRadius  = shadowRadius
//        arc.shadowOpacity = shadowOpacity
//        arc.shadowOffset  = shadowOffset
//        self.layer.addSublayer(arc)
//        
//    }
}
