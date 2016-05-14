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
        var todoDictionary = NSUserDefaults.standardUserDefaults().dictionaryForKey(ITEMS_KEY) ?? Dictionary()
        // if todoItems hasn't been set in user defaults, initialize todoDictionary to an empty dictionary using nil-coalescing operator (??)
        
        todoDictionary[item.UUID] = ["start": item.startingTime,
                                    "ending": item.endingTime,
                                    "title": item.title,
                                    "location": item.appLocation,
                                    "additional": item.additionalInfo ,
                                    "UUID": item.UUID] // store NSData representation of todo item in dictionary with UUID as key
        NSUserDefaults.standardUserDefaults().setObject(todoDictionary, forKey: ITEMS_KEY) // save/overwrite todo item list
        
        // create a corresponding local notification
        var notification = UILocalNotification()
        notification.alertBody = "Appointment \"\(item.title)\" Has Started" // text that will be displayed in the notification
        notification.alertAction = "open" // text that is displayed after "slide to..." on the lock screen - defaults to "slide to view"
        notification.fireDate = item.startingTime // todo item due date (when notification will be fired)
        notification.soundName = UILocalNotificationDefaultSoundName // play default sound
        notification.userInfo = ["UUID": item.UUID, ] // assign a unique identifier to the notification so that we can retrieve it later
        notification.category = "APPOINTMENT_CATEGORY"
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
    }
    
    func removeItem(item: AppointmentItem){
        // Loop through the notifications
        for notification in UIApplication.sharedApplication().scheduledLocalNotifications as! [UILocalNotification]{
            // Retrieve the notification based on the unique identifier
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
        print(items)
        return items.map( {AppointmentItem(startTime: $0["start"] as! NSDate,
                                        endTime: $0["ending"] as! NSDate,
                                        title: $0["title"] as! String,
                                        location: $0["location"] as! String,
                                        additional: $0["additional"] as! String,
                                        UUID: $0["UUID"] as! String!)} )
            
            .sorted({ (left: AppointmentItem, right:AppointmentItem) -> Bool in (left.startingTime.compare(right.startingTime) == .OrderedAscending)} )
    }
        
}