# 1·2·3·4

A fast-paced mental math game for iOS. Solve quick addition and subtraction problems where the answer is always **1, 2, 3, or 4** — race the timer, build your streak, and beat your personal best.

---

## Gameplay

Each round shows a simple expression like `7 − 4` or `3 + 1`. Tap the correct answer from four buttons before the timer runs out. Every correct answer extends your streak; one mistake — or one timeout — ends the run. The timer shrinks as your streak grows, so the longer you survive, the faster you have to think.

- **Answers are always 1–4** — easy to learn, hard to keep up with at speed.
- **Streak-based scoring** — chase consecutive correct answers.
- **Personal best** — your record is saved locally between sessions.
- **Escalating difficulty** — the per-answer time limit decreases as your streak climbs.
- **Tactile feedback** — haptics on correct/incorrect answers and a confetti celebration on a new record.

## Screenshots
<p align="center">
  <img src="https://github.com/user-attachments/assets/f8d2a3c6-b3b4-43ea-aefd-149015c00707" width="250">
  <img src="https://github.com/user-attachments/assets/0e6a1ea5-acac-4952-bb32-74bb01d9dae4" width="250">
  <img src="https://github.com/user-attachments/assets/d4eb6039-c212-4144-8496-6e188e90a620" width="250">
</p>

## Tech stack

- **SwiftUI** (iOS 16+)
- **MVVM** architecture with protocol-based dependency injection

## Architecture

The project separates game logic from UI so the core can be unit-tested in isolation from SwiftUI.

```
Game1234/
├── App/            App entry, navigation routes, design tokens, app metadata
├── Models/         Problem, Operation, GamePhase
├── ViewModels/     GameViewModel (timer, streak, scoring), MainMenuViewModel
├── Services/       ProblemGenerator, ScoreStorage, GameTicker, HapticFeedback
└── Views/          MainMenu, Game, Result, About + reusable components
```

A few design decisions worth calling out:

- **Problem generation works "from the answer."** Instead of generating random operands and hoping the result lands in 1–4, the generator picks the answer first, then builds valid operands around it. This guarantees every problem is solvable within range, never produces negative intermediate values, and never repeats the previous problem.
- **The timer is abstracted behind a protocol** (`GameTicking`). The production implementation uses `Timer.publish`; tests inject a manual ticker that advances time synchronously, so timeout behavior is tested instantly and deterministically — no waiting on real seconds.
- **Persistence is behind a protocol** (`ScoreStorageProtocol`). The current implementation uses `UserDefaults`; swapping it for SwiftData or a backend wouldn't touch the view models.
- **Services are injected via initializers**, so every piece of game logic is covered by tests using mocks.

## Requirements

- Xcode 15+
- iOS 16.0+
