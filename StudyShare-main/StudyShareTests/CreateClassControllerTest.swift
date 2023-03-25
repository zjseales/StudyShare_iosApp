//
//  CreateClassControllerTest.swift
//  StudyShareTests
//
//  Unit testing class for the CreateClassViewController.
//  Created by Zac Seales on 24/09/22.
//

import XCTest

@testable import StudyShare

class CreateClassControllerTest: XCTestCase {
    
    private var vc: CreateClassViewController!

    /** Initializes instance of the CreateClassViewController for test use.
     */
    override func setUpWithError() throws {
        self.vc = CreateClassViewController()
    }
    /** Closes the instance of the View Controller.
     */
    override func tearDownWithError() throws {
        self.vc = nil
    }
    
    /** Tests multiple possible valid input parameters.
     */
    func test_validateFields_validInput() throws {
        
        XCTAssertEqual(self.vc.validateFields(paperCode: "TEST123", paperDesc: "A test paper.", year: "2023", semester: "SS", institution: "Otago University"), nil)
        
        XCTAssertEqual(self.vc.validateFields(paperCode: "TEST123", paperDesc: "This can be anything.", year: "2022", semester: "1", institution: "Massey"), nil)
        
        XCTAssertEqual(self.vc.validateFields(paperCode: "pppp999", paperDesc: "No string can end in a '\' character or the app will break", year: "2022", semester: "2", institution: "Need more validation here."), nil)
    }
    
    /** Tests all input validation scenarios. (Not including missing input).
     */
    func test_validateFields_invalidInput() throws {
        var result: String
        // invalid semester
        result = self.vc.validateFields(paperCode: "TEST123", paperDesc: "A test paper.", year: "2022", semester: "s1", institution: "Otago University")!
        XCTAssertEqual(result, "Semester must be 1, 2, SS or FY")
        
        //invalid year
        result = self.vc.validateFields(paperCode: "TEST123", paperDesc: "A test paper.", year: "2020", semester: "SS", institution: "Otago University")!
        XCTAssertEqual(result, "Year must be this year or next year")
        
        //test all invalid paperCode scenarios
        result = self.vc.validateFields(paperCode: "TEST12s", paperDesc: "A test paper.", year: "2022", semester: "SS", institution: "Otago University")!
        XCTAssertEqual(result, "Paper code must be in the format COSC345")
        result = self.vc.validateFields(paperCode: "TEST12", paperDesc: "A test paper.", year: "2022", semester: "SS", institution: "Otago University")!
        XCTAssertEqual(result, "Paper code must be in the format COSC345")
        result = self.vc.validateFields(paperCode: "TE12345", paperDesc: "A test paper.", year: "2022", semester: "SS", institution: "Otago University")!
        XCTAssertEqual(result, "Paper code must be in the format COSC345")
        
    }

    /** Check each possible instance of 'required input missing' when trying to create a new class.
     */
    func test_validateFields_missingInput() throws {
        var result: String
        let errorMessage = "Please fill out "
        
        //test no paperCode
        result = self.vc.validateFields(paperCode: "", paperDesc: "A test paper.", year: "2023", semester: "SS", institution: "Otago University")!
        XCTAssertEqual(result, errorMessage + "name")
        
        //test no paperDesc
        result = self.vc.validateFields(paperCode: "TEST567", paperDesc: "", year: "2023", semester: "SS", institution: "Otago University")!
        XCTAssertEqual(result, errorMessage + "description")
        
        //test no year
        result = self.vc.validateFields(paperCode: "TEST567", paperDesc: "A test paper.", year: "", semester: "SS", institution: "Otago University")!
        XCTAssertEqual(result, errorMessage + "year")
        
        //test no semester
        result = self.vc.validateFields(paperCode: "TEST567", paperDesc: "A test Paper.", year: "2023", semester: "", institution: "Otago University")!
        XCTAssertEqual(result, errorMessage + "semester")

        //test no institution
        result = self.vc.validateFields(paperCode: "TEST567", paperDesc: "A test Paper.", year: "2023", semester: "2", institution: "")!
        XCTAssertEqual(result, errorMessage + "institution")

    }

}
