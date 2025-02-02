//
//  IngredientView.swift
//  ShakeIt
//
//  Created by Zosia on 07/05/2023.
//

import SwiftUI

struct IngredientView: View {
    let ingredient: CocktailIngredient
    
    @State private var image = Image(systemName: "wineglass")
    var body: some View {
        GroupBox{
            HStack {
                Spacer()
                VStack{
                    Spacer()
                    self.image
                        .font(.system(size: 60))
                        .foregroundColor(Colors.Color1)
                    Text(ingredient.name)
                        .font(.body)
                        .multilineTextAlignment(.center)
                        .foregroundColor(Colors.Color1)
                    Text(ingredient.quantity)
                        .font(.caption)
                        .foregroundColor(Colors.Color1)
                    Spacer()
                }
                Spacer()
            }
        }.groupBoxStyle(ColoredGroupBox())
        .task {
            do{
                guard let encodedName = ingredient.name.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed), let url = URL(string: "https://www.thecocktaildb.com/images/ingredients/\(encodedName)-Small.png")
                else {return}
                
                let (data, response) = try await URLSession.shared.data(from: url)
                if (200...299).contains((response as? HTTPURLResponse)?.statusCode ?? -1), let img = UIImage(data: data)
                {
                    self.image = Image(uiImage: img)
                }
            }
            catch{
                
            }
        }
    }
}

struct IngredientView_Previews: PreviewProvider {
    static var previews: some View {
        IngredientView(ingredient: CocktailIngredient(name: "gin", quantity: "1/2"))
    }
}
