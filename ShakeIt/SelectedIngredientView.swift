//
//  SelectedIngredientView.swift
//  ShakeIt
//
//  Created by Aleksandra Novák on 08/05/2023.
//

import SwiftUI

struct SelectedIngredientView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: AddNewCocktailViewModel
    
    let ingredient: FullIngredient
    @State private var quantity: String = ""
    var body: some View {
        NavigationStack {
            Form {
                
                Section(header: Text("Ingredient")) {
                    IngredientDetailView(ingredient: ingredient)
                }
                Section(header: Text("Quantity")) {
                    TextField("Enter Quantity", text: $quantity, axis: .vertical).padding(.vertical, 3)
                        .lineLimit(1...2)
                }
                
            }.toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add"){
                        viewModel.ingredients.append(CocktailIngredient(name: ingredient.strIngredient, quantity: quantity))
                        dismiss()
                        
                    }.disabled(quantity.isEmpty)
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel"){
                        dismiss()
                    }
                }
            }
        }
    }
}

struct SelectedIngredientView_Previews: PreviewProvider {
    static var previews: some View {
        SelectedIngredientView(viewModel: AddNewCocktailViewModel(), ingredient: FullIngredient(strAlcohol: "Yes", strDescription: "", strIngredient: "Gin"))
    }
}
