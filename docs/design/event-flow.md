# Design — mixing the two events

This is the plan of the **combined event**, informed by the Phase 0
research (see `reference/` for what is verified and `dialogue/` for the
original scripts). Nothing here is final until the engine spikes settle the
capability questions.

## Confirmed adaptation: no partner

The player travels with Celebi alone. Do not add Lyra, Ethan, a replacement
companion or Marill, and do not move their exposition into another NPC's mouth.
The HGSS transcripts remain source references, not the runtime script.
Use short time/location captions: `THREE YEARS EARLIER... / KANTO - ROUTE 22`,
then `THREE YEARS LATER... / TOHJO FALLS`, and `THE PRESENT... / ILEX FOREST`.
The radio broadcast establishes the takeover; preserve Silver/Giovanni's
argument and Giovanni's battle dialogue, adapting plural references only when
needed for a lone player. No partner greetings, monologues or farewell.

## The combined arc

```
[Crystal flow — verbatim recreation, start like Crystal]
GS Ball delivered (Goldenrod PC doorway scene)  →  hand to Kurt  →  one day
   →  "the ball shook", Kurt runs out  →  street scene ("ILEX FOREST is
   restless!")  →  shrine at (8,22): place the GS Ball  →  Celebi float-in
   →  wild Celebi 30 battle  →  caught
                                   ↓
                         Kurt's congratulations (native beat)
                                   ↓
                         NOT the end: catch (or a later shrine visit,
                         see trigger decision below) fires the HGSS half
                                   ↓
[our continuation — HGSS story adapted to GSC, no partner]
Shrine activation: Celebi circles the player; no companion or legend speech
                                   ↓
                         Time-travel transition (flash/white/swirl, staged)
                                   ↓
Route 22 — THREE YEARS EARLIER caption, the argument (rival +
"man in black"), rival runs you down
                                   ↓
                         Second jump (three years forward from Route 22)
                                   ↓
Tohjo Falls hidden room: radio broadcast, Giovanni reveal, boss battle
(Nidoking 42 / Murkrow 43* / Nidoqueen 46 / Kangaskhan 40)
                                   ↓
                         Return to present Ilex Forest: PRESENT caption, Celebi
                         settles back into following; event closes permanently
```
(*Murkrow replaces HGSS's Honchkrow — Gen 4 species, see below.)

## Design rules

- One mod, all three editions (`games: gen2`). Any edition-specific text or
  script difference must be an edition-aware branch in our content, not a
  Gold-only assumption.
- The Crystal half should feel like the Crystal event; the HGSS half should
  feel like the HGSS event. Visual "HGSS recreation" is a **staging**
  recreation (blocking, dialogue, order of beats), not an asset port — the
  GSC engine's native graphics and actors are our palette.
- The catch must complete normally (registered, checkpointable, save-safe)
  before our continuation starts. Design the continuation trigger around
  the post-catch seam, not around a fragile battle patch.
- The event must be re-entry-safe: once the time-travel piece is done, it
  never re-runs (flag state), and an interrupted scene must leave the save
  in a resumable, non-broken state.

## Required animation work

Animations are part of the required event, not optional polish. Author and
implement them in the GSC visual style; reference HGSS staging without
shipping its graphics, models or audio. A sprite sheet alone does not finish
an animation: each beat needs frame timing, movement, effects and integration
with the scene sequence.

- **Celebi appearance:** shrine float-in, hovering/wing movement, turns and
  the approach into the level-30 encounter.
- **Celebi following:** directional movement and idle/hover frames after
  catching, including the shrine interaction that starts time travel.
- **Celebi activating time travel:** hops/circling around the player,
  glow/flash and disappearance/reappearance synchronized with each jump.
- **Time travel:** an authored transition for the Route 22 jump, hidden-room
  jump and return to Ilex. Design the lead-in, swirl/motion, white-out,
  off-screen map change and arrival/reveal as a continuous sequence.
- **Other scene actions:** receptionist delivery/retreat; Kurt's surprise,
  run-out and forest congratulations; Silver's argument, run-past and
  player stagger; Giovanni's departure. Reuse native walking/emote frames where suitable,
  authoring missing frames/effects as needed.

Storyboard these before implementation, recording actor positions/facings,
durations, dialogue cues, camera cues and sound cues. Verify them on Gold,
Silver and Crystal, in native 2D and with the voxel renderer/first-person
companions enabled. Input locks, temporary actors, camera changes and effects
must clean up on completion, interruption or reload; progression must resume
from a safe checkpoint. Keep effects bounded and reuse resources so animation
does not add ongoing rendering work outside the event.

## Open decisions (from Phase 0 research, to settle one by one)

1. **GS Ball item — decided and implemented.** Use a real key item. Gold
   and Silver register `GS_BALL` without a numeric ROM index, preserving
   `ITEM_73`/TERU-SAMA at index 115. Crystal keeps its existing record. Native
   bag transactions handle capacity, order and removal. The native GSC pack
   needs no item icon; shrine-placement art remains animation work.
2. **GS Ball delivery — decided and implemented.** After the first Hall of
   Fame entry, a receptionist approaches when leaving Goldenrod Pokémon
   Center. This follows Crystal VC gating and ensures the Radio Tower story
   precedes the later HGSS continuation. Delivery happens once per save;
   insufficient key-item space leaves it available on a later visit.
3. **Kurt's callback.** Vanilla Crystal uses no phone: Kurt runs out and the
   street coord scene fires. A `phone_contacts` call would be an HGSS-ish
   substitution — pick in Phase 2 (recommended: keep vanilla movement
   callback for fidelity; keep the phone call as a stretch nicety).
4. **Partner — excluded by user direction.** No Lyra/Ethan, replacement
   companion or Marill. Time/location captions replace the exposition.
5. **Giovanni field sprite — authored.** Original layered GBC-style dark
   overcoat/fedora sheet ships in 0.0.6, with six directional/walk poses.
   Use `SPRITE_CELEBI_GIOVANNI`, not a Rocket grunt. Version 0.0.7
   prefers the native imported Gen 1 sheet and keeps the authored sheet as a
   fallback when no valid Gen 1 import is present. Battle art and the native
   trainer registration remain a separate step.
6. **Celebi's shrine float + follower.** The Crystal float-in needs an
   authored 16×16 floating sprite (Rom leaves it unused; we author our
   own). After the catch, the HGSS trigger requires Celebi **following**
   the player — our engine's Gen 2 follower system can host that if we
   spawn/attach it post-catch (spike).
7. **Red-bold words.** HGSS colors *Time Travel* and *Team Rocket* red; the
   GBC text engine has no inline color. Options: drop emphasis (faithful
   dialogue, plain text), or approximate with inherent GBC conventions
   (e.g. emphatic wording). Recommended: drop, note in docs.
8. **Celebi no-run battle — resolved and implemented.** The current native
   Gen 2 engine supports `BATTLETYPE_CELEBI` (11). Arm native VAR_BATTLETYPE
   (0x03) for the shrine encounter; the engine consumes it once and refuses
   running. This is live-tested across Gold, Silver and Crystal.
9. **Time-travel transition.** Stage with quick fades/flash and a
   `present`-stage or screen effect (not `drawWorld`; inert on Gen 2).
   Chase beat rhythm over 3-D parity (white-out → swirl-smash → land).
10. **Hidden room realization — decided.** Create a dedicated cave room
    with a radio, connected to native `TOHJO_FALLS`. It must be discoverable
    during normal exploration before and after the event, not only through
    cutscene warps. See `reference/locations.md` and
    `dialogue/hgss/broken_radio.md`; map/warp implementation still needs a
    Phase 1 probe.

## End states

- After the full event, define: what is repeatable (nothing; the event is
  once-per-save in both sources), what isn't, and whether the HGSS half can
  be skipped if the player leaves the shrine area mid-scene (probably:
  scene restarts next visit until done).
- Post-event: Celebi is a normal party member; the event leaves no repeat
  hooks. Keep shrine text back to the vanilla protector read.

## Hidden room and radio requirements

- The Route 22 scene is three years before the hidden-room scene. Celebi
  advances those three years in the second jump; consecutive cutscenes do
  not mean the same historical day.
- Build a dedicated small cave room and an accessible entrance/return warp
  in Tohjo Falls. Keep ordinary exploration separate from event staging.
- Author a GSC-style broken radio sprite/object, with matching collision and
  an examine interaction. The event version of the radio broadcasts; normal
  visits show the original HGSS before/after text in
  `../dialogue/hgss/broken_radio.md`. Any active-state animation is authored.
- Ordinary entry must not spawn Giovanni/the partner or start time travel.
  After completion the room and radio remain accessible, with the updated
  examination text and no event replay. Persist this state across saves.
- Apply the same behavior to Gold, Silver and Crystal.

## Phase 2 mechanics and remaining staging

The implemented inspection/catch state machine is documented in
`../implementation/crystal-half.md`. Failed or interrupted encounters remain
retryable at the shrine without another GS Ball; this deliberately improves
on Crystal's consumed one-shot event. Catching promotes the quest only for
its own settled native catch; returning to the shrine afterward does not
create another Celebi. `caught` is a continuation-ready checkpoint, not the
final event-complete flag used by the broken radio.

Kurt's next-day dialogue and street hand-back work, but his physical run-out
and forest congratulations staging still need implementation. Celebi's field
appearance, follower and time-travel animation are also still required.
