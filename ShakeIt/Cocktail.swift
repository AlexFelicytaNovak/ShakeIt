//
//  Cocktail.swift
//  ShakeIt
//
//  Created by Aleksandra Novák on 23/03/2023.
//

import Foundation


struct Cocktail: Decodable {
    let idDrink: String
    let strGlass: String
    let strInstructions: String
    let strDrink: String
    let strAlcoholic: String
    let strDrinkThumb: URL
    
    let strMeasure1: String?
    let strMeasure2: String?
    let strMeasure3: String?
    let strMeasure4: String?
    let strMeasure5: String?
    let strMeasure6: String?
    let strMeasure7: String?
    let strMeasure8: String?
    let strMeasure9: String?
    let strMeasure10: String?
    let strMeasure11: String?
    let strMeasure12: String?
    let strMeasure13: String?
    let strMeasure14: String?
    let strMeasure15: String?
    
    let strIngredient1: String?
    let strIngredient2: String?
    let strIngredient3: String?
    let strIngredient4: String?
    let strIngredient5: String?
    let strIngredient6: String?
    let strIngredient7: String?
    let strIngredient8: String?
    let strIngredient9: String?
    let strIngredient10: String?
    let strIngredient11: String?
    let strIngredient12: String?
    let strIngredient13: String?
    let strIngredient14: String?
    let strIngredient15: String?
    
    init(idDrink: String, strGlass: String, strInstructions: String, strDrink: String, strAlcoholic: String, strDrinkThumb: URL) {
        self.idDrink = idDrink
        self.strGlass = strGlass
        self.strInstructions = strInstructions
        self.strDrink = strDrink
        self.strAlcoholic = strAlcoholic
        self.strDrinkThumb = strDrinkThumb
        self.strMeasure1 = nil
        self.strMeasure2 = nil
        self.strMeasure3 = nil
        self.strMeasure4 = nil
        self.strMeasure5 = nil
        self.strMeasure6 = nil
        self.strMeasure7 = nil
        self.strMeasure8 = nil
        self.strMeasure9 = nil
        self.strMeasure10 = nil
        self.strMeasure11 = nil
        self.strMeasure12 = nil
        self.strMeasure13 = nil
        self.strMeasure14 = nil
        self.strMeasure15 = nil
        self.strIngredient1 = nil
        self.strIngredient2 = nil
        self.strIngredient3 = nil
        self.strIngredient4 = nil
        self.strIngredient5 = nil
        self.strIngredient6 = nil
        self.strIngredient7 = nil
        self.strIngredient8 = nil
        self.strIngredient9 = nil
        self.strIngredient10 = nil
        self.strIngredient11 = nil
        self.strIngredient12 = nil
        self.strIngredient13 = nil
        self.strIngredient14 = nil
        self.strIngredient15 = nil
    }
    
    func convert() async throws -> Recipe {
        var (data, response) = try await URLSession.shared.data(from: strDrinkThumb)
        if (200...299).contains((response as? HTTPURLResponse)?.statusCode ?? -1) == false
        {
            data = Data()
        }
        var recipe = self.quickConvert()
        recipe.photo = data
        return recipe
    }
    
    func quickConvert() -> Recipe {
        var ingredients = [CocktailIngredient]()
        
        if let ingredient = strIngredient1, let measure = strMeasure1
        { ingredients.append(CocktailIngredient(name: ingredient, quantity: measure))}
        if let ingredient = strIngredient2, let measure = strMeasure2
        { ingredients.append(CocktailIngredient(name: ingredient, quantity: measure))}
        if let ingredient = strIngredient3, let measure = strMeasure3
        { ingredients.append(CocktailIngredient(name: ingredient, quantity: measure))}
        if let ingredient = strIngredient4, let measure = strMeasure4
        { ingredients.append(CocktailIngredient(name: ingredient, quantity: measure))}
        if let ingredient = strIngredient5, let measure = strMeasure5
        { ingredients.append(CocktailIngredient(name: ingredient, quantity: measure))}
        if let ingredient = strIngredient6, let measure = strMeasure6
        { ingredients.append(CocktailIngredient(name: ingredient, quantity: measure))}
        if let ingredient = strIngredient7, let measure = strMeasure7
        { ingredients.append(CocktailIngredient(name: ingredient, quantity: measure))}
        if let ingredient = strIngredient8, let measure = strMeasure8
        { ingredients.append(CocktailIngredient(name: ingredient, quantity: measure))}
        if let ingredient = strIngredient9, let measure = strMeasure9
        { ingredients.append(CocktailIngredient(name: ingredient, quantity: measure))}
        if let ingredient = strIngredient10, let measure = strMeasure10
        { ingredients.append(CocktailIngredient(name: ingredient, quantity: measure))}
        if let ingredient = strIngredient11, let measure = strMeasure11
        { ingredients.append(CocktailIngredient(name: ingredient, quantity: measure))}
        if let ingredient = strIngredient12, let measure = strMeasure12
        { ingredients.append(CocktailIngredient(name: ingredient, quantity: measure))}
        if let ingredient = strIngredient13, let measure = strMeasure13
        { ingredients.append(CocktailIngredient(name: ingredient, quantity: measure))}
        if let ingredient = strIngredient14, let measure = strMeasure14
        { ingredients.append(CocktailIngredient(name: ingredient, quantity: measure))}
        if let ingredient = strIngredient15, let measure = strMeasure15
        { ingredients.append(CocktailIngredient(name: ingredient, quantity: measure))}
        
        return Recipe(id: idDrink, name: strDrink, photo: Data(), instruction: strInstructions, glass: strGlass, ingredients: ingredients, isAlcoholic: strAlcoholic.lowercased() == "alcoholic")
    }
}

struct CocktailResults: Decodable {
    let drinks: [Cocktail]
}

struct FullIngredientResults: Decodable {
    let ingredients: [FullIngredient]
}

struct FullIngredient: Decodable {
    let strAlcohol: String?
    let strDescription: String?
    let strIngredient: String
}

struct IngredientResults: Decodable {
    let drinks: [IngredientName]
}

struct IngredientName: Decodable{
    let strIngredient1: String
}
