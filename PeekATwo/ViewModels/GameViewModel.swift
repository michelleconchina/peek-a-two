//
//  GameViewModel.swift
//  Grid Explorer
//
//  Created by Michelle Conchina on 5/21/26.
//

//• ViewModel
//   • Game logic + app state
//   • Handles:
//      • card matching
//      • score
//      • shuffling
//      • delays
//      • timers
//   • Example:
//      • GameViewModel

import Foundation
import SwiftUI
import Combine

final class GameViewModel: ObservableObject {

    @Published var cards: [Card] = []
    @Published var score = 0
    @Published var currentLevel = Level.rookie
    @Published var gameState = GameState()

    private var firstSelectedCardIndex: Int?
    private var isProcessing = false

    private let saveKey = "game_state"

    private let emojis = [
        "🍎", "🚀", "🐶", "🎮",
        "🌈", "🔥", "⚽️", "🎵",
        "🍕", "👑", "🎲", "🪐"
    ]

    var isGameComplete: Bool {
        cards.allSatisfy(\.isMatched)
    }

    init() {
        loadGameState()
        newGame()
    }

    func newGame() {

        score = 0
        firstSelectedCardIndex = nil
        isProcessing = false

        var newCards: [Card] = []

        let selectedEmojis = Array(
            emojis.prefix(currentLevel.pairs)
        )

        for emoji in selectedEmojis {

            let cardPair = [
                Card(content: emoji),
                Card(content: emoji)
            ]

            newCards.append(contentsOf: cardPair)
        }

        cards = newCards.shuffled()
    }

    func selectLevel(_ level: Level) {

        guard isLevelUnlocked(level) else {
            return
        }

        currentLevel = level
        newGame()
    }

    func isLevelUnlocked(_ level: Level) -> Bool {

        guard let index = Level.all.firstIndex(where: {
            $0.id == level.id
        }) else {
            return false
        }

        return index < gameState.unlockedLevels
    }

    func tap(_ card: Card) {

        guard let tappedIndex = cards.firstIndex(where: { $0.id == card.id }) else {
            return
        }

        guard !cards[tappedIndex].isFaceUp else {
            return
        }

        guard !cards[tappedIndex].isMatched else {
            return
        }

        guard !isProcessing else {
            return
        }

        cards[tappedIndex].isFaceUp = true

        if let firstIndex = firstSelectedCardIndex {

            if cards[firstIndex].content == cards[tappedIndex].content {

                cards[firstIndex].isMatched = true
                cards[tappedIndex].isMatched = true

                score += 10
                gameState.totalXP += 10

                firstSelectedCardIndex = nil

                if isGameComplete {

                    completeLevel()
                }

            } else {

                isProcessing = true

                DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {

                    self.cards[firstIndex].isFaceUp = false
                    self.cards[tappedIndex].isFaceUp = false

                    self.firstSelectedCardIndex = nil
                    self.isProcessing = false
                }
            }

        } else {

            firstSelectedCardIndex = tappedIndex
        }
    }

    private func completeLevel() {

        gameState.totalXP += 50

        if let currentIndex = Level.all.firstIndex(where: {
            $0.id == currentLevel.id
        }) {

            let nextUnlock = currentIndex + 2

            if nextUnlock > gameState.unlockedLevels {

                gameState.unlockedLevels = min(
                    nextUnlock,
                    Level.all.count
                )
            }
        }

        saveGameState()
    }

    private func saveGameState() {

        do {

            let data = try JSONEncoder().encode(gameState)

            UserDefaults.standard.set(data, forKey: saveKey)

        } catch {

            print("Failed to save game state:", error)
        }
    }

    private func loadGameState() {

        guard let data = UserDefaults.standard.data(forKey: saveKey) else {
            return
        }

        do {

            gameState = try JSONDecoder().decode(
                GameState.self,
                from: data
            )

        } catch {

            print("Failed to load game state:", error)
        }
    }
}
