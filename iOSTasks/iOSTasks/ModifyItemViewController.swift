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
    
    let center = UNUserNotificationCenter.current()
    
    //center
  
    @IBAction func saveNotificationButton(_ sender: UIButton) {
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
