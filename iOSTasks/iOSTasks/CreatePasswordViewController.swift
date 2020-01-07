//
//  CreatePasswordViewController.swift
//  iOSTasks
//
//  Created by Adrien Lebret on 07/01/2020.
//  Copyright © 2020 if26. All rights reserved.
//
import Foundation
import Security
import UIKit
import CryptoKit

class CreatePasswordViewController: UIViewController {

    
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var errorLabel2: UILabel!
    @IBOutlet weak var passwordOneTF: UITextField!
    @IBOutlet weak var passwordTwoTF: UITextField!
    
    @IBOutlet weak var createButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createButton.isEnabled = false
        
        passwordOneTF.isSecureTextEntry = true
        passwordTwoTF.isSecureTextEntry = true
        
        passwordTwoTF?.addTarget(self, action: #selector(setDisableButton), for: .editingChanged)
        passwordOneTF?.addTarget(self, action: #selector(validatePassword), for: .editingChanged)
    }
    
    
    @objc func setDisableButton(){
        if validateData()!{
            createButton.isEnabled = true
        } else {
            createButton.isEnabled = false
        }
    }
    
    func validateData()->Bool?{
        
        // ATTENTION, checked qu'ils sont bien diff de VIDE
        
        if passwordTwoTF.text! == passwordOneTF.text! {
            errorLabel.text = ""
            return true
        } else {
            errorLabel.text = "Repeat the previous password"
            return false
        }
        
    }
    
    @objc func validatePassword(){
        if (passwordOneTF.text!.count >= 8 && passwordOneTF.text!.count != 0){
            errorLabel2.text = ""
        } else {
            createButton.isEnabled = false
            errorLabel2.text = "Enter a password with at least 8 characters"
        }
    }
    
    
    @IBAction func createPW(_ sender: UIButton) {
        
        // delete actual password
        
        let queryDelete:[String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                   kSecAttrAccount as String: "password"]
        let statusDelete = SecItemDelete(queryDelete as CFDictionary)
        
        guard statusDelete == errSecSuccess ||  statusDelete == errSecItemNotFound else { return print ("delete error")}
        
        // create password
        
        let defaults = UserDefaults.standard
        defaults.set(true, forKey: "PasswordCreated")
        
        let salt = Array("adrienlebretjulesgobinif26".utf8)
        let password = passwordOneTF.text!
        let key = "\(password).\(salt)"
        let data = Data(key.utf8)
        let digest = SHA256.hash(data: data)
        
//        print(digest.description)
        var valueData = digest.description.dropFirst(15) // "SHA256 digest: " + hashage of password
//        print(valueData)
        
        let query: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                    kSecAttrAccount as String: "password",
                                    kSecValueData as String: String(valueData).data(using: String.Encoding.utf8)]
//        String: String(valueData).data(using: String.Encoding.utf8)
        let status = SecItemAdd(query as CFDictionary, nil)
        
        guard status == errSecSuccess else { return print ("save error")}

    }
    
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
