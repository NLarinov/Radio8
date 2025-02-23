//
//  FavManager.swift
//  Radio8
//
//  Created by Николай Ткачев on 23/02/2025.
//

import SwiftUI
import Foundation

class FavoritesManager: ObservableObject {
    @Published var favoriteStations: [EfirM] = []
    
    private let favoritesKey = "favoriteStations"
    
    init() {
        loadFavorites()
    }
    
    func isFavorite(_ station: EfirM) -> Bool {
        return favoriteStations.contains(where: { $0.id == station.id })
    }
    
    func addToFavorites(_ station: EfirM) {
        if !isFavorite(station) {
            favoriteStations.append(station)
            saveFavorites()
        }
    }
    
    func removeFromFavorites(_ station: EfirM) {
        favoriteStations.removeAll { $0.id == station.id }
        saveFavorites()
    }
    
    private func saveFavorites() {
        if let encoded = try? JSONEncoder().encode(favoriteStations) {
            UserDefaults.standard.set(encoded, forKey: favoritesKey)
        }
    }
    
    private func loadFavorites() {
        if let data = UserDefaults.standard.data(forKey: favoritesKey),
           let decoded = try? JSONDecoder().decode([EfirM].self, from: data) {
            favoriteStations = decoded
        }
    }
}
