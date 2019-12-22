//
//  AddItemViewController.swift
//  iOSTasks
//
//  Created by Adrien Lebret on 12/12/2019.
//  Copyright © 2019 if26. All rights reserved.
//

import UIKit
import CoreData


class AddItemViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
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
    
    
    // Deadline
    
    @IBOutlet weak var deadlineInputTF: UITextField!
    
    private var datePicker: UIDatePicker?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addGradientToView(view: self.view)
        
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
    
    @IBOutlet weak var titleR: UITextField!
    
    // Save button
    
    @IBAction func saveButton(_ sender: UIButton) {
        let reminder:ReminderEntityClass = ReminderEntityClass(cat: typeChoosen, com: "", dea: datePicker!.date, rat: priorityChoosen, tit: titleR.text!)
        
        createData(reminderEntity: reminder)
        
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
    
    // OTHER : the gradient background
    
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
