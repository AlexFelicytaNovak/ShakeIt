//
//  MyCocktailsView.swift
//  ShakeIt
//
//  Created by Aleksandra Novák on 07/05/2023.
//

import SwiftUI

struct MyCocktailsView: View {
    @State private var formPresented = false
    @Environment(\.managedObjectContext) var viewContext
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \CustomCocktail.name, ascending: true)])
    var cocktails: FetchedResults<CustomCocktail>
    
    var body: some View {
        NavigationStack {
            List {
                Section(header: Text("")) {
                    if cocktails.count == 0
                    {
                        Text("Tap the plus symbol to create your first custom Cocktail 😉")
                            .font(.title2)
                            .padding(.horizontal)
                            .bold()
                            .foregroundColor(Colors.Color1)
                    }
                    else
                    {
                        ForEach(cocktails) { cocktail in
                            NavigationLink {
                                CocktailDescription(cocktailRecipe: cocktail.convert())
                            } label: {
                                HStack{
                                    VStack{
                                        if let uiImage = UIImage(data: cocktail.convert().photo)
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
                                            Image(systemName: "wineglass")
                                                .aspectRatio(contentMode: .fill)
                                                .font(.system(size: 60, weight: .thin))
                                                .foregroundColor(Colors.Color1)
                                                .frame(width: 90, height: 90)
                                                .clipped()
                                                .overlay {Circle().stroke(Colors.Color1, lineWidth: 3)}
                                                .clipShape(Circle())
                                                
                                        }
                                    }.padding(.trailing)
                                    
                                    Text(cocktail.name ?? "")
                                        .foregroundColor(Colors.Color1)
                                }
                            }
                            .foregroundColor(Colors.Color1)
                        }.onDelete{indexset in indexset.map({cocktails[$0] }).forEach({
                            let favouriteRequest = Favourite.fetchRequest()
                            favouriteRequest.predicate = NSPredicate(format: "id == %@", $0.id ?? "")
                            if let favourite = try? viewContext.fetch(favouriteRequest).first {
                                viewContext.delete(favourite)
                            }
                            viewContext.delete($0)
                        })
                            try? viewContext.save()
                        }
                    }
                } .listRowBackground(Colors.Color2)
            }
            .padding(.horizontal, 12)
            .scrollContentBackground(.hidden)
            .background(Colors.Color1)
            .navigationTitle("My Cocktails")
            .toolbar {
                ToolbarItem {
                    Button{
                        formPresented = true
                    } label: {
                        Label("Add new recipe", systemImage: "plus.circle")
                    }
                }
            }
            .sheet(isPresented: $formPresented) {
                AddNewCocktailView()
            }
        }
    }
}

struct MyCocktailsView_Previews: PreviewProvider {
    static var previews: some View {
        MyCocktailsView()
    }
}
