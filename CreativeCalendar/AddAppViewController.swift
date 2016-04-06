//
//  AddAppViewController.swift
//  CreativeCalendar
//
//  Created by Wes on 2/19/16.
//  Copyright (c) 2016 Wes Bosman. All rights reserved.
//

import UIKit

class AddAppViewController:  UIViewController, UIPopoverControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource{

    @IBOutlet weak var typeOfEventPicker: UIPickerView!
    @IBOutlet weak var eventNameLabel: UITextField!
    @IBOutlet weak var startDatePicker: UIDatePicker!
    @IBOutlet weak var endDatePicker: UIDatePicker!
    @IBOutlet weak var locationDescription: UITextField!
    @IBOutlet weak var additionalInfoDescription: UITextView!
    
    //var pickerData: [String] = [String]()
    var pickerData = ["Diet", "Doctor", "Exercise", "Household Chores", "Mediction", "Leisure", "Project", "Self Care", "Social", "Travel"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.typeOfEventPicker.delegate = self
        self.typeOfEventPicker.dataSource = self
        

        // Do any additional setup after loading the view.
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
        if segue.identifier == "addPop"{
            let popOverViewController = segue.destinationViewController as! UIViewController
            popOverViewController.modalPresentationStyle = UIModalPresentationStyle.Popover
            //popOverViewController.popoverPresentationController!.delegate = self
            
        }
        
    }
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.None
    }
    */
    
    
    
   /* -----------------------------------------------------------------------------------------------------
    *  The Methods below are for the type of event picker.
    */
    // The number of columns of data
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // The number of rows of data
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    // The data to return for the row and component (column) that's being passed in
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    // Catpure the type of event the user picked.
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // This method is triggered whenever the user makes a change to the picker selection.
        // The parameter named row and component represents what was selected.
    }
    /* ----------------------------------------------------------------------------------------------------
    */


}
