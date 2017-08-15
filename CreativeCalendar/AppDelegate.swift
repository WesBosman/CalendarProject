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
import Locksmith


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let db = DatabaseFunctions.sharedInstance
    var auth: FIRAuth? = FIRAuth.auth()
    let firstLaunchKey = "firstLaunchKey"

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // Configure Firebase for application
        FIRApp.configure()
        
        // Get the remote config values from firebase
        let _ = RemoteConfigValues.sharedInstance
        
        
        // Asks the user if they would like to recieve notifications for alerts badges and sounds.
        application.registerUserNotificationSettings(UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil))
        
        let notFirstLaunch = UserDefaults.standard.bool(forKey: firstLaunchKey)
        if(notFirstLaunch){
            print("Is Not First Launch")
        }
        else{
            print("Is First Launch")
            // If its the first launch and the app got redownloaded cancel all previous notifications
            UIApplication.shared.cancelAllLocalNotifications()
        }
        
        return true
    }
    
    // Think this changes the color of the subtitle text to red once the time has passed.
    func application(_ application: UIApplication, didReceive notification: UILocalNotification) {
        
        // Let us know that the local notification was received
        print("Did receive a local notification")
        
        // Try to present a banner to the user showing the notification
        // This works
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "EEEE MM/dd/yyyy hh:mm:ss a"
        let todaysDate    = dateformatter.string(from: Date())
        let notificationFireDate = dateformatter.string(from: notification.fireDate!)
        print("Todays Date -> \(todaysDate)")
        print("Notification Date -> \(notificationFireDate)")
        print("Alert Title for notification -> \(String(describing: notification.alertTitle))")
        print("Alert Body for notification -> \(String(describing: notification.alertBody))")
        
        // Compare the current date with the notification fire date
        let dateIsEqual = Date().compare(notification.fireDate!) == ComparisonResult.orderedSame
        print(dateIsEqual)
        
        // do not fire up a banner unless the notification should fire
        if let alertTitle = notification.alertTitle{
            // Appointment Notification
            if alertTitle.hasPrefix("Appointment"){
                // Only fire the notification if the date matches todays date and time
                if todaysDate == notificationFireDate{
                    print("This Alert is for an Appointment")
                    print("Creating a banner for an Appointment")
                    let banner = Banner(title: notification.alertTitle,
                                        subtitle: notification.alertBody,
                                        image: UIImage(named: "Appointments"),
                                        backgroundColor: UIColor().appointmentColor,
                                        didTapBlock: nil)
                    banner.show(duration: 5)
                }
            }
            // Task Notification
            if alertTitle.hasPrefix("Task"){
                // If the app receives the notification because the app fire date was reached then display the banner
                if todaysDate == notificationFireDate{
                    print("This Alert is for a Task")
                    print("Creating a banner for a Task")
                    let banner = Banner(title: notification.alertTitle,
                                        subtitle: notification.alertBody,
                                        image: UIImage(named: "Tasks"),
                                        backgroundColor: UIColor().taskColor,
                                        didTapBlock: nil)
                    banner.show(duration: 5)
                }
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
        Tasks().setUpTaskDictionary()
        Journals().setUpJournalDictionary()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        
        // Sign the user out if they terminate the application
        if let auth = FIRAuth.auth(){
            try! auth.signOut()
        }
    }
}

