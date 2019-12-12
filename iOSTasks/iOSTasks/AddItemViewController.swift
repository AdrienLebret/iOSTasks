//
//  AddItemViewController.swift
//  iOSTasks
//
//  Created by Adrien Lebret on 12/12/2019.
//  Copyright © 2019 if26. All rights reserved.
//

import UIKit

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
    
    
    

}
