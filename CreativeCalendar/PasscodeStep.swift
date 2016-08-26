//
//  PasscodeStep.swift
//  CreativeCalendar
//
//  Created by Wes Bosman on 8/23/16.
//  Copyright © 2016 Wes Bosman. All rights reserved.
//

import ResearchKit

class PasscodeStep: ORKPasscodeStep {
    
    var passcodeSteps = [ORKPasscodeStep]()
    
    let passcodeStep:ORKPasscodeStep = ORKPasscodeStep.init(identifier: "PassCode")
        
}
