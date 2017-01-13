//
//  PasscodeLockViewController.swift
//  CreativeCalendar
//
//  Created by Wes Bosman on 1/12/17.
//  Copyright © 2017 Wes Bosman. All rights reserved.
//

import UIKit
import SmileLock


class PasscodeLockViewController: UIViewController, PasswordInputCompleteProtocol {
    
    @IBOutlet weak var stackView: UIStackView!
    let numberOfDigits = 6

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let p = PasswordContainerView.create(in: stackView, digit: numberOfDigits)
        p.touchAuthenticationEnabled = true
        p.tintColor = UIColor.flatPink
        p.delegate = self
        
        
//        let validation = MyPasswordUIValidation(in: stackView, digit: numberOfDigits)
//        
//        validation.view.delegate = self
//        
//        
//        validation.success = {
//            [weak self] _ in
//            print("Successful Password Entered")
//            validation.resetUI()
//        }
//        validation.failure = {
//            [weak self] _ in
//            print("Failed to Enter Correct Password")
//            validation.resetUI()
//        }
//        validation.view.highlightedColor = UIColor.flatSkyBlue
//        validation.view.tintColor = UIColor.purple
        

        
    }
    
    func passwordInputView(_ passwordInputView: PasswordInputView, tappedString: String) {
        print("Tapped String -> \(tappedString)")
    }
    
    func passwordInputComplete(_ passwordContainerView: PasswordContainerView, input: String) {
        print("Input Complete \(input)")
    }
    
    func touchAuthenticationComplete(_ passwordContainerView: PasswordContainerView, success: Bool, error: NSError?) {
        if success{
            print("Success!")
        }
        else{
            passwordContainerView.clearInput()
        }
        
        if let err = error{
            print("Error Touch Auth \(err.localizedDescription)")
        }
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

class MyPasswordModel{
    class func match(_ password: String) -> MyPasswordModel?{
        guard password == "123456"
            else{
                return nil
        }
        return MyPasswordModel()
    }
}

class MyPasswordUIValidation: PasswordUIValidation<MyPasswordModel>{
    init(in stackView: UIStackView, digit: Int){
        super.init(in: stackView, digit: digit)
        validation = { password in
            MyPasswordModel.match(password)
        }
    }
}

