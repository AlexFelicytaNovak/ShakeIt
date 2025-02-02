//
//  IngredientDescriptionView.swift
//  ShakeIt
//
//  Created by Zosia on 09/05/2023.
//

import SwiftUI

struct IngredientDescriptionView: View {
    let ingredient: CocktailIngredient
    @State private var fullIngredient: FullIngredient
    var body: some View {
        List {
            Section(header: Text("")) {
                IngredientDetailView(ingredient: fullIngredient)
            }
            .foregroundColor(Colors.Color1)
            .listRowBackground(Colors.Color2)
        }
        .padding(.horizontal, 12)
        .scrollContentBackground(.hidden)
        .background(Colors.Color1)
        .task {
            do {
                guard let encodedName = ingredient.name.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed), let url = URL(string: "https://www.thecocktaildb.com/api/json/v1/1/search.php?i=\(encodedName)")
                else {return}
                let (data, _) = try await URLSession.shared.data(from: url)
                if let ingr = try JSONDecoder().decode(FullIngredientResults.self, from: data).ingredients.first {
                    fullIngredient = ingr
                }
            } catch {
                
            }
        }
    }
    
    init(ingredient: CocktailIngredient) {
        self.ingredient = ingredient
        self._fullIngredient = State(wrappedValue: FullIngredient(strAlcohol: "Yes", strDescription: "", strIngredient: ingredient.name))
    }
}

struct IngredientDescriptionView_Previews: PreviewProvider {
    static var previews: some View {
        IngredientDescriptionView(ingredient: CocktailIngredient(name: "Gin", quantity: ""))
    }
}
