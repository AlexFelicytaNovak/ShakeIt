//
//  CocktailDescriptionViewModel.swift
//  ShakeIt
//
//  Created by Aleksandra Novák on 09/05/2023.
//

import SwiftUI
import Combine

final class CocktailDescriptionViewModel: ObservableObject {
    private let viewContext = PersistenceController.shared.container.viewContext
    @Published var isFavourite = false
    @Published var isHeartShown = false
    private var favourite: Favourite?
    private var subscribers = [AnyCancellable]()
    
    let cocktailRecipe: Recipe

    var image: Image {
        if let img = UIImage(data: cocktailRecipe.photo)
        {
            return Image(uiImage: img).resizable()
        }
        else
        {
            return Image(systemName: "wineglass")
            
        }
    }
    
    init(cocktailRecipe: Recipe) {
        self.cocktailRecipe = cocktailRecipe
        self.fetchFavouriteStatus()
    }
    
    func fetchFavouriteStatus() {
        let fetchRequest = Favourite.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", cocktailRecipe.id)
        favourite = try? viewContext.fetch(fetchRequest).first
        if favourite != nil, favourite?.id != nil {
            self.isFavourite = true
            subscribers.append(favourite!.publisher(for: \.id).sink(receiveValue: { newValue in
                if newValue == nil {
                    self.isFavourite = false
                }
            }))
        }
        else
        {
            self.isFavourite = false
        }
    }
    
    func addToFavourite() {
        withAnimation{
            self.isHeartShown = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)){
            withAnimation{
                self.isHeartShown = false
            }
        }
        
        let favourite = Favourite(context: viewContext)
        favourite.id = cocktailRecipe.id
        favourite.name = cocktailRecipe.name
        self.favourite = favourite
        try? viewContext.save()
        subscribers.append(favourite.publisher(for: \.id).sink(receiveValue: { newValue in
            if newValue == nil {
                self.isFavourite = false
            }
        }))
    }
    
    func removeFromFavourite() {
        self.subscribers.forEach({ $0.cancel() })
        if let favourite = favourite
        {
            favourite.id = nil
            viewContext.delete(favourite)
            try? viewContext.save()
        }
        self.favourite = nil
    }
}
