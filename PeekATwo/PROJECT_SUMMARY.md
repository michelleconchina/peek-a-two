# Grid Explorer

A SwiftUI memory card matching game built using the MVVM architecture pattern.

---

# Overview

Peek A Two is a progressively expanding memory game where players flip cards to find matching pairs. The project begins as a clean and simple matching game, then evolves with levels, timers, combo systems, power-ups, unlockables, and progression mechanics.

The app is designed both as:
- a playable game
- a hands-on SwiftUI learning project

---

# Current Phase

## Phase 1 — Base Game

Implemented:
- Card model
- MVVM structure
- GameViewModel game logic
- Card matching system
- Score tracking
- Animated card flipping
- Responsive card grid
- New Game reset button

---

# Architecture

The project follows the MVVM (Model-View-ViewModel) pattern.

## Folder Structure

```text
Grid Explorer/
│
├── App/
│   └── Grid_ExplorerApp.swift
│
├── Models/
│   └── Card.swift
│
├── ViewModels/
│   └── GameViewModel.swift
│
├── Views/
│   ├── ContentView.swift
│   └── CardView.swift
│
├── Resources/
│   └── Assets.xcassets
│
└── Utilities/
