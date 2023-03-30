//
//  Cocktail.swift
//  ShakeIt
//
//  Created by Aleksandra Novák on 23/03/2023.
//

import Foundation

struct Cocktail: Decodable {
    let idDrink: String
    let strDrink: String
    let strDrinkThumb: URL
    // Ingredients
    let ingredient1: String?
    let ingredient2: String?
    let ingredient3: String?
    let ingredient4: String?
    let ingredient5: String?
    let ingredient6: String?
    let ingredient7: String?
    let ingredient8: String?
    let ingredient9: String?
    let ingredient10: String?
    let ingredient11: String?
    let ingredient12: String?
    let ingredient13: String?
    let ingredient14: String?
    let ingredient15: String?
}

struct CocktailResults: Decodable {
    let drinks: [Cocktail]
}
