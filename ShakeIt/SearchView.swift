//
//  ContentView.swift
//  ShakeIt
//
//  Created by Aleksandra Novák on 10/03/2023.
//

import SwiftUI

enum SearchCategory{
    case cocktails
    case alcohols
    case nonAlcohols
    case ingredients
}
struct SearchView: View {
    @State var selectedSearchCategory: SearchCategory = .cocktails
    @State private var searchResults = [Cocktail]()
    @State private var searchText = ""
    
    var body: some View {
        NavigationStack {
            List {
                Picker("",selection: $selectedSearchCategory) {
                    Text("Cocktails").tag(SearchCategory.cocktails)
                    Text("Alcohols").tag(SearchCategory.alcohols)
                            
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        
                Section {
                    ForEach(searchResults, id: \.idDrink) { drink in
                        SearchResultsView(drink: drink)
                    }
                    
                }
            }
            .navigationTitle("Search")
        }
        .searchable(text: $searchText)
        .onAppear {
            Task {
                searchResults = try await searchResults()
            }
        }
        .onChange(of: searchText) { _ in
            Task {
                searchResults = try await searchResults()
            }
        }
    }
    
    func searchResults() async throws -> [Cocktail] {
        let url: URL
        if searchText.isEmpty {
            url = URL(string: "https://www.thecocktaildb.com/api/json/v1/1/search.php?f=a")!
        } else {
            let searchTextEncoded = searchText.addingPercentEncoding(withAllowedCharacters: .alphanumerics) ?? ""
            url = URL(string: "https://www.thecocktaildb.com/api/json/v1/1/search.php?s=\(searchTextEncoded)")!
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode(CocktailResults.self, from: data).drinks
    }
}
    

//        Picker("",selection: $selectedSize) {
//            Text("Cocktails").tag(DitherMatrices.D2)
//            Text("Alcohols").tag(DitherMatrices.D3)
//            Text("Other Ingredients").tag(DitherMatrices.D4)
//        }
//        .pickerStyle(SegmentedPickerStyle())
//    
    



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
