//
//  RegisterViewController.swift
//  WaitingForInspiration
//
//  Created by Parth shah on 29/08/20.
//  Copyright © 2020 Parth shah. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore

class RegisterViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var firstNameTextField: UITextField!
    
    @IBOutlet weak var lastNameTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var registerButton: UIButton!
    
    @IBOutlet weak var errorLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        errorLabel.alpha = 0
        firstNameTextField.delegate = self
        lastNameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        // Do any additional setup after loading the view.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
          self.view.endEditing(true)
          return false
      }
      
    
    func validateFields() -> String? {
        if firstNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            lastNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            return "Please fill in all fields."
        }
        let cleanedPassword = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if Utilities.isPasswordValid(cleanedPassword) == false{
            return "Please make sure the password has atleast 8 characters, a special character, and a number."
        }
        return nil
    }
    @IBAction func registerTapped(_ sender: Any) {
        let error = validateFields()
        if error != nil {
            errorLabel.text=error!
            errorLabel.alpha = 1
        }
        else{
            let firstName = firstNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let lastName = lastNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            Auth.auth().createUser(withEmail: email, password: password) { (result, err) in
                if err != nil{
                    self.errorLabel.text="Error creating user"
                    self.errorLabel.alpha = 1
                }
                else{
                    self.errorLabel.alpha = 0
                    let db = Firestore.firestore()
                    db.collection("users").addDocument(data: ["firstname" : firstName, "lastname" : lastName, "uid": result!.user.uid]) { (error) in
                        if error != nil {
                            self.errorLabel.text="Error saving user data"
                            self.errorLabel.alpha = 1
                        }
                    }
                    
                    self.transitionToHome()
                    
                }
            }
        }
    }
    
    func transitionToHome(){
        let homeViewController = storyboard?.instantiateViewController(identifier: constants.storyboard.ViewController) as? ViewController
        view.window?.rootViewController = homeViewController
        view.window?.makeKeyAndVisible()
    }
}
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


