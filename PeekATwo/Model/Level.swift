//
//  Level.swift
//  Grid Explorer
//
//  Created by Michelle Conchina on 5/21/26.
//

import Foundation

struct Level: Identifiable {

    let id = UUID()

    let name: String
    let pairs: Int
    let columns: Int
    let timeLimit: Int?

    var cardCount: Int {
        pairs * 2
    }
}

extension Level {

    static let rookie = Level(
        name: "Rookie",
        pairs: 4,
        columns: 2,
        timeLimit: nil
    )

    static let scout = Level(
        name: "Scout",
        pairs: 6,
        columns: 3,
        timeLimit: 60
    )

    static let hunter = Level(
        name: "Hunter",
        pairs: 8,
        columns: 4,
        timeLimit: 45
    )

    static let master = Level(
        name: "Master",
        pairs: 12,
        columns: 4,
        timeLimit: 30
    )

    static let all: [Level] = [
        .rookie,
        .scout,
        .hunter,
        .master
    ]
}

