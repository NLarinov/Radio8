//
//  EfirsLView.swift
//  Radio8
//
//  Created by Николай Ткачев on 23/02/2025.
//

import SwiftUI

struct EfirsListView: View {
    @ObservedObject var fetcher: RadioFetcher
    @StateObject var radioPlayer: RadioPlayer
    @StateObject var favoritesManager: FavoritesManager
    
    var isFavoritesOnly: Bool = false
    @State private var selectedEfir: EfirM?
    
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        let efirs = isFavoritesOnly ? favoritesManager.favoriteStations : fetcher.efirs
        
        VStack {
            if fetcher.isLoading {
                ProgressView()
            } else {
                List(efirs) { efir in
                    ZStack(alignment: .topTrailing) {
                        EfirV(efir: efir)
                            .listRowSeparator(.hidden)
                            .cornerRadius(10)
                            .padding(10)
                            .onTapGesture {
                                if efir != radioPlayer.efir {
                                    radioPlayer.initPlayer(url: efir.streamUrl)
                                    radioPlayer.play(efir)
                                    selectedEfir = efir
                                } else {
                                    radioPlayer.stop()
                                    selectedEfir = nil
                                }
                            }
                        
                        Button(action: {
                            if favoritesManager.isFavorite(efir) {
                                favoritesManager.removeFromFavorites(efir)
                            } else {
                                favoritesManager.addToFavorites(efir)
                            }
                        }) {
                            Image(systemName: favoritesManager.isFavorite(efir) ? "star.fill" : "star")
                                .padding(8)
                                .background(Color.white.opacity(0.7))
                                .clipShape(Circle())
                                .shadow(radius: 3)
                        }
                        .padding(10)
                    }
                }
                .refreshable {
                    fetcher.load()
                }
            }
            
            if let selectedEfir = selectedEfir {
                MiniPlayerView(efir: selectedEfir, radioPlayer: radioPlayer)
                    .transition(.move(edge: .bottom))
                    .animation(.easeInOut, value: selectedEfir)
            }
        }
        .background(colorScheme == .dark ? Color.black : Color.white)
        .preferredColorScheme(colorScheme)
    }
}
