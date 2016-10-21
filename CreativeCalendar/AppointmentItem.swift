//
//  AppointmentItem.swift
//  CreativeCalendar
//
//  Created by Wes on 4/29/16.
//  Copyright (c) 2016 Wes Bosman. All rights reserved.

// Global Appointments structure for holding appointment dictionary, appointments and their dates
struct GlobalAppointments{
    static var appointmentDictionary: Dictionary<String, [AppointmentItem]> = [:]
    static var appointmentItems: [AppointmentItem] = []
    static var appointmentSections: [String] = []
}

class Appointments{
    private var db = DatabaseFunctions.sharedInstance
    private let formatter = NSDateFormatter().dateWithoutTime
    
    // Set up the global dictionary based on what is in the database
    func setUpAppointmentDictionary(){
        GlobalAppointments.appointmentItems = db.getAllAppointments()
        
        // Sort appointments based on starting time
        GlobalAppointments.appointmentItems = GlobalAppointments.appointmentItems.sort({$0.startingTime.compare($1.startingTime) == NSComparisonResult.OrderedAscending })
        
        for appointment in GlobalAppointments.appointmentItems{
            let appointmentDate = formatter.stringFromDate(appointment.startingTime)
            
            // If appointment sections does not contain the appointment date add it
            if(!GlobalAppointments.appointmentSections.contains(appointmentDate)){
                GlobalAppointments.appointmentSections.append(appointmentDate)
            }
        }
        
        for section in GlobalAppointments.appointmentSections{
            // Get appointments based on their date
            GlobalAppointments.appointmentItems = db.getAppointmentByDate(section, formatter: formatter)
            
            // Set up the global appointments dictionary
            GlobalAppointments.appointmentDictionary.updateValue(GlobalAppointments.appointmentItems, forKey: section)
        }
    }
    
    // Add Appointment Item to the dictionary
    func addAppointmentToDictionary(appointment: AppointmentItem){
        print("Adding Appointment Item to the dictionary: \(appointment)");
        let appointmentDate = formatter.stringFromDate(appointment.startingTime)
        
        // If the date is not already a key in the dictionary
        if(GlobalAppointments.appointmentDictionary[appointmentDate] == nil){
            var newAppointmentArray: [AppointmentItem] = []
            newAppointmentArray.append(appointment)
            print("Did not find key already in dictionary \(appointmentDate)")
            GlobalAppointments.appointmentDictionary[appointmentDate] = newAppointmentArray
            print("Global Appointment Dictionary for key: \(appointmentDate) value: \(GlobalAppointments.appointmentDictionary[appointmentDate])")
        }
        else{
            print("Did find key already in dictionary \(appointmentDate)")
            var newAppointmentArray = GlobalAppointments.appointmentDictionary[appointmentDate]
            newAppointmentArray?.append(appointment)
            GlobalAppointments.appointmentDictionary[appointmentDate] = newAppointmentArray
        }
        
    }
    
    // Delete item from the dictionary
    func removeAppointmentFromDictionary(appointment: AppointmentItem){
        print("Removing Appointment Item from dictionary: \(appointment)")
        
    }
}

struct AppointmentItem {
    var title: String
    var startingTime: NSDate
    var endingTime: NSDate
    var appLocation: String
    var additionalInfo: String
    var type: String
    var repeating: String
    var alert: String
    var completed: Bool
    var canceled: Bool
    var deleted: Bool
    var dateCompleted: String?
    var canceledReason: String?
    var deletedReason: String?
    var UUID: String
    
    init(type:String, startTime: NSDate, endTime: NSDate, title: String, location: String, additional: String, repeatTime: String, alertTime: String, isComplete: Bool, isCanceled: Bool, isDeleted:Bool,dateFinished:String?, cancelReason: String?, deleteReason:String?, UUID: String) {
        self.title = title
        self.type = type
        self.startingTime = startTime
        self.endingTime = endTime
        self.appLocation = location
        self.additionalInfo = additional
        self.repeating = repeatTime
        self.alert = alertTime
        self.completed = isComplete
        self.canceled = isCanceled
        self.deleted = isDeleted
        self.dateCompleted = dateFinished
        self.canceledReason = cancelReason
        self.deletedReason = deleteReason
        self.UUID = UUID
    }
    
    // Is the starting time earlier than the current date
    var isOverdue: Bool {
        return (NSDate().compare(self.startingTime) == NSComparisonResult.OrderedDescending)
    }
}
