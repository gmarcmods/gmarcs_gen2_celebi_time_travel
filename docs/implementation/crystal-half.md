# Phase 2 — Crystal event mechanics

Development 0.0.2, 2026-10-17. This is a playable mechanical sequence, not a
finished cinematic recreation or a release of the complete combined event.

## Implemented behavior

1. After the first native Hall of Fame entry, leaving Goldenrod Pokémon
   Center starts the receptionist delivery. She approaches, gives the real
   key item and retreats. The exit remains blocked only during this scene.
   A full key-item pocket leaves delivery uncommitted and permits exit;
   returning on a later visit allows another attempt.
2. Talking to a native Kurt object with the ball uses the original hand-over
   dialogue and removes it through the native bag helper. Progress saves
   the inspection weekday and local calendar date. Same-day talks show the
   inspection dialogue; a later native weekday or calendar date allows the
   shook-ball dialogue and arms the street callback. Calendar date also
   handles returning after a full week with the same weekday.
3. At Azalea (9,6), outside Kurt returns the ball and directs the player to
   Ilex. A runtime Kurt is spawned when required; an already-visible native
   outside Kurt is reused. Failed item return leaves the hand-back pending.
4. Reading the shrine (8,22) from below opens the native Yes/No prompt.
   No leaves the item and state unchanged. Yes consumes the ball and starts
   the native level-30 Celebi battle with battle type 11, which prevents Run.
   A healthy party member is required before the player can commit the ball.
5. The normal native catch handles animation, Pokédex, party/PC storage and
   nickname choice. Only the catch for this scene's actual battle and game
   promotes the saved state. Congratulations dialogue runs after the native
   battle returns; the later HGSS sequence is not started yet.
6. Failed/interrupted encounters keep `encounter` progress. The shrine offers
   a retry without consuming another ball. Once caught, shrine reads cannot
   repeat the encounter. Full combined-event completion remains separate.

## Integration and persistence

- `Progress.lua`: versioned semantic quest data in `mod.save.quest`:
  `none → delivered → inspecting → street → restless → encounter → caught`.
  Item transactions succeed before their state transitions commit.
- `Item.lua`: Gold/Silver receive a GS Ball record without a numeric index;
  their original index-115 TERU-SAMA record remains intact. Crystal's native
  GS Ball record is not replaced, preserving active item translations.
- `CrystalText.lua`: original English scene dialogue in the text registry,
  plus explicitly authored retry/healthy-party/full-pack utility text. Native
  boxes own wrapping, paging, player-name substitution and Yes/No styling.
  New event text is not translated yet; coexistence with GEN2_ES is tested.
- `Quest.lua`: public hooks/events and native-VM coroutine requests. The
  `warp.destination` hook vetoes every repeated carpet check while delivery
  runs, not only the first check. Native shrine/Kurt script keys are resolved
  from each edition's map records instead of hardcoded ROM addresses.
  CONTINUE/NEW GAME callbacks retire abandoned runtime actors, catch tokens
  and scene guards while leaving the selected slot's quest data intact.
- `engine_internals` is used for the shared native `src.inventory.Bag` helper,
  so key-item capacity, bag order and stack bookkeeping remain engine-owned.
  No engine methods are patched, original event flags are not repurposed,
  and the authored voxel project is untouched.

## Verification

Headless tests (workspace root): `tests/progress.lua`, `tests/item.lua` and
`tests/quest.lua`, in addition to the earlier room/action checks. They cover
item failures, next-day/week handling, saved-state reconstruction, repeated
carpet veto, full-bag recovery, actor cleanup, catch identity checks and
retirement of an interrupted scene on save loading.

`tests/crystal_half.lua` runs on disposable imported identities and never
writes a game save. Live results:

| Edition | Checked |
| --- | --- |
| Silver | Original item preservation, HoF gate, real key-item delivery/native pack display, inspection save round-trip, Kurt hand-over/same-day/next-day states, street callback, shrine No/Yes, native Celebi 30/no-run, party capture/nickname and post-catch repeat prevention |
| Crystal | Same flow with its native GS Ball record; native save encode/decode/normalize/rebind during inspection; full-party capture stored in the real current PC box |
| Gold | Same flow with GEN2_ES enabled; inspection save round-trip; actual voxel Celebi battle and party capture |

Captured delivery, workshop, street, shrine prompt and battle images were
inspected. They are under ignored `dist/quest-<edition>/`. These checks are
desktop tests, not physical Android tests. They do not establish cinematic
interruption safety or all previously active native-event migration cases.

## Required remaining work

- Kurt surprise/emote, physical run-out and correct temporary visibility in
  the house; the current mechanical callback changes progress and dialogue
  but Kurt still stands in the house. Do not hide him by permanently changing
  vanilla event flags.
- Celebi field sprite, shrine float-in and follower attachment. There is
  currently a direct transition from placement dialogue to native battle.
- Physical forest Kurt approach/congratulations/departure. The dialogue works;
  its watcher actor and movement are not implemented yet.
- Sound/music cues, full cinematic checkpoint/reload cleanup and live KO/loss
  retry checks. Mechanic state tests are not a substitute for those scenes.
- Migration/conflict checks for an already-active original Crystal GS Ball
  event, and localization of the new quest text.
- The complete HGSS continuation, including counterpart partner, Route 22,
  the three-years-forward jump, Giovanni/radio battle and return sequence.
