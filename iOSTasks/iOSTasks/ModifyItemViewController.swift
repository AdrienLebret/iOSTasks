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

class ModifyItemViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    public var reminderUUID:String = "" // reminder's ID
    
    var titleReminderSelected:String = ""
    var commentReminderSelected:String = ""
    var uuidReminderSelected:String = ""
    
    @IBOutlet weak var labelTest: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        // date picker initialization
        
        datePicker = UIDatePicker()
        datePicker?.datePickerMode = .date
        datePicker?.addTarget(self, action: #selector(AddItemViewController.dateChanged(datePicker:)), for: .valueChanged)
        
        deadlineInputTF.inputView = datePicker
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(AddItemViewController.viewTapped(gesture:)))
        
        view.addGestureRecognizer(tapGesture)
        // Context initialization
        
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
                    
                    // initialize type picker view
                    titleR.text = titleReminderSelected
                    
                    // initialize title tect field
                    switch reminderSelected.category! {
                    case "Project":
                        typerPicker.selectRow(0, inComponent: 0, animated: true)
                        typeChoosen = "Project"
                    case "Personal":
                        typerPicker.selectRow(1, inComponent: 0, animated: true)
                        typeChoosen = "Personal"
                    case "Other":
                        typerPicker.selectRow(2, inComponent: 0, animated: true)
                        typeChoosen = "Other"
                    default:
                        typerPicker.selectRow(0, inComponent: 0, animated: true)
                    }
                    
                    // initialize priority picker view
                    switch reminderSelected.rating! {
                    case "High":
                        priorityPicker.selectRow(0, inComponent: 0, animated: true)
                        priorityChoosen = "High"
                    case "Normal":
                        priorityPicker.selectRow(1, inComponent: 0, animated: true)
                        priorityChoosen = "Normal"
                    case "Low":
                        priorityPicker.selectRow(2, inComponent: 0, animated: true)
                        priorityChoosen = "Low"
                    default:
                        priorityPicker.selectRow(0, inComponent: 0, animated: true)
                        priorityChoosen = "High"
                    }
                    
                    //initialize date picker
                    datePicker?.date = reminderSelected.deadline!
                    
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "dd/MM/yyyy"
                    deadlineInputTF.text = dateFormatter.string(from: datePicker!.date)
                    
                }
            }
           }
        } catch  {
           
        }

        
        
    }
    
    //=================
    // MODIFY REMINDER
    //=================
    
    
    // initialize the data in accordance with the reminder that the user wishes to modify
    @IBOutlet weak var titleR: UITextField!
    
    // PICKER VIEWS
    
    @IBOutlet weak var typerPicker: UIPickerView!
    @IBOutlet weak var priorityPicker: UIPickerView!
    
    
    let typeCategory = ["Project", "Personal", "Other"]
    var typeChoosen: String = "Project" // initial value
    
    let priorityCategory = ["High", "Normal", "Low"]
    var priorityChoosen: String = "High" // initial value
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
         return 1
     }
     
     func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
         if pickerView.tag == 1 {
             return typeCategory.count
         } else{
             return priorityCategory.count
         }
     }
     
     func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
         if pickerView.tag == 1 {
             return "\(typeCategory[row])"
         } else{
             return "\(priorityCategory[row])"
         }
     }
     
     func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
         if pickerView.tag == 1 {
             typeChoosen = typeCategory[row]
         } else{
             priorityChoosen = priorityCategory[row]
         }
     }
    

    // DATE PICKER
    
    @IBOutlet weak var deadlineInputTF: UITextField!
    private var datePicker: UIDatePicker?
    
    @objc func viewTapped(gesture: UITapGestureRecognizer){
        view.endEditing(true)
    }
    
    @objc func dateChanged(datePicker: UIDatePicker){
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        deadlineInputTF.text = dateFormatter.string(from: datePicker.date)
        //view.endEditing(true)
    }
    
    // ERROR MESSAGES
    
    @IBOutlet weak var modifyButtonR: UIButton!
    @IBOutlet weak var errorTitleLabelR: UILabel!
    @IBOutlet weak var errorDateLabelR: UILabel!
    
    
    
    
    // SAVE THE MODIFICATION OF THE USER
    @IBAction func saveButton(_ sender: UIButton) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext

        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "ReminderEntity")

        request.returnsObjectsAsFaults = false
        
        //var reminderSelected:ReminderEntity
        
        do {
           let results = try context.fetch(request)
           
           if results.count > 0 {
            
            //var reminderTab = results as! [ReminderEntity]
            
            for tempReminder in results as! [ReminderEntity]  {
                if tempReminder.uuid == reminderUUID{
                    tempReminder.setValue(titleR.text!, forKey: "title")
                    tempReminder.setValue(typeChoosen, forKey: "category")
                    tempReminder.setValue(priorityChoosen, forKey: "rating")
                    tempReminder.setValue(datePicker!.date, forKey: "deadline")
                    do {
                        try context.save()
                        print("Context MODIFIED")
                        print(tempReminder)
                    } catch {
                        print("Context NOT SAVED")
                    }
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
    /*
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
    */
    
    
    
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
                    do {
                        try context.save()
                    } catch {
                        print("Context NOT SAVED")
                    }
                }
            }
           }
        } catch  {
           
        }
        
    }
    
    

}
