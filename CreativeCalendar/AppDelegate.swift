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
        let hostController = self.window?.rootViewController
        let date = NSDate()
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "EEEE MM/dd/yyyy hh:mm:ss a"
        
        if state == UIApplicationState.Active{
            let db = DatabaseFunctions.sharedInstance
            print("Date in AppDelegate: \(dateFormatter.stringFromDate(date))")
            
            // Get the title of the appointment based on the notification fire date
            let appointmentTitle = db.getAppointmentByDate(dateFormatter.stringFromDate(date))
            let alert: UIAlertController = UIAlertController(title: "Alert", message: "Appointment is starting: \(appointmentTitle)", preferredStyle: .Alert)
            let dismissAction = UIAlertAction(title: "Dismiss", style: .Default, handler: nil)
            alert.addAction(dismissAction)
            
            // Update the badge for the appointments.
            if let tbc: UITabBarController = self.window?.rootViewController as? UITabBarController{
                tbc.tabBar.items?[1].badgeValue = "1"
            }
            hostController?.presentViewController(alert, animated: true, completion: nil)
            
        }
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        NSNotificationCenter.defaultCenter().postNotificationName("AppointmentListShouldRefresh", object: self)
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

