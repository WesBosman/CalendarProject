//
//  PopoverViewController.swift
//  CreativeCalendar
//
//  Created by Wes Bosman on 7/20/16.
//  Copyright © 2016 Wes Bosman. All rights reserved.
//

import UIKit

class PopoverViewController: UIViewController , UIScrollViewDelegate {
    
    let pageTitles = ["Appointments", "Tasks", "Journals"]
    let pageControl:UIPageControl = UIPageControl(frame: CGRectMake(150, 260, 200, 25))
    let scrollView: UIScrollView = UIScrollView(frame: CGRectMake(20, 20, 260, 225))
    var colors: [UIColor] = [UIColor.redColor(), UIColor.greenColor(), UIColor.yellowColor()]
    var frame = CGRectMake(0, 0, 0, 0)
    var appointment:String = String()
    var task:String = String()
    var journal:String = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        print("Appointment Label: \(appointment)")
        print("Task Label: \(task)")
        print("Journal Label: \(journal)")

        
        configurePageController()
        scrollView.layer.cornerRadius = 10
        self.scrollView.delegate = self
        self.view.addSubview(scrollView)
        
        for index in 0..<3 {
            
            frame.origin.x = self.scrollView.frame.size.width * CGFloat(index)
            frame.size = self.scrollView.frame.size
            self.scrollView.pagingEnabled = true
            
            switch(index){
            case 0:
                // Appointment subview
                let subView = UIView(frame: frame)
                subView.backgroundColor = colors[index]
                let appointmentHeader = UILabel(frame: CGRect(x: 10, y: 10, width: subView.frame.width - 10, height: 20))
                appointmentHeader.text = "Appointments"
                let appointmentLabel = UILabel(frame: CGRect(x: 10, y: 20, width: subView.frame.width - 10, height: subView.frame.height))
                appointmentLabel.lineBreakMode = .ByWordWrapping
                appointmentLabel.numberOfLines = 0
                appointmentLabel.text = appointment
                subView.addSubview(appointmentHeader)
                subView.addSubview(appointmentLabel)
                self.scrollView .addSubview(subView)
                
            case 1:
                // Task subview
                let subView = UIView(frame: frame)
                subView.backgroundColor = colors[index]
                let taskHeader = UILabel(frame: CGRect(x: 10, y: 10, width: subView.frame.width - 10, height: 20))
                taskHeader.text = "Tasks"
                let taskLabel = UILabel(frame: CGRect(x: 10, y: 20, width: subView.frame.width - 10, height: subView.frame.height))
                taskLabel.lineBreakMode = .ByWordWrapping
                taskLabel.numberOfLines = 0
                taskLabel.text = task
                subView.addSubview(taskHeader)
                subView.addSubview(taskLabel)
                self.scrollView .addSubview(subView)
                
            case 2:
                // Journal subview
                let subView = UIView(frame: frame)
                subView.backgroundColor = colors[index]
                let journalHeader = UILabel(frame: CGRect(x: 10, y: 10, width: subView.frame.width - 10, height: 20))
                journalHeader.text = "Journals"
                let journalLabel = UILabel(frame: CGRect(x: 10, y: 20, width: subView.frame.width - 10, height: subView.frame.height))
                journalLabel.lineBreakMode = .ByWordWrapping
                journalLabel.numberOfLines = 0
                journalLabel.text = journal
                subView.addSubview(journalHeader)
                subView.addSubview(journalLabel)
                self.scrollView .addSubview(subView)
                
            default:
                break
                
            }
        }
        
        self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width * 4, self.scrollView.frame.size.height)
        pageControl.addTarget(self, action: #selector(PopoverViewController.changePage(_:)), forControlEvents: UIControlEvents.ValueChanged)
    }
    
    func configurePageController(){
        pageControl.numberOfPages = colors.count
        pageControl.currentPage = 0
        pageControl.pageIndicatorTintColor = UIColor.whiteColor()
        pageControl.backgroundColor = UIColor.blueColor()
        pageControl.currentPageIndicatorTintColor = UIColor.blackColor()
        self.view.addSubview(pageControl)
    }
    
    func changePage(sender: AnyObject) -> () {
        let x = CGFloat(pageControl.currentPage) * scrollView.frame.size.width
        scrollView.setContentOffset(CGPointMake(x, 0), animated: true)
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
        pageControl.currentPage = Int(pageNumber)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
