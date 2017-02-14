//
//  AppointmentItem.swift
//  CreativeCalendar
//
//  Created by Wes on 4/29/16.
//  Copyright (c) 2016 Wes Bosman. All rights reserved.


// Global Appointments structure for holding appointment dictionary, appointments and their dates
//struct GlobalAppointments{
//    static var appointmentDictionary: Dictionary<String, [AppointmentItem]> = [:]
//    static var appointmentItems: [AppointmentItem] = []
//    static var appointmentSections: [String] = []
//}

class Appointments{
    static var appointmentDictionary: Dictionary<String, [AppointmentItem]> = [:]
    static var appointmentItems: [AppointmentItem] = []
    static var appointmentSections: [String] = []
    fileprivate var db = DatabaseFunctions.sharedInstance
    fileprivate let formatter = DateFormatter().dateWithoutTime
    
    // Set up the global dictionary based on what is in the database
    func setUpAppointmentDictionary(){
        Appointments.appointmentItems = db.getAllAppointments()
        
        // Sort appointments based on starting time
        Appointments.appointmentItems = Appointments.appointmentItems.sorted(by: {$0.startingTime.compare($1.startingTime) == ComparisonResult.orderedAscending })
        
        for appointment in Appointments.appointmentItems{
            let appointmentDate = formatter.string(from: appointment.startingTime)
            
            // If appointment sections does not contain the appointment date add it
            if(!Appointments.appointmentSections.contains(appointmentDate)){
                Appointments.appointmentSections.append(appointmentDate)
            }
        }
        
        // Sort the keys of the section headers as dates
        Appointments.appointmentSections = Appointments.appointmentSections.sorted(by: {
            (left: String, right: String) -> Bool in
            return formatter.date(from: left)?.compare(formatter.date(from: right)!) == ComparisonResult.orderedAscending
        })
        
        for section in Appointments.appointmentSections{
            // Get appointments based on their date
            Appointments.appointmentItems = db.getAppointmentByDate(section, formatter: formatter)
            
            // Set up the global appointments dictionary
            Appointments.appointmentDictionary.updateValue(Appointments.appointmentItems, forKey: section)
        }
    }
    
    // Add Appointment Item to the dictionary
    func addAppointmentToDictionary(_ appointment: AppointmentItem){
        print("Adding Appointment Item to the dictionary: \(appointment)");
        let appointmentDate = formatter.string(from: appointment.startingTime)
        
        // If the date is not already a key in the dictionary
        if(Appointments.appointmentDictionary[appointmentDate] == nil){
            
            var newAppointmentArray: [AppointmentItem] = []
            newAppointmentArray.append(appointment)
            print("Did not find key already in dictionary \(appointmentDate)")
            
            Appointments.appointmentDictionary[appointmentDate] = newAppointmentArray
            
            print("Global Appointment Dictionary for key: \(appointmentDate) value: \(Appointments.appointmentDictionary[appointmentDate])")
        }
        else{
            print("Did find key already in dictionary \(appointmentDate)")
            
            var newAppointmentArray = Appointments.appointmentDictionary[appointmentDate]
            newAppointmentArray?.append(appointment)
            Appointments.appointmentDictionary[appointmentDate] = newAppointmentArray
        }
        
    }
    
    // Should add editing to appointments
    
    // Delete item from the dictionary
    func removeAppointmentFromDictionary(_ appointment: AppointmentItem){
        print("Removing Appointment Item from dictionary: \(appointment)")
        let dictionaryKey = DateFormatter().dateWithoutTime.string(from: appointment.startingTime)
        let appointmentArray = Appointments.appointmentDictionary[dictionaryKey]
        
        if var appointmentArray = appointmentArray{
            if let found = appointmentArray.index(where: {$0.UUID == appointment.UUID}){
                appointmentArray.remove(at: found)
                Appointments.appointmentDictionary.updateValue(appointmentArray, forKey: dictionaryKey)
            }
        }
    }
}

struct AppointmentItem: CustomStringConvertible {
    var title: String
    var startingTime: Date
    var endingTime: Date
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
    
    public var description: String{
        return title
    }
    
    
    init(type:String, startTime: Date, endTime: Date, title: String, location: String, additional: String, repeatTime: String, alertTime: String, isComplete: Bool, isCanceled: Bool, isDeleted:Bool,dateFinished:String?, cancelReason: String?, deleteReason:String?, UUID: String) {
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
        return (Date().compare(self.startingTime) == ComparisonResult.orderedDescending)
    }
}
