//
//  ShakeItTests.swift
//  ShakeItTests
//
//  Created by Aleksandra Novák on 10/03/2023.
//

import XCTest
@testable import ShakeIt

final class ShakeItTests: XCTestCase {

    let cocktail = Cocktail(idDrink: "1", strGlass: "Prosecco glass", strInstructions: "Pour Prosecco into the glass and add the cotton candy as a decoration", strDrink: "Cotton Candy Prosecco", strAlcoholic: "Alcoholic", strDrinkThumb: URL(string: "https://upload.wikimedia.org/wikipedia/commons/thumb/c/ce/Prosecco_di_Conegliano_bottle_and_glass.jpg/1024px-Prosecco_di_Conegliano_bottle_and_glass.jpg")!)
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testConversion() async throws {
   
        let recipe = try await cocktail.convert()
        XCTAssertEqual(cocktail.idDrink, recipe.id)
        XCTAssertEqual(cocktail.strDrink, recipe.name)
        XCTAssertEqual(cocktail.strInstructions, recipe.instruction)
        XCTAssertEqual(true, recipe.isAlcoholic)
        XCTAssert(recipe.photo.count > 0)
        XCTAssertEqual(cocktail.strGlass, recipe.glass)

    }
    
    func testLoadingTheData() async throws{
        let recipe = try await cocktail.convert()
        let customCocktail = CustomCocktail(context: PersistenceController.shared.container.viewContext)
        customCocktail.update(with: recipe)
        
        XCTAssertEqual(customCocktail.id, recipe.id)
        XCTAssertEqual(customCocktail.name, recipe.name)
        XCTAssertEqual(customCocktail.instruction, recipe.instruction)
        XCTAssertEqual(customCocktail.isAlcoholic, recipe.isAlcoholic)
        XCTAssertEqual(customCocktail.photo, recipe.photo)
        XCTAssertEqual(customCocktail.glass, recipe.glass)
    }
    
    func testSavingTheData() async throws{
        let recipe = try await cocktail.convert()
        let customCocktail = CustomCocktail(context: PersistenceController.shared.container.viewContext)
        customCocktail.update(with: recipe)
        
        let newRecipe = customCocktail.convert()
        
        XCTAssertEqual(newRecipe.id, recipe.id)
        XCTAssertEqual(newRecipe.name, recipe.name)
        XCTAssertEqual(newRecipe.instruction, recipe.instruction)
        XCTAssertEqual(newRecipe.isAlcoholic, recipe.isAlcoholic)
        XCTAssertEqual(newRecipe.photo, recipe.photo)
        XCTAssertEqual(newRecipe.glass, recipe.glass)
    }
    
    func testShaking() async throws{
        UserDefaults().removeObject(forKey: "shakeTime")
        UserDefaults().removeObject(forKey: "drinkOfTheDay")
        let mainScreenViewModel = MainScreenViewModel()
        
        XCTAssert(mainScreenViewModel.shakeTime.addingTimeInterval(1) > Date())
        XCTAssert(mainScreenViewModel.drinkOfTheDayId == "")
        
        try await mainScreenViewModel.shake()
        try await Task.sleep(for: .milliseconds(3))
        
        XCTAssert(mainScreenViewModel.drinkOfTheDayId != "")
        XCTAssert(mainScreenViewModel.shakeTime.addingTimeInterval(2) > Date().addingTimeInterval(24*60*60))
        
        XCTAssert(!mainScreenViewModel.name.isEmpty)
        XCTAssertEqual(mainScreenViewModel.name, mainScreenViewModel.recipe.name)
        
    }
    
    func testAddToFavourite() async throws{
        let cocktailDescriptionViewModel = await CocktailDescriptionViewModel(cocktailRecipe: try cocktail.convert())
        cocktailDescriptionViewModel.addToFavourite()
        cocktailDescriptionViewModel.fetchFavouriteStatus()
        
        XCTAssert(cocktailDescriptionViewModel.isFavourite)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
