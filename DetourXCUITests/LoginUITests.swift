//
//  LoginUITests.swift
//  DetourXCUITests
//
//  Created by Ellen Shapiro on 6/2/17.
//  Copyright © 2017 Designated Nerd Software. All rights reserved.
//

import XCTest



class LoginUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        let app = XCUIApplication()
        
        // You can't access anything in the main process directly, so to log out the user, you must pass a launch argument to the process. 
        app.launchArguments = ["TestingLogout"]
        app.launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testLoggingInWithValidEmail() {
        // Cleaned up a bit from the recording
        let app = XCUIApplication()
        let emailDomainComTextField = app.textFields["email@domain.com"]
        emailDomainComTextField.tap()
        emailDomainComTextField.typeText("test@email.com")
        
        let passwordSecureTextField = app.secureTextFields["password"]
        passwordSecureTextField.tap()
        passwordSecureTextField.typeText("password")
    
        app.buttons["Login"].tap()
        app.navigationBars["Welcome, test@email.com"].staticTexts["Welcome, test@email.com"].tap()
    }
}
