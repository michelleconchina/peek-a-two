//
//  GameState.swift
//  Grid Explorer
//
//  Created by Michelle Conchina on 5/22/26.
//

import Foundation

struct GameState: Codable {

    var totalXP: Int = 0

    // Number of unlocked levels starting from the beginning
    // 1 = Rookie only
    var unlockedLevels: Int = 1
}
