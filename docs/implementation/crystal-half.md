# Phase 2 — Crystal event mechanics

Development 0.0.4, 2026-10-17. This is a playable mechanical sequence, not a
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
   shook-ball dialogue, then Kurt walks around the player to a free house
   exit and arms the street callback. During the outside phases, his live
   actor is placed off-map; definitions, native flags and saved masks stay
   unchanged, so ordinary map loading restores Kurt if the mod is disabled.
   Calendar date also handles returning after a full week with the same weekday.
3. At Azalea (9,6), outside Kurt returns the ball and directs the player to
   Ilex. A runtime Kurt is spawned when required; an already-visible native
   outside Kurt is reused. Failed item return leaves the hand-back pending.
4. Reading the shrine (8,22) from below opens the native Yes/No prompt.
   No leaves the item and state unchanged. Yes consumes the ball and starts
   an authored 160-tick Celebi float-in with continuous wing/hover animation,
   its native cry (waited to completion by the VM), then the native level-30 battle with battle type 11,
   which prevents Run.
   A healthy party member is required before the player can commit the ball.
5. The normal native catch handles animation, Pokédex, party/PC storage and
   nickname choice. Only the catch for this scene's actual battle and game
   promotes the saved state. Kurt enters through the west clearing path,
   approaches the player,
   delivers congratulations, retraces his route and disappears after the
   native battle returns. A saved `kurtCongratulated` checkpoint allows shrine
   reads to resume an interrupted congratulations scene without another battle.
   The later HGSS sequence is not started yet.
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

Headless tests (workspace root): `tests/progress.lua`, `tests/item.lua`,
`tests/quest.lua` and `tests/paths.lua`, in addition to the earlier room/action
checks. They cover
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

- Kurt surprise/emote and exit sound. Workshop run-out and temporary
  visibility are implemented without native flag/mask changes.
- Sound/music cues, full cinematic checkpoint/reload cleanup and live KO/loss
  retry checks. Mechanic state tests are not a substitute for those scenes.
- Migration/conflict checks for an already-active original Crystal GS Ball
  event, and localization of the new quest text.
- The complete HGSS continuation, adapted without a partner: Route 22,
  the three-years-forward jump, Giovanni/radio battle and return sequence.

### Kurt movement checks

`tests/paths.lua` checks both workshop exits with several blocked player
positions against every edition’s actual collision data. It also rejects the
old south-watcher route and validates the west clearing approach. The live
driver checks empty-house persistence across map re-entry, unchanged native
flags/masks, a visible forest watcher, cleanup and Kurt’s return afterward.

The 0.0.3 movement driver passed Gold, Silver and Crystal. Gold used the voxel
view for forest congratulations; Silver/Crystal used the native view. Actual
empty-workshop and forest-congratulations captures were inspected.

### Celebi field animation and follower (0.0.4)

Historical description below: 0.0.7 replaces the bitmap with the supplied
GSC follower sheet and its source colors; animation/follower behavior remains.
See `field-art-and-location.md` for current art and provenance.


`assets/celebi.png` is a hand-authored 16×96 sheet: down/up/left idle and wing
poses, with native right-facing mirroring. Its palette comes from the active
edition's native Celebi Pokémon colors through the public palettes registry.
It does not borrow the human skin-color NPC palette or Ilex's blue tree colors.
The sprite bitmap is authored; only existing palette data and the cry are used.

`CelebiMotion.lua` advances on fixed `input.step` ticks. The 160-tick descent
uses a smooth height curve into a small idle hover; wings alternate every eight
ticks. The native actor pose exposes that height to the voxel renderer as lift.
Only attached instances receive temporary update/pose/palette behavior; detach
restores their original methods, offset and palette. Loading another save
retires attached animations. The appearance actor is removed before battle;
interruptions leave the existing encounter retry checkpoint intact.

`CelebiFollower.lua` supplies one correctly skinned guest NPC through
`world.follower.spawn`, then hands walking to the engine's normal follower loop.
On its creation call it returns false to prevent a second stock constructor;
subsequent calls return true so native trail movement continues. No engine
method, shared sprite slot or map definition is replaced. The native map-entry
path removes the guest and the hook recreates it on the destination map.

Eligibility requires caught progress, completed Kurt congratulations and a
healthy non-egg Celebi in party slot one. A boxed Celebi never silently changes
the party. The exported follower offers temporary suspension for later scenes.
If a peer mod already owns the native follower, Celebi temporarily borrows its
appearance, palette and animation, restoring those when eligibility ends.

Headless checks: `tests/follower.lua` exercises the real native follower loop
with a lightweight actor, including trail targets, map respawn, party changes,
suspension, load cleanup and borrowed appearance restoration. `tests/motion.lua`
checks height, continuous wings, palette protection and exact instance cleanup.
`tests/art.py` checks sheet geometry, directional/wing differences, alpha and
native shade encoding. The live driver checks actual arrival height, wings,
walking/landing, map transitions, suspension and party reorder; Crystal also
withdraws its full-party catch through the native PC storage helper.

The 0.0.4 live driver passed Gold, Silver and Crystal. Captures of the arrival,
forest follower and daylight follower were inspected. Gold used the authored
voxel renderer with GEN2_ES enabled; Silver/Crystal used native rendering.
Crystal verified full-party PC capture, native withdrawal, then following.
These remain desktop results; Android and first-person captures are not claimed.
