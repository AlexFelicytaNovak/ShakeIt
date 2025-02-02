//
//  CocktailDescription.swift
//  ShakeIt
//
//  Created by Aleksandra Novák on 26/03/2023.
//

import SwiftUI

struct CocktailDescription: View {
    @Environment(\.managedObjectContext) var viewContext
    @StateObject var viewModel: CocktailDescriptionViewModel
    
    let cocktailRecipe: Recipe
        
    var body: some View {
        GeometryReader { geometry in
            ZStack{
                Colors.Color1.ignoresSafeArea()
                ScrollView{
                    VStack{
                        ZStack{
                            viewModel.image
                                .aspectRatio(contentMode: .fill)
                                .font(.system(size: 230, weight: .thin))
                                .foregroundColor(Colors.Color2)
                                .frame(width: geometry.size.width > 80 ? geometry.size.width-80 : geometry.size.width, height: geometry.size.width > 80 ? geometry.size.width-80 : geometry.size.width)
                                .clipped()
                                .clipShape(Circle())
                                .overlay {Circle().stroke(Colors.Color2, lineWidth: 7)}
                                .shadow(radius: 10)
                            
                            Image(systemName: viewModel.isHeartShown ? "heart.fill" : "heart.fill" )
                                .opacity(viewModel.isHeartShown ? 1 : 0)
                                .font(.system(size: 150))
                                .foregroundColor(Colors.Color2)
                                .scaleEffect(viewModel.isFavourite ? 1.30 : 1)
                                .animation(.interpolatingSpring(stiffness: 300, damping: 10), value: viewModel.isFavourite)
                            
                        }
                        
                        HStack{
                            Text(cocktailRecipe.name).font(.largeTitle).bold().foregroundColor(Colors.Color2)
                            Spacer()
                        }.padding(.vertical)
                        
                        GroupBox {
                            HStack{
                                Text(cocktailRecipe.instruction).lineLimit(nil).foregroundColor(Colors.Color1)
                                Spacer()
                            }.padding(.horizontal)
                                .padding(.top, 5)
                        } label: {
                            Label("Recipe", systemImage: "wineglass").font(.title3).bold().foregroundColor(Colors.Color1)
                        }.groupBoxStyle(ColoredGroupBox())
                        
                        HStack{
                            Text("Ingredients").font(.title3).bold()
                            Spacer()
                        }.padding(.vertical).foregroundColor(Colors.Color2)
                        
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())])
                        {
                            ForEach(cocktailRecipe.ingredients, id: \.name) { ingredient in
                                NavigationLink {
                                    IngredientDescriptionView(ingredient: ingredient)
                                } label: {
                                    IngredientView(ingredient: ingredient)
                                }
                            }
                        }
                        Spacer(minLength: 20)
                    }
                    .padding(.horizontal)
                }
            }
        }.toolbar {
            ToolbarItem {
                Image(systemName: viewModel.isFavourite ? "heart.fill" : "heart")
                    .foregroundColor(viewModel.isFavourite ? .pink : .accentColor)
                    .scaleEffect(viewModel.isFavourite ? 1.30 : 1)
                    .animation(.interpolatingSpring(stiffness: 300, damping: 10), value: viewModel.isFavourite)
                    .onTapGesture {
                        viewModel.isFavourite.toggle()
                        if viewModel.isFavourite {
                            viewModel.addToFavourite()
                        } else {
                            viewModel.removeFromFavourite()
                        }
                    }
            }
            ToolbarItem{
                ShareLink(item: cocktailRecipe, preview: UIImage(data: cocktailRecipe.photo).map({ image in
                    SharePreview(cocktailRecipe.name, icon: Image(uiImage: image ))
                }) ?? SharePreview(cocktailRecipe.name, icon: Image(systemName: "wineglass")))
            }
        }
    }
    
    init(cocktailRecipe: Recipe) {
        self.cocktailRecipe = cocktailRecipe
        self._viewModel = StateObject(wrappedValue: CocktailDescriptionViewModel(cocktailRecipe: cocktailRecipe))
    }
}

struct CocktailDescription_Previews: PreviewProvider {
    static var previews: some View {
        CocktailDescription(cocktailRecipe: Recipe(id: "1", name: "Cocktail", photo: Data(), instruction: "recipe", glass: "cup", ingredients: [CocktailIngredient(name: "Gin", quantity: "1/2 part"), CocktailIngredient(name: "Vodka", quantity: "1/2 part")], isAlcoholic: true))
    }
}
