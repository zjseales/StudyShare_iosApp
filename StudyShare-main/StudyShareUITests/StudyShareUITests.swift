//
//  StudyShareUITests.swift
//  StudyShareUITests
//
//  UI Tests for the StudyShareApp
//

import XCTest

class StudyShareUITests: XCTestCase {
    
    private var app: XCUIApplication!

    /** Initializes an instance of the app.
     */
    override func setUpWithError() throws {
        // In UI tests it is usually best to stop
        // immediately when a failure occurs.
        continueAfterFailure = false
        // launches the app
        self.app = XCUIApplication()
        self.app.launch()

    }

    /** Terminates the app after each test.
     */
    override func tearDownWithError() throws {
        self.app.terminate()
    }

    /** Ensures buttons on the initial start-up screen exist.
     */
    func test_initialView() throws {
        // Ensure initial start up page contains all UI elements
        let signUpButton = self.app.buttons["Sign Up"]
        XCTAssert(signUpButton.exists)
        
        let loginButton = self.app.buttons["Login"]
        XCTAssert(loginButton.exists)
    }
    
    /** Ensures button tap redirects to correct view and that all elements are displayed.
     */
    func test_signUpView() throws {
        // ensure sign up button redirects to the SignUpView
        let signUpButton = self.app.buttons["Sign Up"]
        signUpButton.tap()
        
        let title = self.app.staticTexts["Create Account"]
        XCTAssert(title.exists)
        
        //ensure all text fields are displayed
        var newField = self.app.textFields["First Name"]
        XCTAssert(newField.exists)
        newField = self.app.textFields["Last Name"]
        XCTAssert(newField.exists)
        newField = self.app.textFields["Email"]
        XCTAssert(newField.exists)
        newField = self.app.textFields["Password"]
        //check an invalid text field to further validate the test
        let falseField = self.app.textFields["Doesn't Exist"]
        XCTAssert(!falseField.exists)
        
        //ensure all buttons are displayed and work as expected.
        var button = self.app.buttons["Create Account"]
        XCTAssert(button.exists)
        button.tap()
        //check no input error works
        let errorLabel = self.app.staticTexts["Please fill in all fields"]
        XCTAssert(errorLabel.exists)
        
        // test the back button
        button = self.app.buttons["Back"]
        XCTAssert(button.exists)
        button.tap()
        //ensure back button redirects to initial screen
        XCTAssert(signUpButton.exists)
        let loginButton = self.app.buttons["Login"]
        XCTAssert(loginButton.exists)
    }
    /** Ensure user is redirected to login page when login button is tapped, and that all ui elements exist.
     */
    func test_loginView() throws {
        let loginButton = self.app.buttons["Login"]
        XCTAssert(loginButton.exists)
        loginButton.tap()
        var textF = self.app.textFields["Email"]
        XCTAssert(textF.exists)
        let title = self.app.staticTexts["Sign In"]
        XCTAssert(title.exists)
        let backButton = self.app.buttons["Back"]
        XCTAssert(backButton.exists)
        backButton.tap()
        //ensure back button redirects to initial screen
        XCTAssert(loginButton.exists)
        let signUpButton = self.app.buttons["Sign Up"]
        XCTAssert(signUpButton.exists)
    }

}
