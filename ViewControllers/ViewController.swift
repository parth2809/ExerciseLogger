//
//  ViewController.swift
//  WaitingForInspiration
//
//  Created by Parth shah on 28/08/20.
//  Copyright © 2020 Parth shah. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseAuth

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var HelloLabel: UILabel!
    @IBOutlet weak var exerciseTable: UITableView!
    
    @IBOutlet weak var HistoryLabel: UILabel!
    var exerciseArray = [Exercise](){
        didSet {
            exerciseTable.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return exerciseArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = exerciseTable.dequeueReusableCell(withIdentifier: "prototypeCell", for: indexPath) as! ExerciseTableViewCell
        cell.nameCell.text = exerciseArray[indexPath.row].exerciseName
        cell.descriptionCell.text = exerciseArray[indexPath.row].description
        cell.dateCell.text = exerciseArray[indexPath.row].date
        cell.durationCell.text = exerciseArray[indexPath.row].duration
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
      if editingStyle == .delete {
        let id = exerciseArray[indexPath.row].did
        //self.exerciseTable.deleteRows(at: [indexPath], with: .automatic)
        Firestore.firestore().collection("exercises").document(id).delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                self.exerciseArray.remove(at: indexPath.row)
            }
        }
      }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadUser()
        loadData()
        exerciseTable.delegate=self
        exerciseTable.dataSource=self
        print(exerciseArray)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    
    
    @IBAction func logoutTapped(_ sender: Any) {
        let firebaseAuth = Auth.auth()
        do {
          try firebaseAuth.signOut()
        } catch let signOutError as NSError {
          print ("Error signing out: %@", signOutError)
        }
        
        self.transitionToLogin()
    }
    
    func loadUser(){
        let user = Auth.auth().currentUser
        let db = Firestore.firestore()
        db.collection("users").whereField("uid", isEqualTo: user?.uid as Any).getDocuments() { (documents, error) in
            if error != nil {
                print("Error getting documents: \(String(describing: error))")
            } else {
                for document in documents!.documents {
                    self.HelloLabel.text = "Hey " + (document.data()["firstname"] as! String) + ","
                    self.HistoryLabel.text = "Your Exercise Logs:"
                    
                }
            }
        }
    }
    
    
    func loadData(){
        let user = Auth.auth().currentUser
        let db = Firestore.firestore()
        db.collection("exercises").whereField("uid", isEqualTo: user?.uid as Any)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        let data = document.data()
                        let name = data["exercise_name"] as? String
                        let description = data["description"] as? String
                        let date = data["date"] as? String
                        let duration = data["duration"] as? String
                        let documentID = document.documentID
                        let exerciseObj = Exercise(exerciseName: name!, date: date!, duration: duration!,description: description!, did: documentID)
                        print(exerciseObj)
                        self.exerciseArray.append(exerciseObj)
                        
                    }
                }
        }
    }
    
    func transitionToLogin(){
        let loginViewController = storyboard?.instantiateViewController(identifier: constants.storyboard.LoginViewController) as? LoginViewController
        view.window?.rootViewController = loginViewController
        view.window?.makeKeyAndVisible()
    }
    


}

