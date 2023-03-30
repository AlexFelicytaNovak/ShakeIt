//
//  ShakeItApp.swift
//  ShakeIt
//
//  Created by Aleksandra Novák on 10/03/2023.
//

import SwiftUI

@main
struct ShakeItApp: App {
    var body: some Scene {
        WindowGroup {
            TabView {
                SearchView()
                    .badge(2)
                    .tabItem {
                        Label("Search", systemImage: "magnifyingglass")
                    }
                FavouritesView()
//                    .badge("!")
                    .tabItem {
                        Label("Favourites", systemImage: "heart.fill"/*"wineglass"*/)
                    }
            }.onAppear {
//                URLCache.shared.memoryCapacity  = 10_000_000
//                URLCache.shared.diskCapacity = 1_000_000_000
            }
        }
    }
}
