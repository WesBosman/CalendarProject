//
//  DotView.swift
//  CreativeCalendar
//
//  Created by Wes Bosman on 7/13/16.
//  Copyright © 2016 Wes Bosman. All rights reserved.
//

import UIKit

@IBDesignable

class DotView: UIView {
    var view = UIView()
    
    override class func layerClass() -> AnyClass{
        return CAGradientLayer.self
    }
    var gradientLayer: CAGradientLayer{
        return layer as! CAGradientLayer
    }
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
        layer.borderWidth = 3
        layer.cornerRadius = 20
        layer.borderColor = UIColor(red: 0.0, green: 64/255.0, blue: 128/255.0, alpha: 1.0).CGColor
        
        let startColor = UIColor(red: 102/255.0, green: 204/255.0, blue: 128/255.0, alpha: 1.0).CGColor
        let endColor = UIColor(red: 0.0, green: 24/255.0, blue: 1.0, alpha: 1.0).CGColor
        gradientLayer.colors = [startColor, endColor]
    }
    
    // MARK - Initialization    
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//    }
    
    
//    func displayView(onView: UIView) {
//        self.alpha = 0.0
//        onView.addSubview(self)
//        
//        onView.addConstraint(NSLayoutConstraint(item: self, attribute: .CenterY, relatedBy: .Equal, toItem: onView, attribute: .CenterY, multiplier: 1.0, constant: -80.0)) // move it a bit upwards
//        onView.addConstraint(NSLayoutConstraint(item: self, attribute: .CenterX, relatedBy: .Equal, toItem: onView, attribute: .CenterX, multiplier: 1.0, constant: 0.0))
//        onView.needsUpdateConstraints()
//        
//        // display the view
//        transform = CGAffineTransformMakeScale(0.1, 0.1)
//        UIView.animateWithDuration(0.3, animations: { () -> Void in
//            self.alpha = 1.0
//            self.transform = CGAffineTransformIdentity
//        }) { (finished) -> Void in
//            // When finished wait 1.5 seconds, than hide it
//            let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(1.5 * Double(NSEC_PER_SEC)))
//            dispatch_after(delayTime, dispatch_get_main_queue()) {
////                self.hideView()
//            }
//        }
//    }
//    
//    func loadViewFromXibFile() -> UIView {
//        let bundle = NSBundle(forClass: self.dynamicType)
//        let nib = UINib(nibName: "DotView", bundle: bundle)
//        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
//        return view
//    }
//    
//    override func updateConstraints() {
//        super.updateConstraints()
//        
//        addConstraint(NSLayoutConstraint(item: self, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 170.0))
//        addConstraint(NSLayoutConstraint(item: self, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 200.0))
//        
//        addConstraint(NSLayoutConstraint(item: view, attribute: .Top, relatedBy: .Equal, toItem: self, attribute: .Top, multiplier: 1.0, constant: 0.0))
//        addConstraint(NSLayoutConstraint(item: view, attribute: .Bottom, relatedBy: .Equal, toItem: self, attribute: .Bottom, multiplier: 1.0, constant: 0.0))
//        addConstraint(NSLayoutConstraint(item: view, attribute: .Trailing, relatedBy: .Equal, toItem: self, attribute: .Trailing, multiplier: 1.0, constant: 0.0))
//        addConstraint(NSLayoutConstraint(item: view, attribute: .Leading, relatedBy: .Equal, toItem: self, attribute: .Leading, multiplier: 1.0, constant: 0.0))
//    }
//    
//    func setUpView(){
//        view = loadViewFromXibFile()
//        view.frame = bounds
//        view.translatesAutoresizingMaskIntoConstraints = false
//        addSubview(view)
//        
//        translatesAutoresizingMaskIntoConstraints = false
//        
//        //titleLabel.text = NSLocalizedString("Saved_to_garage", comment: "")
//        
//        /// Adds a shadow to our view
//        view.layer.cornerRadius = 4.0
//        view.layer.shadowColor = UIColor.blackColor().CGColor
//        view.layer.shadowOpacity = 0.2
//        view.layer.shadowRadius = 4.0
//        view.layer.shadowOffset = CGSizeMake(0.0, 8.0)
//        
//        visualEffectView.layer.cornerRadius = 4.0
//    }

}
