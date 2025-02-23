//
//  ContentView.swift
//  Radio8
//  Created by brfsu on 24.04.2024.
//
import SwiftUI

struct MainV: View {

    var body: some View {
        TabView {
            NavigationView {
                ZStack {
                    EfirsV()
                }
//                .navigationBarTitle("Эфиры")
//                .navigationBarTitleDisplayMode(.inline)
            } // NavigationView
            .tabItem {
                Image(systemName: "antenna.radiowaves.left.and.right")
                Text("Эфиры")
            }
        } // TabView
    } // body
} // struct
