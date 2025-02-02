//
//  ShakeItApp.swift
//  ShakeIt
//
//  Created by Aleksandra Novák on 10/03/2023.
//

import SwiftUI

@main
struct ShakeItApp: App {
    let persistenceController = PersistenceController.shared
    
    @State private var recipe: Recipe?
    @State private var oppacity: Bool = true
    var body: some Scene {
        WindowGroup {
            let isPresented = Binding(
                get: { self.recipe != nil },
                set: { newValue in newValue == false ? self.recipe = nil : () }
            )
            ZStack{
                TabView {
                    MainScreenView()
                        .tabItem {
                            Label("Shake it", systemImage: "wineglass")
                        }
                    SearchView()
                        .tabItem {
                            Label("Search", systemImage: "magnifyingglass")
                        }
                    FavouritesView()
                        .tabItem {
                            Label("Favourites", systemImage: "heart.fill")
                        }
                    MyCocktailsView()
                        .tabItem {
                            Label("My List", systemImage: "list.bullet.clipboard")
                        }
                }
                ZStack{
                    Colors.Color1.ignoresSafeArea()
                    VStack{
                        
                        Image("Image").resizable().frame(width: 250, height: 250).padding(.vertical)
                    }
                }.opacity(oppacity ? 1 : 0)
            }
            .onAppear{
                Task{
                    try await Task.sleep(for: .seconds(1))
                    self.oppacity = false
                }
                UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { _, _ in
                    //
                }
            }
            .onOpenURL { url in
                if url.isFileURL {
                    do {
                        let data = try Data(contentsOf: url)
                        let recipe = try JSONDecoder().decode(Recipe.self, from: data)
                        
                        let customCocktail = CustomCocktail(context: persistenceController.container.viewContext)
                        
                        customCocktail.update(with: recipe)
                        self.recipe = recipe
                        
                        try persistenceController.container.viewContext.save()
                    } catch {
                        
                    }
                }
            }
            .environment(\.managedObjectContext, persistenceController.container.viewContext)
            .sheet(isPresented: isPresented, content: {
                NavigationStack {
                    CocktailDescription(cocktailRecipe: recipe!)
                        .toolbar {
                            ToolbarItem(placement: .cancellationAction) {
                                Button("Cancel", role: .cancel) {
                                    self.recipe = nil
                                }
                            }
                        }
                }.environment(\.managedObjectContext, persistenceController.container.viewContext)
            })
        }
    }
}
