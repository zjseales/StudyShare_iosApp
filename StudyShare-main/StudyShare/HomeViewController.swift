//
//  HomeViewController.swift
//  StudyShare
//
//  Created by Matthew Jennings on 31/07/22.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
import Firebase
/**
 Home view, displays the users classes in a table allowing them to navigate to see the content in those classes
 Provides navigate to other app functionality
 */
class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var classTable: UITableView!
    var selectedIndexPath: IndexPath?

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUserDetails()
        User.currentScreen = "home"
        classTable.dataSource = self
        classTable.delegate = self
        title = "Swipe Actions"
        self.classTable.register(UITableViewCell.self, forCellReuseIdentifier: "groupCell")
    }
    

    /**
     - Parameters:
     - value:tableview: A table view object requesting the cell
     - value: section: Seperates the number of rows into sections
     - Returns: The current count of data in the groupData array
     */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return User.groupData.count
    }

    /**
     - Parameters:
     - value:tableview: A table view object requesting the cell
     - value: Indexpath: Represents the path to a specific location
     - Returns: Displays the class name which the user just created to the cell
     */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "homeCell", for: indexPath) as! HomeViewCell
        cell.paperCode?.text = User.groupData[indexPath.row].name + ": " + User.groupData[indexPath.row].description
        cell.institution?.text = User.groupData[indexPath.row].institution
        cell.yearSem?.text = "Year: " + User.groupData[indexPath.row].year + " Semester: " + User.groupData[indexPath.row].semester
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }

    /**
     - Parameters:
     - value:tableview: A table view object requesting the cell
     - value: Indexpath: An index path locating a row in tableView
     */
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       // let selectedClass = User.groupData[indexPath.row]
        performSegue(withIdentifier: "transition", sender: nil)
        
    }

    /**
     - Parameters:
     - value:segue: The segue object containing information about the view controllers involved in the segue.
     - value: sender: The object that initiated the segue.
     */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "transition" {
            if let indexPath = classTable.indexPathForSelectedRow {
                let nextViewController = segue.destination as! ClassContentViewController
                nextViewController.name = User.groupData[indexPath.row].name
                nextViewController.filepath = User.groupData[indexPath.row].filepath
                User.currentGroup = User.groupData[indexPath.row].filepath
            }
        }
    }

    /**
     Utilizes the currently logged in users UID to retreive their full info from firebase db
     Stores this information in a class dedicated to holding the users info.
     Retrives and stores firstname, lastname, documentID(firebase reference to this user)
     */
    func setUpUserDetails() {
        User.UID = "nil"
        User.docID = "nil"
        User.firstName = "nil"
        User.lastName = "nil"
        User.groups = ["nil"]
        User.groupData = []
        User.currentGroup = "nil"
        if Auth.auth().currentUser != nil {
            let user = Auth.auth().currentUser
            User.UID = user!.uid
            let database = Firestore.firestore()
            let userData = database.collection("users").whereField("uid", isEqualTo: User.UID)
            userData.getDocuments { (querySnaphot, err) in
                if let err = err {
                    print("Error retrieving user data: \(err)")
                } else {
                    let document = querySnaphot!.documents[0]
                    let userDataDict = document.data()
                    User.firstName = (userDataDict["firstname"] as! String)
                    User.lastName = (userDataDict["lastname"] as! String)
                    User.docID = document.documentID
                    User.groups = (userDataDict["groups"] as! [String])
                }
                let database = Firestore.firestore()
                database.collection("classes").getDocuments { (querySnapshot, err) in
                    if let err = err {
                        print("Error retrieving user data: \(err)")
                    } else {
                        for document in querySnapshot!.documents {
                            let groupsDataDict = document.data()
                            var group = Group()
                            
                            group.description   = (groupsDataDict["Description"] as? String ?? "")
                            group.filepath = (groupsDataDict["Filepath"] as? String ?? "")
                            group.institution = (groupsDataDict["Institution"] as? String ?? "")
                            group.name = (groupsDataDict["Name"] as? String ?? "")
                            group.semester = (groupsDataDict["Semester"] as? String ?? "")
                            group.year = (groupsDataDict["Year"] as? String ?? "")
                            
                            let groupVar = Group(description: group.description, filepath: group.filepath, institution: group.institution, name: group.name, semester: group.semester, year: group.year)
                            if User.groups.contains(groupVar.filepath) {
                                User.groupData.append(groupVar)
                            }
                        }
                    }
                    DispatchQueue.main.async {
                        self.classTable.reloadData()
                    }
                }
            }
        }
    }
}
/**
 Defines a cell for the home screen.
 */
class HomeViewCell: UITableViewCell{
    
    @IBOutlet weak var paperCode: UILabel!
    @IBOutlet weak var institution: UILabel!
    @IBOutlet weak var yearSem: UILabel!
    
    
}
