//
//  WorkoutFormViewController.swift
//  WaitingForInspiration
//
//  Created by Parth shah on 02/09/20.
//  Copyright © 2020 Parth shah. All rights reserved.
//
import Foundation
import UIKit
import FirebaseAuth
import FirebaseFirestore

class WorkoutFormViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var workoutLabel: UILabel!
    @IBOutlet weak var workoutNameTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var durationTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        self.errorLabel.alpha = 0
        workoutNameTextField.delegate = self
        durationTextField.delegate = self
        descriptionTextField.delegate = self
        dateTextField.delegate = self
        self.dateTextField.setInputViewDatePicker(target: self, selector: #selector(tapDone))
    }
    @objc func tapDone() {
        if let datePicker = self.dateTextField.inputView as? UIDatePicker { // 2-1
            let dateformatter = DateFormatter() // 2-2
            dateformatter.dateStyle = .medium // 2-3
            self.dateTextField.text = dateformatter.string(from: datePicker.date) //2-4
        }
        self.dateTextField.resignFirstResponder() // 2-5
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        self.view.endEditing(true)
        return false
    }
    
    @IBAction func savedTapped(_ sender: Any) {
        let date = dateTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let workoutName = workoutNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let duration = durationTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let description = descriptionTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let user = Auth.auth().currentUser
    
        let db = Firestore.firestore()
        db.collection("exercises").addDocument(data: ["exercise_name" : workoutName, "date" : date, "duration" : duration, "description": description, "uid" : user?.uid as Any]){
            (err) in
            if err != nil {
                self.errorLabel.text="Error saving exercise"
                self.errorLabel.alpha = 1
            }
        }
        self.transitionToHome()
    
    }
    
    func transitionToHome(){
        let homeViewController = storyboard?.instantiateViewController(identifier: constants.storyboard.ViewController) as? ViewController
        view.window?.rootViewController = homeViewController
        view.window?.makeKeyAndVisible()
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
