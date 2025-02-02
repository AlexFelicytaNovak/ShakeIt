//
//  Recipe.swift
//  ShakeIt
//
//  Created by Aleksandra Novák on 07/05/2023.
//

import UniformTypeIdentifiers
import SwiftUI

extension UTType {
    static var recipe: UTType { UTType(exportedAs: "dtu.swift.ShakeIt.recipe") }
}

struct Recipe: Codable, Transferable {
    static var transferRepresentation: some TransferRepresentation {
        CodableRepresentation(contentType: .recipe)
    }
    
    var id: String
    var name: String
    var photo: Data
    var instruction: String
    var glass: String
    var ingredients: [CocktailIngredient]
    var isAlcoholic: Bool
    
}

struct CocktailIngredient: Codable {
    
    var name: String
    var quantity: String
}

extension CustomCocktail {
    func convert() -> Recipe {
        let ingredients = self.ingredients?.map({ ingredient in
            let ingredient = ingredient as? Ingredient
            return CocktailIngredient(name: ingredient?.name ?? "", quantity: ingredient?.quantity ?? "")
        }) ?? [CocktailIngredient]()
        return Recipe(id: self.id ?? "\(Int.random(in: 0...10000))",
                      name: self.name ?? "",
                      photo: self.photo ?? Data(),
                      instruction: self.instruction ?? "",
                      glass: self.glass ?? "",
                      ingredients: ingredients,
                      isAlcoholic: self.isAlcoholic)
    }
    
    func update(with recipe: Recipe) {
        self.id = recipe.id
        self.name = recipe.name
        self.photo = recipe.photo
        self.glass = recipe.glass
        self.instruction = recipe.instruction
        self.isAlcoholic = recipe.isAlcoholic
        self.ingredients = NSSet(array: recipe.ingredients.map({ ingredient in
            let coreDataIngredient = self.managedObjectContext.map({ Ingredient(context: $0) }) ?? Ingredient()
            coreDataIngredient.name = ingredient.name
            coreDataIngredient.quantity = ingredient.quantity
            coreDataIngredient.cocktail = self
            return coreDataIngredient
        }))
    }
}
