//
//  AddClassViewController.swift
//  StudyShare
//
//  Created by Matthew Jennings on 7/08/22.
//

import UIKit
import FirebaseFirestore
/**
 Allows the user to select from a list of preexisting classes and join them
 */
class AddClassViewController: UIViewController {
    var groups: [Group?] = []
    var groupsFiltered: [Group?] = []
    var previousSelection = -1
    @IBOutlet weak var searchTable: UITableView!
    @IBOutlet weak var filterField: UITextField!
    @IBOutlet weak var addButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        getGroups()
        User.currentScreen = "addClass"
        searchTable.dataSource = self
        searchTable.delegate = self
        self.searchTable.register(UITableViewCell.self, forCellReuseIdentifier: "groupCell")
    }
    
    /**
     Retrieves all groups which are available for the user to add.
     Stores within this class and reloads the table to show them once complete.
     */
    func getGroups() {
        let database = Firestore.firestore()
        database.collection("classes").getDocuments { [self] (querySnapshot, err) in
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
                    
                    self.groups.append(groupVar)
                }
            }
            groupsFiltered = groups
            DispatchQueue.main.async {
                self.searchTable.reloadData()
            }
        }
    }

    /**
     Adds the currently selected class to the users list of classes as defined by UI selection
     */
    @IBAction func addTapped(_ sender: Any) {
        if previousSelection >= 0 {
            let database = Firestore.firestore()
            let dirName = groupsFiltered[previousSelection]!.filepath
            let userRef = database.collection("users").document(User.docID)
            userRef.updateData(["groups": FieldValue.arrayUnion([dirName])])
            User.groups.append(dirName)
            self.transitionToHome()
            
        } else {
            print("Please make a selection")
        }
    }

    /**
     Performs filtering on the shown groups. Updates filtered groups whenever the filter changes.
     */
    @IBAction func filterChanged(_ sender: Any) {
        previousSelection = -1
        let filterText = filterField.text
        if filterText!.count > 0 {
            groupsFiltered = groups.filter {
                ($0?.filepath.uppercased().contains(filterText!.uppercased()))! || $0?.description.uppercased().contains(filterText!.uppercased()) == true
            }
        } else {
            groupsFiltered = groups
        }
        DispatchQueue.main.async {
            self.searchTable.reloadData()
        }
    }

    /**
     Dismisses this screen and sets the current screen to home.
     */
    @IBAction func backTapped(_ sender: Any) {
        User.currentScreen = "home"
        self.dismiss(animated: true, completion: nil)
    }

    /**
    Instantiates and transitions to the home view controller.
    Necessary to force reloading of the class data.
    */
    func transitionToHome() {
        let homeViewController = storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.homeViewController) as? HomeViewController
        view.window?.rootViewController = homeViewController
        view.window?.makeKeyAndVisible()
    }
}

/**
 Table definitions
 */
extension AddClassViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        previousSelection = indexPath.row
    }
}

extension AddClassViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupsFiltered.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = searchTable.dequeueReusableCell(withIdentifier: "addClassCell", for: indexPath) as! AddClassCell
        cell.paperCode?.text = groupsFiltered[indexPath.row]!.name + ": " + groupsFiltered[indexPath.row]!.description
        cell.institution?.text = groupsFiltered[indexPath.row]!.institution
        cell.yearSem?.text = "Year: " + groupsFiltered[indexPath.row]!.year + " Semester: " + groupsFiltered[indexPath.row]!.semester
        return cell
    }
}
/**
 Definition of a table cell on the add class screen
 */
class AddClassCell: UITableViewCell{
    
    @IBOutlet weak var paperCode: UILabel!
    @IBOutlet weak var institution: UILabel!
    @IBOutlet weak var yearSem: UILabel!
    
}
