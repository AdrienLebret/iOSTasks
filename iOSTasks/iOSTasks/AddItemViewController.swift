//
//  AddItemViewController.swift
//  iOSTasks
//
//  Created by Adrien Lebret on 12/12/2019.
//  Copyright © 2019 if26. All rights reserved.
//

import UIKit
import CoreData


class AddItemViewController: UIViewController, UIPickerViewDataSource,

    // Picker View Type
    // à dupliquer pour la priorité
    
    
    UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return typeCategory.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return typeCategory[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        typeChoosen = typeCategory[row]
    }
    
    let typeCategory = ["Project", "Personal", "Other"]
    var typeChoosen: String = ""
    
    @IBOutlet weak var typePicker: UIPickerView!
    
    
    
    // Deadline
    
    @IBOutlet weak var deadlineInputTF: UITextField!
    
    private var datePicker: UIDatePicker?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        datePicker = UIDatePicker()
        datePicker?.datePickerMode = .date
        datePicker?.addTarget(self, action: #selector(AddItemViewController.dateChanged(datePicker:)), for: .valueChanged)
        
        deadlineInputTF.inputView = datePicker
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(AddItemViewController.viewTapped(gesture:)))
        
        view.addGestureRecognizer(tapGesture)

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
    
    
    // Save button
    
    @IBAction func saveButton(_ sender: UIButton) {
        let reminder:ReminderEntityClass = ReminderEntityClass(cat: "categ", com: "", dea: Date(), rat: "rating", tit: "michel")
        
        createData(reminderEntity: reminder)
        
    }
    
    func createData(reminderEntity:ReminderEntityClass){
        guard let appDeleguate = UIApplication.shared.delegate as? AppDelegate else {return}
        
        let managedContext = appDeleguate.persistentContainer.viewContext
        
        let reminderE = NSEntityDescription.entity(forEntityName: "ReminderEntity", in: managedContext)
        
        let reminder = NSManagedObject(entity: reminderE!, insertInto: managedContext)
        reminder.setValue(reminderEntity.title, forKey: "title")
        reminder.setValue(reminderEntity.category, forKey: "category")
        reminder.setValue(reminderEntity.comment, forKey: "comment")
        reminder.setValue(reminderEntity.completed, forKey: "completed")
        reminder.setValue(reminderEntity.deadline, forKey: "deadline")
        reminder.setValue(reminderEntity.rating, forKey: "rating")
        reminder.setValue(reminderEntity.triggerDateTime, forKey: "triggerDateTime")
        reminder.setValue(reminderEntity.uuid, forKey: "uuid")
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Error Save")
        }
    }
    

}
