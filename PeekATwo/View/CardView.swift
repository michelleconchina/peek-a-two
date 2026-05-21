
//
//  ContentView.swift
//  Grid Explorer
//
//  Created by Michelle Conchina on 5/21/26.
//
//• View
//   • UI only
//   • Reads state from ViewModel
//   • Sends user actions back


import SwiftUI

struct CardView: View {

    let card: Card

    var body: some View {

        ZStack {

            RoundedRectangle(cornerRadius: 12)
                .fill(card.isFaceUp ? .white : .blue)

            RoundedRectangle(cornerRadius: 12)
                .stroke(.blue, lineWidth: 3)

            if card.isFaceUp || card.isMatched {

                Text(card.content)
                    .font(.largeTitle)
            }
        }
        .opacity(card.isMatched ? 0.5 : 1)
        .rotation3DEffect(
            .degrees(card.isFaceUp ? 0 : 180),
            axis: (x: 0, y: 1, z: 0)
        )
        .animation(.easeInOut(duration: 0.4), value: card.isFaceUp)
        .shadow(radius: 4)
    }
}

#Preview {
    VStack(spacing: 20) {

        CardView(
            card: Card(
                content: "🚀",
                isFaceUp: true
            )
        )
        .frame(width: 100, height: 150)

        CardView(
            card: Card(
                content: "🔥",
                isFaceUp: false
            )
        )
        .frame(width: 100, height: 150)
    }
    .padding()
    .background(Color.gray.opacity(0.2))
}
