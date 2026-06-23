# 1·2·3·4

A fast-paced mental math game for iOS. Pick the correct answer out of four — fast. Three modes, three difficulty tiers, and a stats dashboard to track your progress.

---

## Gameplay

Each round shows a simple expression like `8 ÷ 2` or `2 + 27`. Four buttons offer four possible answers — tap the right one before the timer runs out (when there is one).

- **Three game modes**
  - **Practice** — relaxed warm-up, no timer, no losing. Great for kids or a calm start.
  - **Time Attack** — fixed 60 or 90 seconds; score as many correct answers as you can. Mistakes don't end the run.
  - **Survival** — one wrong tap or timeout ends the game, and the per-answer timer shrinks as your streak grows.
- **Three difficulty tiers** — Easy (add & subtract), Medium (+ division), Hard (+ multiplication). Harder levels give a little more time per answer.
- **Four options, one right** — read the problem, not the button positions; the answers are shuffled every round.
- **Personal best per mode and level** — records are saved locally for each mode/difficulty/duration combination.
- **Statistics dashboard** — total games, best score, best of the week, average, accuracy, total play time, weekly chart and full history.
- **Themes** — System, Light or Dark.
- **Sound & haptics** — audio and tactile feedback on answers, with a confetti celebration on a new record. Both can be toggled in Settings.

## Tech stack

- **SwiftUI** (iOS 17+), **Swift 6**
- **Swift Charts** for the weekly stats chart
- **MVVM** architecture with protocol-based dependency injection

## Design notes

A few decisions worth calling out:

- **Problem generation works "from the answer."** The generator picks a valid result first, then builds operands around it — guaranteeing every problem is solvable, with no negative intermediate values and exact division. Division and multiplication stay within the times-table range.
- **Distractors are deliberate.** The three wrong options mix a near value, a plausible "wrong operation" mistake, and a random value, so the correct answer never simply stands out.
- **The timer is abstracted behind a protocol.** The production implementation uses `Timer.publish`; tests inject a manual ticker that advances time synchronously, so timeout behavior is tested instantly and deterministically.
- **Persistence and feedback are behind protocols.** Scores, settings, sound, and haptics are all injected, so the view models stay testable and the implementations are easy to swap.

## Requirements

- Xcode 16+
- iOS 17.0+
