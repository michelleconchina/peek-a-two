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

    private var timerColor: Color {

        switch viewModel.timeLeft {

        case 0...9:
            return .red

        case 10...20:
            return .orange

        default:
            return .green
        }
    }

    var body: some View {

        NavigationStack {

            VStack(spacing: 16) {

                headerSection

                levelPickerSection

                gameInfoSection

                if viewModel.currentLevel.timeLimit != nil {

                    timerSection
                }

                GeometryReader { geometry in

                    let columnsCount = Double(viewModel.currentLevel.columns)
                    let totalCards = Double(viewModel.cards.count)
                    let rowCount = ceil(totalCards / columnsCount)

                    let totalRowSpacing = (rowCount - 1) * 12

                    let calculatedHeight =
                    (geometry.size.height - totalRowSpacing) / rowCount

                    let perfectRowHeight = max(calculatedHeight, 40)

                    LazyVGrid(columns: columns, spacing: 12) {

                        ForEach(viewModel.cards) { card in

                            CardView(card: card)
                                .frame(height: perfectRowHeight)
                                .onTapGesture {

                                    withAnimation(
                                        .easeInOut(duration: 0.25)
                                    ) {
                                        viewModel.tap(card)
                                    }
                                }
                        }
                    }
                }

                if viewModel.isGameComplete {

                    Label(
                        "Level Complete!",
                        systemImage: "star.fill"
                    )
                    .font(.headline)
                    .foregroundStyle(.yellow)
                    .padding(.bottom, 8)
                }

                if viewModel.isGameOver {

                    Label(
                        "Time's Up!",
                        systemImage: "clock.badge.xmark"
                    )
                    .font(.headline)
                    .foregroundStyle(.red)
                    .padding(.bottom, 8)
                }
            }
            .padding(.horizontal)
            .padding(.bottom, 12)
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

                Text("XP: \(viewModel.gameState.totalXP)")
                    .font(.caption)
                    .foregroundStyle(.orange)

                Text(viewModel.currentLevel.name)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundStyle(.tint)
            }

            Spacer()

            Button {

                withAnimation(
                    .spring(response: 0.4, dampingFraction: 0.7)
                ) {
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

                    withAnimation(
                        .spring(response: 0.4, dampingFraction: 0.8)
                    ) {
                        viewModel.selectLevel(level)
                    }

                } label: {

                    if viewModel.isLevelUnlocked(level) {

                        if level.id == viewModel.currentLevel.id {

                            Label(level.name, systemImage: "checkmark")

                        } else {

                            Text(level.name)
                        }

                    } else {

                        Label(level.name, systemImage: "lock.fill")
                    }
                }
                .disabled(!viewModel.isLevelUnlocked(level))
            }

        } label: {

            HStack {

                Image(systemName: "flag.fill")
                    .foregroundStyle(.tint)

                Text("Level: \(viewModel.currentLevel.name)")
                    .font(.body)
                    .fontWeight(.medium)

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

            Spacer()

            Label(
                "\(viewModel.gameState.unlockedLevels)/\(Level.all.count)",
                systemImage: "lock.open.fill"
            )
        }
        .font(.caption)
        .fontWeight(.medium)
        .foregroundStyle(.secondary)
        .padding(.horizontal, 8)
    }

    var timerSection: some View {

        HStack {

            Image(systemName: "clock.fill")

            Text("\(viewModel.timeLeft)s")
                .contentTransition(.numericText())
        }
        .font(.headline)
        .fontWeight(.bold)
        .foregroundStyle(timerColor)
        .scaleEffect(viewModel.timeLeft <= 10 ? 1.1 : 1)
        .animation(
            .easeInOut(duration: 0.5)
                .repeatForever(autoreverses: true),
            value: viewModel.timeLeft <= 10
        )
    }
}

#Preview {
    ContentView()
}
