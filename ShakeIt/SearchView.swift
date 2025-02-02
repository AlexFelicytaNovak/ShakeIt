//
//  ContentView.swift
//  ShakeIt
//
//  Created by Aleksandra Novák on 10/03/2023.
//

import SwiftUI

struct SearchView: View {
    @StateObject var viewModel = SearchViewModel()
    @State private var selectedSearchCategory: SearchCategory = .all
    @State private var searchText = ""
    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor(Colors.Color2)]
    }
    
    var body: some View {
        
        NavigationStack {
            List {
                Picker("",selection: $selectedSearchCategory) {
                    Text("All").tag(SearchCategory.all)
                    Text("Alcoholic").tag(SearchCategory.alcoholic)
                    Text("Non-alcoholic").tag(SearchCategory.nonAlcoholic)
                }
                .pickerStyle(SegmentedPickerStyle())
                .listRowBackground(Colors.Color1)
                
                Section {
                    if viewModel.cocktails.count == 0 {
                        if searchText.isEmpty {
                            HStack {
                                Spacer()
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: Colors.Color1))
                                Spacer()
                            }
                        } else {
                            Text("No cocktails found!")
                                .font(.title2)
                                .bold()
                                .foregroundColor(Colors.Color1)
                                .padding()
                        }
                    } else {
                        ForEach(viewModel.cocktails, id: \.idDrink) { drink in
                            SearchResultsView(drink: drink)
                        }
                    }
                }.listRowBackground(Colors.Color2)
            }
            .padding(.horizontal, 12)
            .scrollContentBackground(.hidden)
            .background(Colors.Color1)
            .navigationTitle("Search")
        }
        .searchable(text: $searchText)
        .task {
            try? await viewModel.searchResults(searchText: searchText, category: selectedSearchCategory)
        }
        .onChange(of: searchText) { newValue in
            Task {
                try await viewModel.searchResults(searchText: newValue, category: selectedSearchCategory)
            }
        }
        .onChange(of: selectedSearchCategory) { newValue in
            Task {
                try await viewModel.searchResults(searchText: searchText, category: newValue)
            }
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
