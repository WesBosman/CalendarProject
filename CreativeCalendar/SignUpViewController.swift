//
//  SignUpViewController.swift
//  CreativeCalendar
//
//  Created by Wes Bosman on 11/7/16.
//  Copyright © 2016 Wes Bosman. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var signUpGreetingLabel: UILabel!
    @IBOutlet weak var signUpEmailAddress: UITextField!
    @IBOutlet weak var signUpPassword: UITextField!
    @IBOutlet weak var signUpPasswordConfirm: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var backToLoginButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
        
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
