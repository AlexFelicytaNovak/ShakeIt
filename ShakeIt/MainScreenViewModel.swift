//
//  MainScreenViewModel.swift
//  ShakeIt
//
//  Created by Zosia on 08/05/2023.
//

import SwiftUI

final class MainScreenViewModel: ObservableObject
{
    @Published var drinkOfTheDayId: String
    @Published var shakeTime: Date
    @Published var image: Image
    @Published var name: String
    @Published var recipe: Recipe
    init()
    {
        let userDefaults = UserDefaults()
        drinkOfTheDayId = userDefaults.string(forKey: "drinkOfTheDay") ?? ""
        shakeTime = (userDefaults.value(forKey: "shakeTime") as? Date) ?? Date()
        name = "Cocktail of the day"
        image = Image(systemName: "wineglass")
        recipe = Recipe(id: "", name: "", photo: Data(), instruction: "", glass: "", ingredients: [], isAlcoholic: true)
        Task{
            if drinkOfTheDayId != ""
            {
                let (data, _) = try await URLSession.shared.data(from: URL(string: "https://www.thecocktaildb.com/api/json/v1/1/lookup.php?i=\(drinkOfTheDayId)")!)
                
                guard let randomCocktail = try JSONDecoder().decode(CocktailResults.self, from: data).drinks.first else {return}
                let coctailRecipe = try await randomCocktail.convert()
                guard let photo = UIImage(data: coctailRecipe.photo) else{ return }
                
                Task{@MainActor in
                    recipe = coctailRecipe
                    name = randomCocktail.strDrink
                    image = Image(uiImage: photo).resizable()
                }
            }
        }
    }
    
    func shake() async throws
    {
        let content = UNMutableNotificationContent()
        content.title = NSLocalizedString("Time to drink!", comment: "")
        content.body = NSLocalizedString("Shake your surprise cocktail!", comment: "")
        content.sound = .default
        
        let trigger  = UNTimeIntervalNotificationTrigger(timeInterval: 24*60*60, repeats: false)
        
        let (data, _) = try await URLSession.shared.data(from: URL(string: "https://www.thecocktaildb.com/api/json/v1/1/random.php")!)
        guard let randomCocktail = try JSONDecoder().decode(CocktailResults.self, from: data).drinks.first else {return}
        let coctailRecipe = try await randomCocktail.convert()
        
        guard let photo = UIImage(data: coctailRecipe.photo) else{ return }
        
        Task{@MainActor in
            let userDefaults = UserDefaults()
            drinkOfTheDayId = randomCocktail.idDrink
            userDefaults.setValue(drinkOfTheDayId, forKey: "drinkOfTheDay")
            
            recipe = coctailRecipe
            name = randomCocktail.strDrink
            image = Image(uiImage: photo).resizable()
            
            UINotificationFeedbackGenerator().notificationOccurred((.success))
            
            withAnimation {
                shakeTime = Date().addingTimeInterval(24*60*60)
                userDefaults.setValue(shakeTime, forKey: "shakeTime")
            }
        }
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger )
        // Schedule the request with the system.
        try await UNUserNotificationCenter.current().add(request)
    }
}
    
