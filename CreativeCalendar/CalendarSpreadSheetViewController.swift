//
//  CalendarSpreadSheetViewController.swift
//  CreativeCalendar
//
//  Created by Wes Bosman on 8/8/17.
//  Copyright © 2017 Wes Bosman. All rights reserved.
//

import UIKit
import SpreadsheetView

class CalendarSpreadSheetViewController:
    UIViewController,
    SpreadsheetViewDataSource,
    SpreadsheetViewDelegate{

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    // MARK - Datasource Methods
    
    func spreadsheetView(_ spreadsheetView: SpreadsheetView, heightForRow row: Int) -> CGFloat {
        return 80
    }
    
    func spreadsheetView(_ spreadsheetView: SpreadsheetView, widthForColumn column: Int) -> CGFloat {
        return 100
    }
    
    func numberOfRows(in spreadsheetView: SpreadsheetView) -> Int {
        return 7
    }
    
    func numberOfColumns(in spreadsheetView: SpreadsheetView) -> Int {
        return 12
    }
    
    // MARK - Delegate Methods
    
    func spreadsheetView(_ spreadsheetView: SpreadsheetView, cellForItemAt indexPath: IndexPath) -> Cell? {
        let cell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: "spreadSheetCell", for: indexPath)
        
        return cell
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
