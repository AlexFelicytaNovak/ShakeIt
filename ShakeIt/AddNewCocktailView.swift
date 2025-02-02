//
//  AddNewCocktailView.swift
//  ShakeIt
//
//  Created by Aleksandra Novák on 07/05/2023.
//

import SwiftUI

struct AddNewCocktailView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.managedObjectContext) var viewContext
    
    @StateObject private var viewModel = AddNewCocktailViewModel()
    
    private var image: Image {
        if !viewModel.imageData.isEmpty, let uiImage = UIImage(data: viewModel.imageData) {
            return Image(uiImage: uiImage).resizable()
        } else {
            return Image(systemName:"wineglass")
        }
    }
    @State private var isLibrarySelectorShown = false
    @State private var isCameraSelectorShown = false
    
    @State var alcoholSearchText = ""
    @State var nonAlcoholSearchText = ""
    @State var isIngredientClicked = false
    @State var clickedIngredient = FullIngredient(strAlcohol: "", strDescription: "", strIngredient: "")
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Image")) {
                    VStack{
                        HStack{
                            Spacer()
                            image
                                .font(.system(size: 100, weight: .thin))
                                .aspectRatio(contentMode: .fill)
                                .foregroundColor(Colors.Color1)
                                .frame(width: 150, height: 150)
                                .background(Colors.Color2)
                                .clipShape(Circle())
                                .clipped()
                            
                            
                            Spacer()
                        }
                        Spacer()
                        Menu {
                            Button {
                                isLibrarySelectorShown = true
                            } label: {
                                Label("Upload photo", systemImage: "photo.on.rectangle.angled")
                            }
                            if UIImagePickerController.isCameraDeviceAvailable(.rear) {
                                Button {
                                    isCameraSelectorShown = true
                                } label: {
                                    Label("Take photo", systemImage: "camera")
                                }
                            }
                            Button(role: .destructive) {
                                viewModel.imageData = Data()
                            } label: {
                                Label("Remove photo", systemImage: "trash")
                            }

                            
                        } label: {
                            Label("Image", systemImage: "photo")
                        }.buttonStyle(.bordered)
                        
                    }.padding()
                    
                }
                Section(header: Text("Description")) {
                    TextField("Name", text: $viewModel.name,  axis: .vertical).lineLimit(1...3).padding(.vertical, 3)
                    
                    TextField("Recipe", text: $viewModel.instruction,  axis: .vertical)
                        .lineLimit(5...10).padding(.vertical, 3)
                    Toggle("Contains Alcohol", isOn: $viewModel.isAlcoholic.animation()).padding(.vertical, 3)
                }
                
                if viewModel.isAlcoholic != false {
                    Section(header: Text("Alcohols")) {
                        TextField("Search", text: $alcoholSearchText)
                        VStack {
                            ScrollViewReader { reader in
                                ScrollView(.horizontal) {
                                    LazyHGrid(rows: [GridItem(.flexible())]) {
                                        ForEach(viewModel.alcoholsIngredients, id: \.strIngredient) { ingredient in
                                            IngredientView(ingredient: CocktailIngredient(name: ingredient.strIngredient, quantity: "")).id(ingredient.strIngredient)
                                                .onTapGesture {
                                                    clickedIngredient = ingredient
                                                    isIngredientClicked = true
                                                }
                                        }
                                    }
                                }.onChange(of: alcoholSearchText) { newValue in
                                    if let name = viewModel.alcoholsIngredients.first(where: { $0.strIngredient.hasPrefix(newValue) })?.strIngredient {
                                        reader.scrollTo(name)
                                    }
                                }
                            }
                        }.padding(.vertical)
                            .padding(.horizontal, 0)
                    }
                }
                
                Section(header: Text("Other Ingredients")) {
                    TextField("Search", text: $nonAlcoholSearchText)
                    VStack {
                        ScrollViewReader { reader in
                            ScrollView(.horizontal) {
                                LazyHGrid(rows: [GridItem(.flexible())]) {
                                    ForEach(viewModel.nonAlcoholsIngredients, id: \.strIngredient) { ingredient in
                                        IngredientView(ingredient: CocktailIngredient(name: ingredient.strIngredient, quantity: "")).id(ingredient.strIngredient)
                                            .onTapGesture {
                                                clickedIngredient = ingredient
                                                isIngredientClicked = true
                                            }
                                    }
                                }
                            }.onChange(of: nonAlcoholSearchText) { newValue in
                                if let name = viewModel.nonAlcoholsIngredients.first(where: { $0.strIngredient.hasPrefix(newValue) })?.strIngredient {
                                    reader.scrollTo(name)
                                }
                            }
                        }
                    }.padding(.vertical)
                        .padding(.horizontal, 0)
                }
                if !viewModel.ingredients.isEmpty {
                    Section(header: Text("Selected ingredients")) {
                        ForEach(viewModel.ingredients, id: \.name) {
                            ingredient in
                            IngredientView(ingredient: ingredient)
                        }.onDelete { indexes in
                            //guard let indexes = indexes else {return}
                            viewModel.ingredients.remove(atOffsets: indexes)
                        }
                    }
                }

            }.toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save"){
                        do {
                            try viewModel.saveCocktail(viewContext: viewContext)
                            dismiss()
                        } catch {
                            
                        }
                    }.disabled(viewModel.name.isEmpty || viewModel.instruction.isEmpty || viewModel.ingredients.isEmpty)
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel"){
                        dismiss()
                    }
                }
            }.sheet(isPresented: $isCameraSelectorShown) {
                ImageSelector(imageSource: .camera, selectedImageData: $viewModel.imageData)
            }
            .sheet(isPresented: $isLibrarySelectorShown) {
                ImageSelector(imageSource: .photoLibrary, selectedImageData: $viewModel.imageData)
            }
            .sheet(isPresented: $isIngredientClicked) {
                SelectedIngredientView(viewModel: viewModel, ingredient: clickedIngredient)
            }.task {
                try? await viewModel.loadData()
            }
        }
    }
}

struct AddNewCocktailView_Previews: PreviewProvider {
    static var previews: some View {
        AddNewCocktailView()
    }
}
