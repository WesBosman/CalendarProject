//
//  RemoteConfigValues.swift
//  CreativeCalendar
//
//  Created by Wes Bosman on 5/18/17.
//  Copyright © 2017 Wes Bosman. All rights reserved.
//

import Foundation
import Firebase

// Use this class to be able to change the default starting calendar date

class RemoteConfigValues{
    
    enum startDateValueKey: String{
        case calendarStartDate
    }
    
    static let sharedInstance = RemoteConfigValues()
    let startDateKey     = "calendarStartDate"
    let defaultStartDate = "5/01/2017"
    
    init(){
        loadDefaultValues()
        fetchCloudValues()
    }
    
    func loadDefaultValues(){
        let startDateDefault: [String: NSObject] = [
            startDateValueKey.calendarStartDate.rawValue : defaultStartDate as NSObject
        ]
        
        FIRRemoteConfig.remoteConfig().setDefaults(startDateDefault)
    }
    
    func fetchCloudValues(){
        // Set this to 43200 which is 12 hours for production
        // Fetch duration is the amount of time the values remain cached
        let fetchInterval: TimeInterval = 0
        activateDeveloperMode()
        
        FIRRemoteConfig.remoteConfig().fetch(withExpirationDuration: fetchInterval, completionHandler: {
            [weak self] (status, error) in
            if let err = error as? FIRRemoteConfigError{
                print("Error Loading Remote Config Values: \(err)")
                return
            }
            
//            if let stat = status as? FIRRemoteConfigFetchStatus{
//                print("Status Loading Remote Config Values: \(stat)")
//            }
            
            FIRRemoteConfig.remoteConfig().activateFetched()
            print("Retrieved remote config values from cloud")
            
            let fetchedStart = FIRRemoteConfig
                                .remoteConfig()
                                .configValue(forKey: self?.startDateKey)
                                .stringValue!
            print("Fetched Start Date: \(fetchedStart)")
        })
        
    }
    
    func activateDeveloperMode(){
        let debugSettings = FIRRemoteConfigSettings(developerModeEnabled: true)!
        FIRRemoteConfig.remoteConfig().configSettings = debugSettings
        print("Activated Developer Mode")
    }
    
    // Firebase encodes the string values with quotations as "5/01/2017"
    // This means we have to delete the quotation characters
    // Otherwise the date formatter would produce a nil and crash the app
    func getCalendarStartDate(forKey key: String) -> Date{
        if let startDateString = FIRRemoteConfig
                                    .remoteConfig()
                                    .configValue(forKey: key)
                                    .stringValue{
            
            // Remove Quotations from start date string
            let new = startDateString.replacingOccurrences(of: "\"", with: "")
            print("Start Date String -> \(startDateString)")
            print("New Start String -> \(new)")
            
            let startDate = DateFormatter().calendarFormat.date(from: String(new))!
            print("Start Date -> \(startDate)")
            return startDate
        }
        else{
            print("Default Start Date String -> \(defaultStartDate)")
            let startDate = DateFormatter().calendarFormat.date(from: defaultStartDate)!
            print("Default Start Date -> \(startDate)")
            return startDate
        }
    }
    
}
