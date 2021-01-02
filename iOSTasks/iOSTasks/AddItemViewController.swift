//
//  AddItemViewController.swift
//  iOSTasks
//
//  Created by Adrien Lebret on 12/12/2019.
//  Copyright © 2019 if26. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications

class AddItemViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    //=============
    // PICKER VIEW
    //=============
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 1 {
            return typeCategory.count
        } else {
            return priorityCategory.count
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 1 {
            return "\(typeCategory[row])"
        } else {
            return "\(priorityCategory[row])"
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if pickerView.tag == 1 {
            typeChoosen = typeCategory[row]
        } else {
            priorityChoosen = priorityCategory[row]
        }
        
    }
    
    let typeCategory = ["Project", "Personal", "Other"]
    var typeChoosen: String = "Project" // initial value
    
    @IBOutlet weak var typePicker: UIPickerView!
    
    let priorityCategory = ["High", "Normal", "Low"]
    var priorityChoosen: String = "High" // initial value
    
    @IBOutlet weak var priorityPicker: UIPickerView!
    
    
    //==========
    // Deadline
    //==========
    
    @IBOutlet weak var deadlineInputTF: UITextField!
    
    private var datePicker: UIDatePicker?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addGradientToView(view: self.view)
        
        datePicker = UIDatePicker()
        datePicker?.datePickerMode = .date
        datePicker?.addTarget(self, action: #selector(AddItemViewController.dateChanged(datePicker:)), for: .valueChanged)
        
        deadlineInputTF.inputView = datePicker
        
        //initialize date picker
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        deadlineInputTF.text = dateFormatter.string(from: datePicker!.date)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(AddItemViewController.viewTapped(gesture:)))
        
        view.addGestureRecognizer(tapGesture)
        
        // test validate save button
        
        addButtonR.isEnabled = false
        
        datePicker?.addTarget(self, action: #selector(setDisableButton), for: .valueChanged)
        
        titleR?.addTarget(self, action: #selector(setDisableButton), for: .editingChanged)
    }
    
    
    
    
    @objc func viewTapped(gesture: UITapGestureRecognizer){
        view.endEditing(true)
    }
    
    @objc func dateChanged(datePicker: UIDatePicker){
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        deadlineInputTF.text = dateFormatter.string(from: datePicker.date)
        //view.endEditing(true)
    }
    
    @IBOutlet weak var titleR: UITextField!
    //@IBOutlet weak var commentR: UITextField!
    @IBOutlet weak var commentR2: UITextField!
    @IBOutlet weak var errorTitleLabelR: UILabel!
    @IBOutlet weak var errorDateLabelR: UILabel!
    @IBOutlet weak var addButtonR: UIButton!
    
    
    
    //===============================
    // SAVE BUTTON + CREATE REMINDER
    //===============================
    
    @IBAction func saveButton(_ sender: UIButton) {

        // validate the user's data
        
        if validateData()!{
            
            // Normally it's valid when the user press the button

            
            let reminder:ReminderEntityClass = ReminderEntityClass(cat: typeChoosen, com: commentR2.text!, dea: datePicker!.date, rat: priorityChoosen, tit: titleR.text!)
            
            createData(reminderEntity: reminder)
            createNotification(reminderEntity: reminder)
            
            //createValidateAlert(title: "New task added", message: titleR!.text!)
//            saveDone
            //self.performSegue(withIdentifier: "save", sender: self)
        }
        
    }
    
    @objc func setDisableButton(){
        if validateData()!{
            addButtonR.isEnabled = true
        } else {
            addButtonR.isEnabled = false
        }
    }

    func validateData()->Bool?{
        var calendar = Calendar.current
        calendar.timeZone = NSTimeZone.local
        // Get today's beginning & end
        let dateFrom = calendar.startOfDay(for: Date()) // eg. 2016-10-10 00:00:00
        
        //print(dateFrom) // C'est la date de la veille qui est affichée à 23h00 
        
        if ((titleR.text == "Task's name" || titleR.text!.count == 0) && datePicker!.date < dateFrom){ // everything is false
            errorTitleLabelR.text = "Enter a task's name"
            errorDateLabelR.text = "Enter today's date or a future date"
            return false
        } else if (titleR.text == "Task's name" || titleR.text!.count == 0){ // date is good but title is false
            errorTitleLabelR.text = "Enter a task's name"
            errorDateLabelR.text = ""
            return false
        } else if ((titleR.text != "Task's name" && titleR.text!.count > 0) && datePicker!.date >= dateFrom){ // everything is good
            errorTitleLabelR.text = ""
            errorDateLabelR.text = ""
            return true
        } else { // everything is false - title is good but date is false
            errorTitleLabelR.text = ""
            errorDateLabelR.text = "Enter today's date or a future date"
            return false
        }
    }
    
    func createValidateAlert(title:String, message:String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
            //self.navigationController?.pushViewController(self, animated: true)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func createData(reminderEntity:ReminderEntityClass){

        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let reminder = NSEntityDescription.insertNewObject(forEntityName: "ReminderEntity", into: context)
        
        reminder.setValue(reminderEntity.title, forKey: "title")
        reminder.setValue(reminderEntity.category, forKey: "category")
        reminder.setValue(reminderEntity.comment, forKey: "comment")
        reminder.setValue(reminderEntity.completed, forKey: "completed")
        reminder.setValue(reminderEntity.deadline, forKey: "deadline")
        reminder.setValue(reminderEntity.rating, forKey: "rating")
        reminder.setValue(reminderEntity.triggerDateTime, forKey: "triggerDateTime")
        reminder.setValue(reminderEntity.uuid, forKey: "uuid")
        
        do {
            try context.save()
            print("Context SAVED")
            print(reminder)
        } catch {
            print("Context NOT SAVED")
        }
    }
    
    //=============
    // NOTFICATION
    //=============
    
    func createNotification(reminderEntity:ReminderEntityClass) {
        let center = UNUserNotificationCenter.current()
        var this = self
        center.getNotificationSettings{ settings in
            guard settings.authorizationStatus == .authorized else {return}
            
            if settings.alertSetting == .enabled {
                // schedule
                
                // title notif
                let content = UNMutableNotificationContent()
                content.title = reminderEntity.title
                content.body = reminderEntity.comment
                
                // date notif
                /*var dateComponents = DateComponents()
                dateComponents.calendar = Calendar.current
                
                dateComponents.weekday = 3
                dateComponents.hour = 10
                dateComponents.minute = 47*/
                               
                // Take the deadline
                let date = reminderEntity.deadline
                
                //print("Deadline :")
                //print(date)
            
                // Create calendar object
                var calendar = Calendar.current

                // Get components using current Local & Timezone ***
                print(calendar.dateComponents([.year, .month, .day, .hour, .minute], from: date))

                // *** define calendar components to use as well Timezone to UTC ***
                calendar.timeZone = TimeZone(identifier: "UTC")!
                
                
                var components = calendar.dateComponents([.year, .month, .day], from: date)
                components.hour = 9
                components.minute = 0
                print("The notification will take place  : \(components)")
                
                // request
                let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
                
                print("Notification created")
                
                let request = UNNotificationRequest(identifier: reminderEntity.uuid, content: content, trigger: trigger)
                
                // notif
                
                center.add(request){ (error) in
                    if error != nil {
                        print("Error Notification")
                    }
                }

            } else {
                // insert "message d'erreur"
                print("You didn't allow....")
            }
            
        }
    }
    
    
    // test debug
    /*@IBAction func cancel(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "ReminderEntity")
        
        request.returnsObjectsAsFaults = false
        
        do {
            let results = try context.fetch(request)
            
            if results.count > 0 {
                print(results)
            }
        } catch  {
            
        }
    }*/
    
    //=================================
    // OTHER : the gradient background
    //=================================
    
    func addGradientToView(view: UIView)
    {
            //gradient layer
            let gradientLayer = CAGradientLayer()
        
            //let colorOne = UIColor(red:0.00, green:0.00, blue:0.40, alpha:1.0)
            
            //define colors
            gradientLayer.colors = [UIColor.cyan.cgColor, UIColor.blue.cgColor]
            
            //define locations of colors as NSNumbers in range from 0.0 to 1.0
            //if locations not provided the colors will spread evenly
            gradientLayer.locations = [0.0, 0.6, 0.8]
            
            //define frame
            gradientLayer.frame = view.bounds
            
            //insert the gradient layer to the view layer
            view.layer.insertSublayer(gradientLayer, at: 0)
    }
}
