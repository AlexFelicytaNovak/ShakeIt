//
//  MyCocktailView.swift
//  ShakeIt
//
//  Created by Zosia on 09/05/2023.
//

import SwiftUI

struct MyCocktailView: View {
    @ObservedObject var cocktail: CustomCocktail
    var body: some View {
        NavigationLink {
            CocktailDescription(cocktailRecipe: cocktail.convert())
        } label: {
            HStack{
                VStack{
                    if let data = cocktail.photo, let uiImage = UIImage(data: data)
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
    }
}

struct MyCocktailView_Previews: PreviewProvider {
    static var previews: some View {
        MyCocktailView(cocktail: CustomCocktail())
    }
}
