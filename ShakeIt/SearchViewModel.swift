//
//  SearchViewModel.swift
//  ShakeIt
//
//  Created by Aleksandra Novák on 09/05/2023.
//

import Foundation

enum SearchCategory {
    case all
    case alcoholic
    case nonAlcoholic
}

final class SearchViewModel: ObservableObject {
    @Published var cocktails = [Cocktail]()
    
    private var cocktailsCache = [Cocktail]()
    private var cocktailsCahceLifetime = Date.distantPast
    
    func searchResults(searchText: String = "", category: SearchCategory = .all) async throws {
        let alphabet = ["a", "b", "c", "d", "e", "f", "g", "h", "i","j", "k","l", "m", "n", "o", "p", "q","r", "s", "t", "u","v", "w", "y", "z"]
        var drinks = [Cocktail]()
        if searchText.isEmpty {
            Task { @MainActor in
                self.cocktails = self.cocktailsCache
            }
            if cocktailsCahceLifetime.addingTimeInterval(5*60) < Date() {
                for letter in alphabet {
                    let (data, _) = try await URLSession.shared.data(from: URL(string: "https://www.thecocktaildb.com/api/json/v1/1/search.php?f=\(letter)")!)
                    try? drinks.append(contentsOf: JSONDecoder().decode(CocktailResults.self, from: data).drinks)
                    try await Task.sleep(for: .milliseconds(50))
                    // If we get banned:
//                    try await Task.sleep(for: .milliseconds(300))
                }
                if !drinks.isEmpty {
                    self.cocktailsCache = drinks
                    cocktailsCahceLifetime = Date()
                } else {
                    drinks = self.cocktailsCache
                }
            } else {
                drinks = self.cocktailsCache
            }
        } else {
            let searchTextEncoded = searchText.addingPercentEncoding(withAllowedCharacters: .alphanumerics) ?? ""
            let url = URL(string: "https://www.thecocktaildb.com/api/json/v1/1/search.php?s=\(searchTextEncoded)")!
            let (data, _) = try await URLSession.shared.data(from: url)
            drinks = try JSONDecoder().decode(CocktailResults.self, from: data).drinks
        }
        let filteredDrinks: [Cocktail]
        if category == .alcoholic {
            filteredDrinks = drinks.filter({ $0.strAlcoholic.lowercased() == "alcoholic" })
        } else if category == .nonAlcoholic {
            filteredDrinks = drinks.filter({ $0.strAlcoholic.lowercased() != "alcoholic" })
        } else {
            filteredDrinks = drinks
        }
        
        Task { @MainActor in
            self.cocktails = filteredDrinks
        }
    }

}
