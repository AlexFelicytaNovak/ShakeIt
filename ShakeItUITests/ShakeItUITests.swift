//
//  ShakeItUITests.swift
//  ShakeItUITests
//
//  Created by Aleksandra Novák on 10/03/2023.
//

import XCTest

final class ShakeItUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testMainScreen() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()
        let clickMeButton = app.buttons["Click me!"]
        XCTAssert(clickMeButton.exists)
        
        clickMeButton.tap()
        
        let shakeMeText = app.staticTexts["Shake me!"]
        XCTAssert(shakeMeText.exists)
        
        let plusButton = app.buttons["Add new recipe"]
        XCTAssert(plusButton.exists)
        
        let title = app.staticTexts["Time to drink!"]
        XCTAssert(title.exists)
        
    }
    
    func testSearchScreen() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()
        app.tabBars.firstMatch.buttons["Search"].tap()
        
        let title = app.staticTexts["Search"]
        XCTAssert(title.exists)
        
        let allSegment = app.buttons["All"]
        XCTAssert(allSegment.exists)
        
        let alcoholicSegment = app.buttons["Alcoholic"]
        XCTAssert(alcoholicSegment.exists)
        
        let nonAlcoholicSegment = app.buttons["Non-alcoholic"]
        XCTAssert(nonAlcoholicSegment.exists)
        
        let searchField = app.searchFields["Search"]
        XCTAssert(searchField.exists)
        
    }
    
    func testFavouritesScreen() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()
        app.tabBars.firstMatch.buttons["Favourites"].tap()
        
        let title = app.staticTexts["Favourites"]
        XCTAssert(title.exists)
    }
    
    func testMyCocktailsScreen() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()
        app.tabBars.firstMatch.buttons["My List"].tap()
        
        let title = app.staticTexts["My Cocktails"]
        XCTAssert(title.exists)
        
        let plusButton = app.buttons["Add new recipe"]
        XCTAssert(plusButton.exists)
        
    }
    
    func testAddNewCocktailScreen() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()
        app.buttons["Add new recipe"].tap()
        
        let imageText = app.staticTexts["Image"]
        XCTAssert(imageText.exists)
        
        let isAlcoholicText = app.staticTexts["Contains Alcohol"]
        XCTAssert(isAlcoholicText.exists)
        
        let isAlcoholicToggle = app.switches["Contains Alcohol"]
        XCTAssert(isAlcoholicToggle.isEnabled)
        
        let imageButton = app.buttons["Image"]
        XCTAssert(imageButton.exists)
        
        let nameField = app.textViews["Name"]
        XCTAssert(nameField.exists)
        
        let recipeField = app.textViews["Recipe"]
        XCTAssert(recipeField.exists)
        
        let searchField = app.textFields["Search"]
        XCTAssert(searchField.exists)
        
        let saveButton = app.buttons["Save"]
        XCTAssert(saveButton.exists)
        XCTAssert(!saveButton.isEnabled)
        
        let cancelButton = app.buttons["Cancel"]
        XCTAssert(cancelButton.exists)
        XCTAssert(cancelButton.isEnabled)
        
        nameField.tap()
        nameField.typeText("Prosecco")
        XCTAssert(app.textViews["Prosecco"].exists)
        XCTAssert(!saveButton.isEnabled)
        
    }
    
    func testAddNewIngredientScreen() throws {
        let app = XCUIApplication()
        app.launch()
        app.buttons["Add new recipe"].tap()
        app.staticTexts["Light Rum"].tap()
        
        let addButton = app.buttons["Add"]
        XCTAssert(addButton.exists)
        XCTAssert(!addButton.isEnabled)
        
        let name = app.staticTexts["Light Rum"]
        XCTAssert(name.exists)
        
        let quantityField = app.textViews["Enter Quantity"]
        XCTAssert(quantityField.exists)
        
        quantityField.tap()
        quantityField.typeText("One part")
        XCTAssert(app.textViews["One part"].exists)
        XCTAssert(addButton.isEnabled)
        
        addButton.tap()
        XCTAssertFalse(addButton.waitForExistence(timeout: 0.5))
    }
    
    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
