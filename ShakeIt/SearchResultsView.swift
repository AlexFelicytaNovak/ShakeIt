//
//  SearchResultsView.swift
//  ShakeIt
//
//  Created by Aleksandra Novák on 26/03/2023.
//

import SwiftUI

struct SearchResultsView: View {
    let drink: Cocktail
    var body: some View {
        NavigationLink {
            CocktailDescription()
        } label: {
            HStack{
                AsyncImage(url: drink.strDrinkThumb, scale: 2)
                { image in
                    image.frame(width: 100, height: 100)
                        .clipped()
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 100, height: 100)
                            
                
                Text(drink.strDrink)
            }
        }
    }
}

struct SearchResultsView_Previews: PreviewProvider {
    static var previews: some View {
        SearchResultsView(drink: Cocktail(idDrink: "1", strDrink: "Sample Drink", strDrinkThumb: URL(string: "https://en.wikipedia.org/wiki/Alcoholic_beverage#/media/File:Common_alcoholic_beverages.jpg")!, ingredient1: nil, ingredient2: nil, ingredient3: nil, ingredient4: nil, ingredient5: nil, ingredient6: nil, ingredient7: nil, ingredient8: nil, ingredient9: nil, ingredient10: nil, ingredient11: nil, ingredient12: nil, ingredient13: nil, ingredient14: nil, ingredient15: nil))
    }
}
