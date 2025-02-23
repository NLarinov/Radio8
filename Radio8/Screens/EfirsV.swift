//
//  EfirsV.swift
//  Radio8
//  Created by brfsu on 24.04.2024.
//
import SwiftUI

struct EfirsV: View
{
    @ObservedObject var fetcher = RadioFetcher()
    @StateObject var radioPlayer = RadioPlayer.instance
    
    @State private var selectedEfir: EfirM?
    /// @State private var showSchedule = false
    
    var body: some View {
        VStack {
            if fetcher.isLoading {
                ProgressView()
            } else {
                VStack{
                    List(fetcher.efirs) { efir in
                        ZStack(alignment: .topTrailing) {
                            EfirV(efir: efir)
                                .listRowSeparator(.hidden)
                                .cornerRadius(10)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
//                                        .stroke(efir.randomColor, lineWidth: 3)
                                )
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
                                if radioPlayer.efir == efir {
                                    if radioPlayer.isPlaying {
                                        radioPlayer.stop()
                                    } else {
                                        radioPlayer.play(efir)
                                    }
                                } else {
                                    radioPlayer.initPlayer(url: efir.streamUrl)
                                    radioPlayer.play(efir)
                                    selectedEfir = efir
                                }
                            }) {
                                Image(systemName: radioPlayer.efir == efir && radioPlayer.isPlaying ? "pause.fill" : "play.fill")
                                    .padding()
                                    .background(Color.white.opacity(0.7))
                                    .clipShape(Circle())
                                    .shadow(radius: 3)
                            }
                            .padding(10)
                        }
                    }
                }
            }
            
            if let selectedEfir = selectedEfir {
                MiniPlayerView(efir: selectedEfir, radioPlayer: radioPlayer)
                    .transition(.move(edge: .bottom))
                    .animation(.easeInOut, value: selectedEfir)
            }
        }
    }
}

struct MiniPlayerView: View {
    var efir: EfirM
    @ObservedObject var radioPlayer: RadioPlayer
    
    var body: some View {
        HStack {
            AsyncImage(url: efir.imageUrl) { image in
                image.resizable()
            } placeholder: {
                Color.gray
            }
            .frame(width: 50, height: 50)
            .cornerRadius(5)
            .shadow(radius: 2)
            
            Text(efir.name)
                .font(.headline)
                .lineLimit(1)
                .padding(.leading, 5)
            
            Spacer()
            
            Button(action: {
                if radioPlayer.isPlaying {
                    radioPlayer.stop()
                } else {
                    radioPlayer.play(efir)
                }
            }) {
                Image(systemName: radioPlayer.isPlaying ? "pause.fill" : "play.fill")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .clipShape(Circle())
            }
        }
        .padding()
        .background(Color.gray.opacity(0.2))
        .cornerRadius(10)
        .padding([.horizontal, .bottom])
    }
}
