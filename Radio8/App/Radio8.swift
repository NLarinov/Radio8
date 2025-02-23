//
//  Radio8.swift
//  Radio8
//  Created by brfsu on 24.04.2024.
//
import SwiftUI

@main
struct Radio8: App 
{
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}


struct ContentView: View {
    @StateObject private var fetcher = RadioFetcher()
    @StateObject private var radioPlayer = RadioPlayer.instance
    @StateObject private var favoritesManager = FavoritesManager()
    
    var body: some View {
        TabView {
            EfirsListView(fetcher: fetcher, radioPlayer: radioPlayer, favoritesManager: favoritesManager)
                .tabItem { Label("Все", systemImage: "radio") }
            
            EfirsListView(fetcher: fetcher, radioPlayer: radioPlayer, favoritesManager: favoritesManager, isFavoritesOnly: true)
                .tabItem { Label("Избранное", systemImage: "star.fill") }
        }
        .onAppear { fetcher.load() }
    }
}
