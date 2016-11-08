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

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let defaults = UserDefaults.standard
    let loginKey = "UserLogin"
    let db = DatabaseFunctions.sharedInstance
    let formatter = DateFormatter().dateWithoutTime
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
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: "AppointmentListShouldRefresh"), object: self)
        NotificationCenter.default.post(name: Notification.Name(rawValue: "TaskListShouldRefresh"), object: self)
        
        // If the app is running the user will not recieve a notification so we should alert them.
        // We could also add a badge to the tab bar for appointments.
        let state: UIApplicationState = UIApplication.shared.applicationState
        let date = Date()
        let calendar = Calendar.current
        var components = DateComponents()
        let dateFormatter = DateFormatter().universalFormatter
        components.second = 0
        let newDate = (calendar as NSCalendar).date(byAdding: components, to: date, options: .matchStrictly)
        
        if let hostController = self.window?.rootViewController{

        if state == UIApplicationState.active{
            print("Date in App Delegate: \(dateFormatter.string(from: newDate!))")
            print("Date for Db fetch: \(dateFormatter.string(from: date))")
            
            var currentController = hostController
            while(currentController.presentedViewController != nil){
                currentController = currentController.presentedViewController!
            }
            // Get the title of the appointment based on the notification fire date
            let appointment = db.getAppointmentByDate(dateFormatter.string(from: newDate!), formatter: dateFormatter)
            
            let task = db.getTaskByDate(dateFormatter.string(from: newDate!), formatter: dateFormatter)
            
            // Get the appointment that has started the notification
            for app in appointment{
                let alert: UIAlertController = UIAlertController(title: "Alert", message: "Appointment is starting: \(app.title)", preferredStyle: .alert)
                let dismissAction = UIAlertAction(title: "Dismiss", style: .default, handler: nil)
                            alert.addAction(dismissAction)
            
            
                // Update the badge for the appointments.
                if let tbc: UITabBarController = self.window?.rootViewController as? UITabBarController{
                    tbc.tabBar.items?[1].badgeValue = "1"
                }
                currentController.present(alert, animated: true, completion: nil)
            }
            
            // Get the task that has started the notification
            for t in task{
                let alert: UIAlertController = UIAlertController(title: "Alert", message: "Task is starting: \(t.taskTitle)", preferredStyle: .alert)
                let dismissAction = UIAlertAction(title: "Dismiss", style: .default, handler: nil)
                alert.addAction(dismissAction)
                
                // Update the badge for tasks.
                if let tbc: UITabBarController = self.window?.rootViewController as? UITabBarController{
                    tbc.tabBar.items?[2].badgeValue = "1"
                }
            }
            }
        }
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
        defaults.removeObject(forKey: loginKey)
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        defaults.removeObject(forKey: loginKey)
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        NotificationCenter.default.post(name: Notification.Name(rawValue: "AppointmentListShouldRefresh"), object: self)
        NotificationCenter.default.post(name: Notification.Name(rawValue: "TaskListShouldRefresh"), object:self)
        
        // Initially get the appointments, tasks and journals from the database and put them
        // Into globally accessible dictionaries
        Appointments().setUpAppointmentDictionary()
        GlobalTasks().setUpTaskDictionary()
        GlobalJournals().setUpJournalDictionary()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        
        // Sign the user out
        if let auth = FIRAuth.auth(){
            try! auth.signOut()
        }
    }
}

