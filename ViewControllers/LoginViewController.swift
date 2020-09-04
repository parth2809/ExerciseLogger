//
//  LoginViewController.swift
//  WaitingForInspiration
//
//  Created by Parth shah on 28/08/20.
//  Copyright © 2020 Parth shah. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import Firebase
class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        self.errorLabel.alpha = 0
        self.emailTextField.delegate = self
        self.passwordTextField.delegate = self
        
        // Do any additional setup after loading the view.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    @IBAction func loginTapped(_ sender: Any) {
        let email=emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password=passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            
            if error != nil{
                self.errorLabel.text = error!.localizedDescription
                self.errorLabel.alpha = 1
            } else{
                self.errorLabel.alpha = 0
                let homeViewController = self.storyboard?.instantiateViewController(identifier: constants.storyboard.ViewController) as? ViewController
                self.view.window?.rootViewController = homeViewController
                self.view.window?.makeKeyAndVisible()
            }
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

}
