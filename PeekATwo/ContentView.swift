//
//  ContentView.swift
//  Grid Explorer
//
//  Created by Michelle Conchina on 5/21/26.
//

import SwiftUI

struct ContentView: View {

    @StateObject private var viewModel = GameViewModel()

    private var columns: [GridItem] {
        Array(
            repeating: GridItem(.flexible(), spacing: 12),
            count: viewModel.currentLevel.columns
        )
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {

                headerSection

                levelPickerSection

                gameInfoSection

                // GeometryReader calculates the exact remaining layout area on screen
                GeometryReader { geometry in
                    let columnsCount = Double(viewModel.currentLevel.columns)
                    let totalCards = Double(viewModel.cards.count)
                    let rowCount = ceil(totalCards / columnsCount)
                    
                    // Subtract the 12pt gaps between rows from total height
                    let totalRowSpacing = (rowCount - 1) * 12
                    let calculatedHeight = (geometry.size.height - totalRowSpacing) / rowCount
                    
                    // Fallback baseline height to prevent layout collapse
                    let perfectRowHeight = max(calculatedHeight, 40)

                    LazyVGrid(columns: columns, spacing: 12) {
                        ForEach(viewModel.cards) { card in
                            CardView(card: card)
                                .frame(height: perfectRowHeight)
                                .onTapGesture {
                                    withAnimation(.easeInOut(duration: 0.25)) {
                                        viewModel.tap(card)
                                    }
                                }
                        }
                    }
                }
            }
            .padding(.horizontal)
            .padding(.bottom, 12) // Bottom padding protection
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Peek-a-Two")
                        .font(.headline)
                }
            }
        }
    }
}

private extension ContentView {

    var headerSection: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Score")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                Text("\(viewModel.score)")
                    .font(.system(size: 42, weight: .bold, design: .rounded))

                Text(viewModel.currentLevel.name)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundStyle(.tint)
            }

            Spacer()

            Button {
                withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                    viewModel.newGame()
                }
            } label: {
                Label("New Game", systemImage: "arrow.clockwise")
                    .fontWeight(.semibold)
            }
            .buttonStyle(.borderedProminent)
        }
        .padding(.top, 8)
    }

    var levelPickerSection: some View {
        Menu {
            ForEach(Level.all) { level in
                Button {
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                        viewModel.selectLevel(level)
                    }
                } label: {
                    if level.id == viewModel.currentLevel.id {
                        Label(level.name, systemImage: "checkmark")
                    } else {
                        Text(level.name)
                    }
                }
            }
        } label: {
            HStack {
                Image(systemName: "flag.fill")
                    .foregroundStyle(.tint)

                Text("Level: \(viewModel.currentLevel.name)")
                    .font(.body)
                    .fontWeight(.medium)
                    .foregroundStyle(.primary)

                Spacer()

                Text("\(viewModel.currentLevel.cardCount) Cards")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .background(Color(.secondarySystemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 14))
        }
    }

    var gameInfoSection: some View {
        HStack {
            Label(
                "\(viewModel.currentLevel.pairs) Pairs",
                systemImage: "square.grid.2x2"
            )

            Spacer()

            Label(
                "\(viewModel.currentLevel.columns) Columns",
                systemImage: "rectangle.split.3x1"
            )
        }
        .font(.caption)
        .fontWeight(.medium)
        .foregroundStyle(.secondary)
        .padding(.horizontal, 8)
    }
}

#Preview {
    ContentView()
}
