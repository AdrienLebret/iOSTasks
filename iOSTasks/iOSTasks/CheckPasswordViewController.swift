//
//  CheckPasswordViewController.swift
//  iOSTasks
//
//  Created by Adrien Lebret on 07/01/2020.
//  Copyright © 2020 if26. All rights reserved.
//

import Foundation
import Security
import UIKit
import CryptoKit

class CheckPasswordViewController: UIViewController {
    
    @IBOutlet weak var passwordEditTF: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        let defaults = UserDefaults.standard
        
        var created = defaults.bool(forKey: "PasswordCreated")
        print("Default machin :")
        print(created)
        
        passwordEditTF.isSecureTextEntry = true
        
        if created {
            // Password Not Created
            print("HELLO")
            //performSegue(withIdentifier: "showCreatedPassword", sender: self)
            
        }
        
    }

    @IBAction func checkTest(_ sender: UIButton) {
        
        let query: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                    kSecAttrAccount as String: "password",
                                    kSecMatchLimit as String: kSecMatchLimitOne,
                                    kSecReturnData as String: kCFBooleanTrue]
        
        var retrivedData: AnyObject? = nil
        
        let _ = SecItemCopyMatching(query as CFDictionary, &retrivedData)
        
        guard let data = retrivedData as? Data else {print("ERROR BITCH");return}
        
        var pw = String(data: data, encoding: String.Encoding.utf8)
        
        print(pw)
        
        let salt = Array("adrienlebretjulesgobinif26".utf8)
        let password = passwordEditTF.text!
        let key = "\(password).\(salt)"
        let digestData = Data(key.utf8)
        let digest = SHA256.hash(data: digestData)
        
//        print(digest.description)
        var valueData = digest.description.dropFirst(15) // "SHA256 digest: " + hashage of password
        print(valueData)
        print(String(valueData) == pw)
        
        if String(valueData) == pw {
//           connection
            
            performSegue(withIdentifier: "connection", sender: nil)
        }
        
    }
    

}