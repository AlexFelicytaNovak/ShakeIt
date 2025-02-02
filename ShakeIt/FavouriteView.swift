//
//  FavouriteView.swift
//  ShakeIt
//
//  Created by Aleksandra Novák on 08/05/2023.
//

import SwiftUI

struct FavouriteView: View {
    let favouriteCocktail: Favourite
    @StateObject var viewModel: FavouriteViewModel
    @Environment(\.managedObjectContext) var viewContext
    var body: some View {
        NavigationLink {
            CocktailDescription(cocktailRecipe: viewModel.recipe)
        } label: {
            HStack{
                VStack{
                    if let uiImage = UIImage(data: viewModel.recipe.photo)
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
                
                Text(favouriteCocktail.name ?? "")
                    .foregroundColor(Colors.Color1)
            }
        }
        .foregroundColor(Colors.Color1)
        .task {
            try? await viewModel.loadRecipe(viewContext: viewContext)
        }
    }
    
    init(favouriteCocktail: Favourite) {
        self.favouriteCocktail = favouriteCocktail
        self._viewModel = StateObject(wrappedValue: FavouriteViewModel(favourite: favouriteCocktail))
    }
}

struct FavouriteView_Previews: PreviewProvider {
    static var previews: some View {
        FavouriteView(favouriteCocktail: Favourite())
    }
}
