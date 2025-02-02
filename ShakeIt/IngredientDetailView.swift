//
//  IngredientDetailView.swift
//  ShakeIt
//
//  Created by Zosia on 09/05/2023.
//

import SwiftUI

struct IngredientDetailView: View {
    let ingredient: FullIngredient
    
    @State private var image: Image = Image(systemName: "takeoutbag.and.cup.and.straw")
    
    var body: some View {
        HStack {
            Spacer()
            image
                .font(.system(size: 100))
                .aspectRatio(contentMode: .fill)
                .foregroundColor(.pink)
                .frame(width: 200, height: 200)
            Spacer()
        }.task {
            do{
                guard let encodedName = ingredient.strIngredient.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed), let url = URL(string: "https://www.thecocktaildb.com/images/ingredients/\(encodedName)-Medium.png")
                else {return}
                
                let (data, response) = try await URLSession.shared.data(from: url)
                if (200...299).contains((response as? HTTPURLResponse)?.statusCode ?? -1), let img = UIImage(data: data)
                {
                    self.image = Image(uiImage: img).resizable()
                }
            }
            catch{
                
            }
        }
        Text(ingredient.strIngredient)
            .font(.title)
            .bold()
            .padding(5)
        if let description = ingredient.strDescription, !description.isEmpty {
            Text(description)
        }
    }
}

struct IngredientDetailView_Previews: PreviewProvider {
    static var previews: some View {
        IngredientDetailView(ingredient: FullIngredient(strAlcohol: "Yes", strDescription: "", strIngredient: "Gin"))
    }
}
