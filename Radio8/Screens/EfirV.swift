//
//  EfirV.swift
//  Radio8
//  Created by brfsu on 24.04.2024.
//
import SwiftUI

struct EfirV: View
{
    let efir: EfirM
    
    var body: some View {
        VStack {
            ZStack {
                AsyncImage(url: efir.imageUrl) //, placeholder: { Text("...") } ) //, image: { Image(uiImage: $0).resizable() } )
                    .scaledToFit()
                    .frame(width: UIScreen.main.bounds.size.width - 40, height: UIScreen.main.bounds.size.width - 40)
                    .cornerRadius(10)
                    .shadow(radius: 5)
                
                VStack {
                    Text(efir.name)
                        .font(.title)
                        .bold()
                        .padding(5)
                        .cornerRadius(10)
                        .lineLimit(2)
                }
                .padding(15)
                .foregroundColor(.green)
            } // ZStack
        } // VStack
    }
}
