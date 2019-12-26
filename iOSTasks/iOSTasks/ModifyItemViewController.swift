//
//  ModifyItemViewController.swift
//  iOSTasks
//
//  Created by Adrien Lebret on 17/12/2019.
//  Copyright © 2019 if26. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications

class ModifyItemViewController: UIViewController {

    public var reminderUUID:String = "" // reminder's ID
    
    var titleReminderSelected:String = ""
    var commentReminderSelected:String = ""
    var uuidReminderSelected:String = ""
    
    @IBOutlet weak var labelTest: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext

        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "ReminderEntity")

        request.returnsObjectsAsFaults = false
        
        var reminderSelected:ReminderEntity
        
        do {
           let results = try context.fetch(request)
           
           if results.count > 0 {
            var reminderTab = results as! [ReminderEntity]
            
            for tempReminder in reminderTab  {
                if tempReminder.uuid == reminderUUID{
                    reminderSelected = tempReminder
                    titleReminderSelected = reminderSelected.title!
                    commentReminderSelected = reminderSelected.comment!
                    uuidReminderSelected = reminderSelected.uuid!
                    print("Reminder Selected : #\(reminderSelected.title)")
                }
            }
           }
        } catch  {
           
        }
        
    }
    

    
    
    
    
    //=============
    // NOTFICATION
    //=============
    
//     A LIRE : https://www.raywenderlich.com/8164-push-notifications-tutorial-getting-started
    
    // user allowed to do some notification
    
    @IBAction func saveNotificationButton(_ sender: UIButton) {
        
        let center = UNUserNotificationCenter.current()
        var this = self
        center.getNotificationSettings{ settings in
            guard settings.authorizationStatus == .authorized else {return}
            
            if settings.alertSetting == .enabled {
                // schedule
                
                // title notif
                let content = UNMutableNotificationContent()
                content.title = this.titleReminderSelected
                content.body = this.commentReminderSelected
                
                // date notif
                var dateComponents = DateComponents()
                dateComponents.calendar = Calendar.current
                
                dateComponents.weekday = 3
                dateComponents.hour = 10
                dateComponents.minute = 47
            
                print("Date")
                print(Date())
                
                
                print("Calendar")
                print(Calendar.current)
                
                print("DateComponent")
                print(dateComponents)
                
                // request
                let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
                
                let request = UNNotificationRequest(identifier: this.uuidReminderSelected, content: content, trigger: trigger)
                
                // notif
                
                center.add(request){ (error) in
                    if error != nil {
                        print("Error Notification")
                    }
                }
                
                // update ReminderEntity trigger date time
                
                // TO DO
                
            } else {
                // insert "message d'erreur"
                print("You didn't allow....")
            }
            
        }
    }
    
    
    
    
    //=================
    // DELETE REMINDER
    //=================
    
    @IBAction func deleteReminderButton(_ sender: UIButton) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext

        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "ReminderEntity")

        request.returnsObjectsAsFaults = false
        
        var reminderSelected:ReminderEntity
        
        do {
           let results = try context.fetch(request)
           
           if results.count > 0 {
            var reminderTab = results as! [ReminderEntity]
            
            for tempReminder in reminderTab  {
                if tempReminder.uuid == reminderUUID{
                    reminderSelected = tempReminder
                    
                    context.delete(reminderSelected)
                    print("Reminder Deleted : #\(reminderSelected.title)")
                    
                }
            }
           }
        } catch  {
           
        }
        
    }
    
    

}
