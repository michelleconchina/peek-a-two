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

    private var firstSelectedCardIndex: Int?
    private var isProcessing = false

    private let emojis = [
        "🍎", "🚀", "🐶", "🎮",
        "🌈", "🔥", "⚽️", "🎵",
        "🍕", "👑", "🎲", "🪐"
    ]

    init() {
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

        currentLevel = level
        newGame()
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

                firstSelectedCardIndex = nil

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
}
