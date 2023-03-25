//
//  SignUpControllerTest.swift
//  StudyShareTests
//
//  Unit Test for the SignUpViewController.
//  Created by Zac Seales on 21/09/22.
//

import XCTest

@testable import StudyShare

class SignUpControllerTest: XCTestCase {
    
    private var firstName: String!
    private var lastName: String!
    private var password: String!
    private var email: String!
    
    private var vm: SignUpViewController!

    /** Set up an instance of the controller as well as some test data.
     */
    override func setUpWithError() throws {
        // set up test data
        self.vm = SignUpViewController()
        self.firstName = "fnameTest"
        self.lastName = "lnameTest"
        self.email = "email@test.com"
        self.password = "passTest1?"
        
    }

    /** Closes the controller instance.
     */
    override func tearDownWithError() throws {
        self.vm = nil
    }
    
    /** Ensures valid input correctly returns nil.
     */
    func test_validateFields_validInput() throws {
        XCTAssertEqual(self.vm.validateFields(fname: self.firstName, lname: self.lastName, email: self.email, password: self.password), nil)
        XCTAssertEqual(self.vm.validateFields(fname: "arbit", lname: "rary", email: "test@email.co.nz", password: "validPassword%67?"), nil)
    }
    
    /** Tests multiple cases of invalid password input.
     */
    func test_validateFields_invalidPassword() throws {
        let errorMessage = "Password must contain at least 8 characters, a number and a symbol. Valid symbols are @$#!%*?&"
        
        // first ensure no error message is shown
        XCTAssertEqual(self.vm.validateFields(fname: self.firstName, lname: self.lastName, email: self.email, password: self.password), nil)
        
        // Test multiple invalid cases
        XCTAssertEqual(self.vm.validateFields(fname: self.firstName, lname: self.lastName, email: self.email, password: "passTest+"), errorMessage)
        
        XCTAssertEqual(self.vm.validateFields(fname: self.firstName, lname: self.lastName, email: self.email, password: "test"), errorMessage)
        
        XCTAssertEqual(self.vm.validateFields(fname: self.firstName, lname: self.lastName, email: self.email, password: "123456?"), errorMessage)
        
        XCTAssertEqual(self.vm.validateFields(fname: self.firstName, lname: self.lastName, email: self.email, password: "passTest36873"), errorMessage)
        
        XCTAssertEqual(self.vm.validateFields(fname: self.firstName, lname: self.lastName, email: self.email, password: "a"), errorMessage)
    }
    
    /** Tests a few of the validateFields method cases when input fields are left empty,
     *  to ensure method is detecting and managing invalid input correctly.
     */
    func test_validateFields_failure() throws {
        let errorMessage = "Please fill in all fields"
        
        // first ensure no error message is shown
        XCTAssertEqual(self.vm.validateFields(fname: self.firstName, lname: self.lastName, email: self.email, password: self.password), nil)
        
        //test no email
        self.email = ""
        XCTAssertEqual(self.vm.validateFields(fname: self.firstName, lname: self.lastName, email: self.email, password: self.password), errorMessage)
        
        // test no first name
        self.firstName = ""
        self.email = "email@test.com"
        XCTAssertEqual(self.vm.validateFields(fname: self.firstName, lname: self.lastName, email: self.email, password: self.password), errorMessage)
        
        // test no password
        self.firstName = "fNameTest"
        self.password = ""
        XCTAssertEqual(self.vm.validateFields(fname: self.firstName, lname: self.lastName, email: self.email, password: self.password), errorMessage)
        
        //test no last name
        self.lastName = ""
        self.password = "passTest1?"
        XCTAssertEqual(self.vm.validateFields(fname: self.firstName, lname: self.lastName, email: self.email, password: self.password), errorMessage)
        
        // add back in the missing value and test valid case
        // to further validate this test method
        self.lastName = "lnameTest"
        XCTAssertEqual(self.vm.validateFields(fname: self.firstName, lname: self.lastName, email: self.email, password: self.password), nil)
    }

}
