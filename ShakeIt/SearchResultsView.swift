//
//  SearchResultsView.swift
//  ShakeIt
//
//  Created by Aleksandra Novák on 26/03/2023.
//

import SwiftUI

struct SearchResultsView: View {
    @State private var recipe: Recipe
    let drink: Cocktail
    var body: some View {
        NavigationLink {
            CocktailDescription(cocktailRecipe: recipe)
        } label: {
            HStack{
                VStack{
                    if let uiImage = UIImage(data: recipe.photo)
                    {
                        Image (uiImage: uiImage)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .clipShape(Circle())
                            .frame(width: 90, height: 90)
                            .clipped()
                    }
                    else
                    {
                        ProgressView().frame(width: 90, height: 90)
                            .progressViewStyle(CircularProgressViewStyle(tint: Colors.Color1))
                    }
                }.padding(.trailing)
                
                Text(drink.strDrink).foregroundColor(Colors.Color1)
            }
        }
        .foregroundColor(Colors.Color1)
        .task {
            do {
                let recipe = try await drink.convert()
                self.recipe = recipe
            }
            catch {
                
            }
        }
    }
    
    init(drink: Cocktail) {
        self.drink = drink
        self._recipe = State(initialValue: drink.quickConvert())
    }
}

struct SearchResultsView_Previews: PreviewProvider {
    static var previews: some View {
        SearchResultsView(drink: Cocktail(idDrink: "1", strGlass: "", strInstructions: "",
                                          strDrink: "Sample Drink", strAlcoholic: "Alcoholic",
                                          strDrinkThumb: URL(string: "https://en.wikipedia.org/wiki/Alcoholic_beverage#/media/File:Common_alcoholic_beverages.jpg")!))
    }
}
