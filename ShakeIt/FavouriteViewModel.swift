//
//  FavouriteViewModel.swift
//  ShakeIt
//
//  Created by Aleksandra Novák on 08/05/2023.
//

import SwiftUI
import CoreData

final class FavouriteViewModel: ObservableObject {
    @Published var recipe = Recipe(id: "", name: "", photo: Data(), instruction: "", glass: "", ingredients: [], isAlcoholic: true)
    @ObservedObject var favourite: Favourite
    
    init(favourite: Favourite) {
        self.favourite = favourite
        self.recipe = Recipe(id: favourite.id ?? "", name: favourite.name ?? "", photo: Data(), instruction: "", glass: "", ingredients: [], isAlcoholic: true)
    }
    
    func loadRecipe(viewContext: NSManagedObjectContext) async throws{
        guard let id = favourite.id else { return }
        let request = CustomCocktail.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id)
        if let result = try? viewContext.fetch(request).first {
            Task { @MainActor in
                recipe = result.convert()
            }
        } else {
            let (data, _) = try await URLSession.shared.data(from: URL(string: "https://www.thecocktaildb.com/api/json/v1/1/lookup.php?i=\(id)")!)
            guard let fullCocktail = try JSONDecoder().decode(CocktailResults.self, from: data).drinks.first else {return}
            let recipe = try await fullCocktail.convert()
            Task { @MainActor in
                self.recipe = recipe
            }
        }
    }
    
}
