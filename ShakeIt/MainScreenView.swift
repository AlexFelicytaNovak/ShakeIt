//
//  MainScreenView.swift
//  ShakeIt
//
//  Created by Aleksandra Novák on 07/05/2023.
//

import SwiftUI

struct MainScreenView: View {
    @State private var formPresented = false
    @State private var isClicked = false
    @State private var rotationAngle: Double = 0.0
    @StateObject var viewModel = MainScreenViewModel()
    
    private let rotationDuration: Double = 0.8

    var body: some View {
        NavigationStack {
            ZStack{
                Colors.Color1.ignoresSafeArea()
                ScrollView{
                    GroupBox {
                        if Date() < viewModel.shakeTime{
                            NavigationLink{
                                CocktailDescription(cocktailRecipe: viewModel.recipe)
                            } label: {
                                VStack{
                                    viewModel.image
                                        .aspectRatio(contentMode: .fill)
                                        .font(.system(size: 200, weight: .thin))
                                        .foregroundColor(Colors.Color1)
                                        .frame(width: 280, height: 280)
                                        .clipped()
                                        .clipShape(Circle())
                                        .overlay {Circle().stroke(Colors.Color1, lineWidth: 7)}
                                        .shadow(radius: 10)
                                    Text(viewModel.name).font(.title).padding(.top).bold()
                                }.padding()
                            }
                        }
                        else{
                            VStack{
                                if isClicked{
                                    VStack{
                                        HStack{
                                            Spacer()
                                            Image("ShakerGIF")
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(height: 200)
                                                .rotationEffect(.degrees(rotationAngle))
                                                .animation(.easeInOut(duration: rotationDuration), value: rotationAngle)
                                            Spacer()
                                        }
                                        

                                        Label("Shake me!", systemImage: "party.popper")
                                            .font(.title).bold()
                                    }
                                }
                                else
                                {
                                    VStack{
                                        Image("Shaker").resizable().aspectRatio( contentMode: .fit)
                                        Button(action: {
                                            withAnimation { shakerAnimation() }
                                        }, label: {
                                            Text("Click me!")
                                                .frame(minWidth: 200).padding(3)
                                                .bold()
                                                .font(.title2)
                                        }).buttonStyle(.borderedProminent).accentColor(Colors.Color1).shadow(radius: 5)
                                            .foregroundColor(Colors.Color2)
                                    }
                                }
                                
                            }.deviceShaken {Task{try? await viewModel.shake()}}
                        }
                    }.groupBoxStyle(ColoredGroupBox()).padding(25)
                    
                }
                    
            }.navigationTitle("Time to drink!").foregroundColor(Colors.Color1)
                .toolbar {
                    ToolbarItem {
                        Button{
                            formPresented = true
                        } label: {
                            Label("Add new recipe", systemImage: "plus.circle")
                        }
                    }
                }
                .sheet(isPresented: $formPresented) {
                    AddNewCocktailView()
                }
            
        }
            
    }
    
    func shakerAnimation() {
        guard !isClicked else { return }  // Prevent re-triggering during the animation
        isClicked = true
        
        Task {
            while true {
                withAnimation {
                    rotationAngle = -40
                }
                try await Task.sleep(for: .seconds(rotationDuration))
                withAnimation {
                    rotationAngle = 40
                }
                try await Task.sleep(for: .seconds(rotationDuration))
            }
        }
    }
}

struct MainScreenView_Previews: PreviewProvider {
    static var previews: some View {
        MainScreenView()
    }
}
