//
//  AppDelegate.swift
//  CreativeCalendar
//
//  Created by student on 1/27/16.
//  Copyright (c) 2016 Wes Bosman. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var dbFilePath: NSString = NSString()
    let defaults = NSUserDefaults.standardUserDefaults()
    let loginKey = "UserLogin"
    let forgotLoginKey = "UserForgotLogin"
    
    // Set up the global dictionaries for the calendars and tables
    let db = DatabaseFunctions.sharedInstance
    var appointmentItems:[AppointmentItem] = []
    var taskItems:[TaskItem] = []
    var journalItems:[JournalItem] = []
    var appointmentSections:[String] = []
    var taskSections:[String] = []
    var journalSections: [String] = []
    let formatter = NSDateFormatter().dateWithoutTime

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        // Asks the user if they would like to recieve notifications for alerts badges and sounds.
        application.registerUserNotificationSettings(UIUserNotificationSettings(forTypes: [.Alert, .Badge, .Sound], categories: nil))
        
        return true
    }
    
    // Think this changes the color of the subtitle text to red once the time has passed.
    func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
        
        NSNotificationCenter.defaultCenter().postNotificationName("AppointmentListShouldRefresh", object: self)
        // If the app is running the user will not recieve a notification so we should alert them.
        // We could also add a badge to the tab bar for appointments.
        let state: UIApplicationState = UIApplication.sharedApplication().applicationState
        let date = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let components = NSDateComponents()
        let dateFormatter = NSDateFormatter().universalFormatter
        components.second = 0
        let newDate = calendar.dateByAddingComponents(components, toDate: date, options: .MatchStrictly)
        
        if let hostController = self.window?.rootViewController{

        if state == UIApplicationState.Active{
            let db = DatabaseFunctions.sharedInstance
            print("Date in App Delegate: \(dateFormatter.stringFromDate(newDate!))")
            print("Date for Db fetch: \(dateFormatter.stringFromDate(date))")
            
            var currentController = hostController
            while(currentController.presentedViewController != nil){
                currentController = currentController.presentedViewController!
            }
            // Get the title of the appointment based on the notification fire date
            let appointment = db.getAppointmentByDate(dateFormatter.stringFromDate(newDate!), formatter: dateFormatter)
            
            for app in appointment{
            let alert: UIAlertController = UIAlertController(title: "Alert", message: "Appointment is starting: \(app.title)", preferredStyle: .Alert)
            let dismissAction = UIAlertAction(title: "Dismiss", style: .Default, handler: nil)
                            alert.addAction(dismissAction)
            
            
            // Update the badge for the appointments.
            if let tbc: UITabBarController = self.window?.rootViewController as? UITabBarController{
                tbc.tabBar.items?[1].badgeValue = "1"
            }
            currentController.presentViewController(alert, animated: true, completion: nil)
            }
            }
        }
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        defaults.removeObjectForKey(loginKey)
        defaults.removeObjectForKey(forgotLoginKey)
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        NSNotificationCenter.defaultCenter().postNotificationName("AppointmentListShouldRefresh", object: self)
        
        setUpAppointments()
        setUpTasks()
        setUpJournals()
    }
    
    func setUpAppointments(){
        appointmentItems = db.getAllAppointments()
        
        // Sort appointments based on starting time
        appointmentItems = appointmentItems.sort({$0.startingTime.compare($1.startingTime) == NSComparisonResult.OrderedAscending })
        
        for appointment in appointmentItems{
            let appointmentDate = formatter.stringFromDate(appointment.startingTime)
            
            // If appointment sections does not contain the journal date add it
            if(!appointmentSections.contains(appointmentDate)){
                appointmentSections.append(appointmentDate)
            }
        }
        
        for section in appointmentSections{
            // Get appointments based on their date
            appointmentItems = db.getAppointmentByDate(section, formatter: formatter)
            
            // Set up the global appointments dictionary
            GlobalAppointments.appointmentDictionary.updateValue(appointmentItems, forKey: section)
        }
    }
    
    func setUpTasks(){
        taskItems = db.getAllTasks()
        
        // Sort the tasks based on estimated completion date
        taskItems = taskItems.sort({$0.estimateCompletionDate.compare($1.estimateCompletionDate) == NSComparisonResult.OrderedAscending})
            
        for task in taskItems{
            let taskDate = formatter.stringFromDate(task.estimateCompletionDate)
            
            // If task sections does not contain the date add it
            if(!taskSections.contains(taskDate)){
                taskSections.append(taskDate)
            }
        }
        
        for section in taskSections{
            // Get the tasks based on their date
            taskItems = db.getTaskByDate(section, formatter: formatter)
            
            // Set the global task dictionary
            GlobalTasks.taskDictionary.updateValue(taskItems, forKey: section)
        }
        
    }
    
    func setUpJournals(){
        journalItems = db.getAllJournals()
        
        // Sort the journals based on their dates
        journalItems = journalItems.sort({$0.journalDate.compare($1.journalDate) == NSComparisonResult.OrderedAscending})
        
        for journal in journalItems{
            let journalDate = formatter.stringFromDate(journal.journalDate)
            
            // If the journal sections array does not contain the date then add it
            if(!journalSections.contains(journalDate)){
                journalSections.append(journalDate)
            }
        }
        
        for section in journalSections{
            // Get journal items based on the date
            journalItems = db.getJournalByDate(section, formatter: formatter)
            
            // Set the global journal dictionary
            GlobalJournals.journalDictionary.updateValue(journalItems, forKey: section)
        }

    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        defaults.removeObjectForKey(loginKey)
        defaults.removeObjectForKey(forgotLoginKey)
    }


}

