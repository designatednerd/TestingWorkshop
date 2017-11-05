//
//  RegisterViewController.swift
//  Detour
//
//  Created by Ellen Shapiro on 5/6/17.
//  Copyright © 2017 Designated Nerd Software. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var confirmPasswordTextField: UITextField!
    @IBOutlet var submitButton: UIButton!
    @IBOutlet var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.errorLabel.text = ""
    }
    
    // MARK: - Actions
    
    @IBAction func tappedSubmit() {
        self.validateTextFields()
        
        if self.errorLabel.text == nil || self.errorLabel.text == "" {
            self.registerUser()
        }
    }
    
    // MARK: - Registering
    
    func registerUser() {
        let email = self.emailTextField.text!
        let password = self.passwordTextField.text!
        
        self.submitButton.isEnabled = false
        
        var request = URLRequest(url: URL(string: "https://localhost:8080/login")!)
        request.httpMethod = "POST"
        let bodyDict: [String: Any] = [
            "email" : email,
            "password" : password,
            ]
        let bodyData = try! JSONSerialization.data(withJSONObject: bodyDict, options: .prettyPrinted)
        request.httpBody = bodyData
        URLSession.shared.dataTask(with: request) {
            data, response, error in
            self.submitButton.isEnabled = true
        
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            let user = User(context: context)
            user.emailAddress = email

            // Save the context.
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }.resume()
    }
    
    // MARK: - Validation
    
    func validateTextFields() {
        var errors = [String]()
        if let emailText = self.emailTextField.text {
            if emailText.count == 0 {
                errors.append("Email cannot be empty.")
            } else if !emailText.contains("@") {
                errors.append("Email must include an @.")
            } else {
                let bits = emailText.components(separatedBy: "@")
                if bits.count != 2 {
                    errors.append("Email should only have one @.")
                } else {
                    let domain = bits.last!
                    let domainBits = domain.components(separatedBy: ".")
                    if domainBits.count <= 1 {
                        errors.append("Email domain must contain at least one period.")
                    } else {
                        //Email is reasonably valid.
                    }
                }
            }
        } else {
            errors.append("Email is required.")
        }
        
        if
            let password = self.passwordTextField.text,
            let confirmPassword = self.confirmPasswordTextField.text,
            password == confirmPassword {
            if password.isEmpty {
                errors.append("Password and confirm password cannot be empty.")
            } else if password.count < 6 {
                errors.append("Password must be at least 6 characters long.")
            } else {
                //Password is valid.
            }
        } else {
            errors.append("Password and confirm password must be the same.")
        }

        self.errorLabel.text = errors.joined(separator: "\n")
    }
    
    // MARK: - Text Field Delegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.emailTextField {
            self.passwordTextField.becomeFirstResponder()
        } else if textField == self.passwordTextField {
            self.confirmPasswordTextField.becomeFirstResponder()
        } else {
            self.confirmPasswordTextField.resignFirstResponder()
        }
        
        return false
    }
}
