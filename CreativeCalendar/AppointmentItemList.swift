//
//  AppointmentItemList.swift
//  CreativeCalendar
//
//  Created by Wes on 4/29/16.
//  Copyright (c) 2016 Wes Bosman. All rights reserved.
//  Also from a tutorial. By Jason Newell
//  This is supposed to make a singleton class so that this list doesn't get made more than once.

import UIKit
class AppointmentItemList{
    private let ITEMS_KEY = "appointmentItems"
    
    class var sharedInstance : AppointmentItemList{
        struct Static{
            static let instance: AppointmentItemList = AppointmentItemList()
        }
    return Static.instance
    }
    
    // Create a notification that will show up on the home screen.
    func addItem(item: AppointmentItem) { // persist a representation of this todo item in NSUserDefaults
        var todoDictionary = NSUserDefaults.standardUserDefaults().dictionaryForKey(ITEMS_KEY) ?? Dictionary() // if todoItems hasn't been set in user defaults, initialize todoDictionary to an empty dictionary using nil-coalescing operator (??)
        
        todoDictionary[item.UUID] = ["deadline": item.deadline, "title": item.title, "UUID": item.UUID] // store NSData representation of todo item in dictionary with UUID as key
        NSUserDefaults.standardUserDefaults().setObject(todoDictionary, forKey: ITEMS_KEY) // save/overwrite todo item list
        
        // create a corresponding local notification
        var notification = UILocalNotification()
        notification.alertBody = "Appointment \"\(item.title)\" Is Overdue" // text that will be displayed in the notification
        notification.alertAction = "open" // text that is displayed after "slide to..." on the lock screen - defaults to "slide to view"
        notification.fireDate = item.deadline // todo item due date (when notification will be fired)
        notification.soundName = UILocalNotificationDefaultSoundName // play default sound
        notification.userInfo = ["UUID": item.UUID, ] // assign a unique identifier to the notification so that we can retrieve it later
        notification.category = "APPOINTMENT_CATEGORY"
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
    }
    
    func removeItem(item: AppointmentItem){
        // Loop through the notifications
        for notification in UIApplication.sharedApplication().scheduledLocalNotifications as! [UILocalNotification]{
            if notification.userInfo!["UUID"] as! String == item.UUID{
                UIApplication.sharedApplication().cancelLocalNotification(notification)
                break
            }
        }
        
        if var appointmentItems = NSUserDefaults.standardUserDefaults().dictionaryForKey(ITEMS_KEY){
            appointmentItems.removeValueForKey(item.UUID)
            // Save item
            NSUserDefaults.standardUserDefaults().setObject(appointmentItems, forKey: ITEMS_KEY)
        }
        
    }
    
    // Return an array of appointment items for the user to see.
    func allItems() -> [AppointmentItem] {
        var appointmentDictionary = NSUserDefaults.standardUserDefaults().dictionaryForKey(ITEMS_KEY) ?? [:]
        let items = Array(appointmentDictionary.values)
        return items.map( {AppointmentItem(deadline: $0["deadline"] as! NSDate, title: $0["title"] as! String, UUID: $0["UUID"] as! String!)} )
            .sorted({ (left: AppointmentItem, right:AppointmentItem) -> Bool in (left.deadline.compare(right.deadline) == .OrderedAscending)} )
    }
        
}