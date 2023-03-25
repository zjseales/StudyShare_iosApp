//
//  LoginViewController.swift
//  StudyShare
//
//  Created by Matthew Jennings on 31/07/22.
//

import UIKit
import FirebaseAuth
/**
 Allows a user to log in to a pre-existing account
 If the provided credentials are correct, transitions the user to the home screen
 */
class LoginViewController: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        errorLabel.alpha = 0
        // make the keyboard disappear, when click outside fields
        let tapGesture = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tapGesture)
    }

    /**
    Performs the login operation for a user.
    If valid user data is entered, will transition the user to the home screen.
    */
    @IBAction func loginButtonTapped(_ sender: Any) {
        // Valid text fields
        let err = validateFields()
        if err != nil {
            showError(err!)
        } else {
            // Clean up the text fields
            let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            // Sign in user
            Auth.auth().signIn(withEmail: email, password: password) { result, error in
                if error != nil {
                    self.errorLabel.text = error!.localizedDescription
                    self.errorLabel.alpha = 1
                } else {
                    self.transitionToHome()
                }
            }
        }
    }

    /**
    Validates the fields are correct
     - Returns: A String with an error message if invalid, otherwise nil
    */
    func validateFields() -> String? {
        // Check all fields have data
        if  emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            return "Please fill in all fields"
        }
        return nil
    }

    /**
    Sets error label to the given String
     - Parameters:
            - message: String: The error message to display
    */
    func showError(_ message: String) {
        errorLabel.text = message
        errorLabel.alpha = 1
    }

    /**
    Initilizes the home screen view controller and navigates to it
    */
    func transitionToHome() {
        let homeViewController = storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.homeViewController) as? HomeViewController
        view.window?.rootViewController = homeViewController
        view.window?.makeKeyAndVisible()
    }
}
