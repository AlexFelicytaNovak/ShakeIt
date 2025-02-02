//
//  AddNewCocktailViewModel.swift
//  ShakeIt
//
//  Created by Aleksandra Novák on 08/05/2023
//

import Foundation
import Combine
import CoreData

final class AddNewCocktailViewModel: ObservableObject {
    @Published var imageData: Data = Data()
    @Published var name: String = ""
    @Published var instruction: String = ""
    @Published var isAlcoholic = true
    @Published var ingredients: [CocktailIngredient] = []
    
    @Published var alcoholsIngredients: [FullIngredient] = []
    @Published var nonAlcoholsIngredients: [FullIngredient] = []
    
    
    func loadData() async throws {
        guard let url = URL(string: "https://www.thecocktaildb.com/api/json/v1/1/list.php?i=list")
        else {return}
        
        let (data, _) = try await URLSession.shared.data(from: url)
        
        let ingredientsList = try JSONDecoder().decode(IngredientResults.self, from: data)
        for ingredient in ingredientsList.drinks {
            guard let encodedName = ingredient.strIngredient1.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed), let url = URL(string: "https://www.thecocktaildb.com/api/json/v1/1/search.php?i=\(encodedName)")
            else {continue}
            let (data, _) = try await URLSession.shared.data(from: url)
            
            guard let decoded = try? JSONDecoder().decode(FullIngredientResults.self, from: data).ingredients.first else { continue }
            Task {@MainActor in
                if decoded.strAlcohol?.lowercased() == "yes" {
                    alcoholsIngredients.append(decoded)
                } else {
                    nonAlcoholsIngredients.append(decoded)
                }
            }
//            try await Task.sleep(for: .milliseconds(50))
            // If we get banned:
            try await Task.sleep(for: .milliseconds(500))
        }
    }
    
    func saveCocktail(viewContext: NSManagedObjectContext) throws {
        let customCocktail = CustomCocktail(context: viewContext)
        
        customCocktail.id = UUID().uuidString
        customCocktail.name = name
        customCocktail.instruction = instruction
        customCocktail.photo = imageData
        customCocktail.isAlcoholic = isAlcoholic
                
        customCocktail.ingredients = NSSet(array: ingredients.map({ ingredient in
            let coreDataIngredient = Ingredient(context: viewContext)
            coreDataIngredient.name = ingredient.name
            coreDataIngredient.quantity = ingredient.quantity
            coreDataIngredient.cocktail = customCocktail
            return coreDataIngredient
        }))
        
        try viewContext.save()
    }
}
