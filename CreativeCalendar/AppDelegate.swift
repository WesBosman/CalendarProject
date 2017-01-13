//
//  AppDelegate.swift
//  CreativeCalendar
//
//  Created by student on 1/27/16.
//  Copyright (c) 2016 Wes Bosman. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import BRYXBanner

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let defaults = UserDefaults.standard
    let loginKey = "UserLogin"
    let db = DatabaseFunctions.sharedInstance
    var auth: FIRAuth? = FIRAuth.auth()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // Configure Firebase for application
        FIRApp.configure()
        
        // Asks the user if they would like to recieve notifications for alerts badges and sounds.
        application.registerUserNotificationSettings(UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil))
        
        return true
    }
    
    // Think this changes the color of the subtitle text to red once the time has passed.
    func application(_ application: UIApplication, didReceive notification: UILocalNotification) {
        
        // Let us know that the local notification was received
        print("Did receive a local notification")
        
        // Try to present a banner to the user showing the notification
        // This works
        if let alertBody = notification.alertBody{
            print("Notification Alert Body -> \(alertBody)")
            if alertBody.hasPrefix("Appointment"){
                print("This Alert is for an Appointment")
                print("Creating a banner for an Appointment")
                let banner = Banner(title: notification.alertTitle, subtitle: alertBody, image: UIImage(named: "Appointments"), backgroundColor: UIColor().appointmentColor, didTapBlock: nil)
                banner.show(duration: 3)
            }
            else if alertBody.hasPrefix("Task"){
                print("This Alert is for a Task")
                print("Creating a banner for a Task")
                let banner = Banner(title: notification.alertTitle, subtitle: alertBody, image: UIImage(named: "Tasks"), backgroundColor: UIColor().taskColor, didTapBlock: nil)
                banner.animationDuration = 3
                banner.show(duration: 3)
            }
        }
        
        // Should update and refresh tasks and appointments to update 
        // The outdated color or a missed appointment or task
        NotificationCenter.default.post(name: Notification.Name(rawValue: "AppointmentListShouldRefresh"), object: self)
        NotificationCenter.default.post(name: Notification.Name(rawValue: "TaskListShouldRefresh"), object: self)
        NotificationCenter.default.post(name: Notification.Name(rawValue: "HomeTablesShouldRefresh"), object: self)

    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.

    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.

    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
        
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        NotificationCenter.default.post(name: Notification.Name(rawValue: "AppointmentListShouldRefresh"), object: self)
        NotificationCenter.default.post(name: Notification.Name(rawValue: "TaskListShouldRefresh"), object:self)
        NotificationCenter.default.post(name: Notification.Name(rawValue: "HomeTablesShouldRefresh"), object: self)
        
        // Initially get the appointments, tasks and journals from the database and put them
        // Into globally accessible dictionaries
        Appointments().setUpAppointmentDictionary()
        GlobalTasks().setUpTaskDictionary()
        GlobalJournals().setUpJournalDictionary()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        
        // Sign the user out if they terminate the application
        if let auth = FIRAuth.auth(){
            try! auth.signOut()
        }
    }
}

