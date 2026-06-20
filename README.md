# 1·2·3·4

A fast-paced mental math game for iOS. Pick the correct answer out of four options as fast as you can — race the timer, build your streak, and beat your personal best.

---

## Gameplay

Each round shows a simple expression like `8 ÷ 2` or `2 + 27`. Four buttons offer four possible answers — tap the right one before the timer runs out. Every correct answer extends your streak; one mistake — or one timeout — ends the run. The timer shrinks as your streak grows, so the longer you survive, the faster you have to think.

- **Four options, one right** — read the problem, not the button positions; the answers are shuffled every round.
- **Difficulty levels** — Easy (add & subtract), Medium (+ division), Hard (+ multiplication). Harder levels give a little more time per answer.
- **Streak-based scoring** — chase consecutive correct answers.
- **Personal best per level** — your record is saved locally for each difficulty.
- **Escalating pressure** — the per-answer time limit decreases as your streak climbs.
- **Sound & haptics** — audio and tactile feedback on answers, with a confetti celebration on a new record. Both can be toggled in Settings.

## Tech stack

- **SwiftUI** (iOS 16+)
- **MVVM** architecture with protocol-based dependency injection

## Design notes

A few decisions worth calling out:

- **Problem generation works "from the answer."** The generator picks a valid result first, then builds operands around it — guaranteeing every problem is solvable, with no negative intermediate values and exact division. Division and multiplication stay within the times-table range.
- **Distractors are deliberate.** The three wrong options mix a near value, a plausible "wrong operation" mistake, and a random value, so the correct answer never simply stands out.
- **The timer is abstracted behind a protocol.** The production implementation uses `Timer.publish`; tests inject a manual ticker that advances time synchronously, so timeout behavior is tested instantly and deterministically.
- **Persistence and feedback are behind protocols.** Scores, settings, sound, and haptics are all injected, so the view models stay testable and the implementations are easy to swap.

## Requirements

- Xcode 15+
- iOS 16.0+
