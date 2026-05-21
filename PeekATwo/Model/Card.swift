//
//  Card.swift
//  Grid Explorer
//
//  Created by Michelle Conchina on 5/21/26.
//


//Pure data
//  • Example:
//     • Card
//     • later: Level, GameState, PowerUp

import Foundation

struct Card: Identifiable {
    let id = UUID()
    let content: String
    var isFaceUp = false
    var isMatched = false
}
