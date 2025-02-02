//
//  FavouritesView.swift
//  ShakeIt
//
//  Created by Aleksandra Novák on 10/03/2023.
//

import SwiftUI

struct FavouritesView: View {
    @Environment(\.managedObjectContext) var viewContext
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Favourite.name, ascending: true)])
    var favourites: FetchedResults<Favourite>
    
    var body: some View {
        NavigationStack {
            List {
                Section(header: Text("")) {
                    if favourites.count == 0
                    {
                        Text("Tap the ♥️ symbol on a cocktail to add it here")
                            .font(.title2)
                            .padding(.horizontal)
                            .bold()
                            .foregroundColor(Colors.Color1)
                    } else {
                        ForEach(favourites) { favourite in
                            FavouriteView(favouriteCocktail: favourite)
                        }
                    }
                }.listRowBackground(Colors.Color2)
            }
            .padding(.horizontal, 12)
            .scrollContentBackground(.hidden)
            .background(Colors.Color1)
            .navigationTitle("Favourites")
        }
    }
}

struct FavouritesView_Previews: PreviewProvider {
    static var previews: some View {
        FavouritesView()
    }
}
