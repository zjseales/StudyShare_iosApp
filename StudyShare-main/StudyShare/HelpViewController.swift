//
//  HelpViewController.swift
//  StudyShare
//
//  Created by Matthew Jennings on 7/10/22.
//

import UIKit
/**
 Controls the help screen and ensures the correct text is displayed
 */
class HelpViewController: UIViewController {
    
    @IBOutlet weak var textField: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setHelpText()
    }

    /**
     Sets the help text to the correct message for the current screen.
     Determined by the current screen as defined in User. Pulls text from static class Help in HelpText.swift
     */
    func setHelpText(){
        switch User.currentScreen {
        case "home":
            textField.text = Help.homeHelp
        case "addClass":
            textField.text = Help.addClassHelp
        case "transcription":
            textField.text = Help.transHelp
        case "myContent":
            textField.text = Help.myContentHelp
        case "createClass":
            textField.text = Help.createClassHelp
        case "classContent":
            textField.text = Help.classContentHelp
        case "addContent":
            textField.text = Help.addContentHelp
        default:
            textField.text = Help.homeHelp + "ERROR"
        }
    }
    /**
     Dismisses the help screen showing the underlying screen again
     */
    @IBAction func dismissTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
