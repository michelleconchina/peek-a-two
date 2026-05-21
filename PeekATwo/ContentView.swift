//
//  ContentView.swift
//  Grid Explorer
//
//  Created by Michelle Conchina on 5/21/26.
//

import SwiftUI

struct ContentView: View {

    @StateObject private var viewModel = GameViewModel()

    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {

        NavigationStack {

            VStack(spacing: 16) {

                headerSection

                LazyVGrid(columns: columns, spacing: 12) {

                    ForEach(viewModel.cards) { card in

                        CardView(card: card)
                            .aspectRatio(2 / 3, contentMode: .fit)
                            .onTapGesture {

                                withAnimation {
                                    viewModel.tap(card)
                                }
                            }
                    }
                }

                Spacer()
            }
            .padding()
            .navigationTitle("Peek-a-Two")
        }
    }
}

private extension ContentView {

    var headerSection: some View {

        HStack {

            VStack(alignment: .leading, spacing: 4) {

                Text("Score")
                    .font(.headline)

                Text("\(viewModel.score)")
                    .font(.largeTitle.bold())
            }

            Spacer()

            Button {

                withAnimation {
                    viewModel.newGame()
                }

            } label: {

                Label("New Game", systemImage: "arrow.clockwise")
            }
            .buttonStyle(.borderedProminent)
        }
    }
}

#Preview {
    ContentView()
}
