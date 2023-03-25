//
//  User.swift
//  StudyShare
//
//  Created by Matthew Jennings on 21/08/22.
//

import Foundation
import UIKit
/**
 Stores information about the currently logged in user for use throughout the app
 */
struct User {
    static var UID: String = "nil"
    static var docID: String = "nil"
    static var firstName: String = "nil"
    static var lastName: String = "nil"
    static var groups: [String] = ["nil"]
    static var groupData: [Group] = []
    static var currentGroup: String = "nil"
    static var currentScreen: String = ""
}
