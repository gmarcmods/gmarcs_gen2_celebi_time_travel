# Design — mixing the two events

This is the plan of the **combined event**, informed by the Phase 0
research (see `reference/` for what is verified and `dialogue/` for the
original scripts). Nothing here is final until the engine spikes settle the
capability questions.

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
[our continuation — HGSS flow, continue like HGSS, original English]
Shrine swelling scene: Celebi circles, partner arrives, legend speech
                                   ↓
                         Time-travel transition (flash/white/swirl, staged)
                                   ↓
Route 22 — three years ago: partner monologue, the argument (rival +
"man in black"), rival runs you down
                                   ↓
                         Second jump (three years forward from Route 22)
                                   ↓
Tohjo Falls hidden room: radio broadcast, Giovanni reveal, boss battle
(Nidoking 42 / Murkrow 43* / Nidoqueen 46 / Kangaskhan 40)
                                   ↓
                         Return to present Ilex Forest: partner's Marill
                         beat, send-off; event closes permanently
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
  run-out and forest congratulations; partner approach/reactions/departure;
  Silver's argument, run-past and player stagger; Giovanni's departure;
  Marill's return greeting. Reuse native walking/emote frames where suitable,
  authoring missing frames/effects as needed.

Storyboard these before implementation, recording actor positions/facings,
durations, dialogue cues, camera cues and sound cues. Verify them on Gold,
Silver and Crystal, in native 2D and with the voxel renderer/first-person
companions enabled. Input locks, temporary actors, camera changes and effects
must clean up on completion, interruption or reload; progression must resume
from a safe checkpoint. Keep effects bounded and reuse resources so animation
does not add ongoing rendering work outside the event.

## Open decisions (from Phase 0 research, to settle one by one)

1. **GS Ball as a real item vs. mod state.** `GS_BALL` does not exist in
   Gold's item data (Crystal-only; [gold ✓] verified). Faithful option:
   register an authored item (needs an authored icon + registry record).
   Light option: track the ball in mod state and stage the hand-over/hand-
   back without a bag entry. The Crystal feel favors the item.
2. **GS Ball delivery trigger.** Vanilla-gates: VC = after the first Hall
   of Fame; JP = mobile center activities. Ours should pick something early
   and lawful (e.g. after the Azalea/Kurt plot point) — t.b.d.
3. **Kurt's callback.** Vanilla Crystal uses no phone: Kurt runs out and the
   street coord scene fires. A `phone_contacts` call would be an HGSS-ish
   substitution — pick in Phase 2 (recommended: keep vanilla movement
   callback for fidelity; keep the phone call as a stretch nicety).
4. **Partner character in the past scenes.** HGSS uses the counterpart
   protagonist (Lyra for a male player, Ethan for a female one). Our
   options: (a) author a GBC-style Lyra/Kotone field sprite (faithful to
   the user's memory, most work); (b) reuse a native female-coded sprite
   (e.g. teacher/kimono girl) with adapted identity; (c) use the other
   protagonist sprite (`SPRITE_CHRIS` is native) as "the friend". Decision
   after a sprite-authoring spike.
5. **Giovanni field sprite.** No boss-cloak sprite in Gen 2; candidates:
   reuse `SPRITE_ROCKET` (grunt) with text-only reveal, or author a GBC
   boss sprite. Battle side needs a mod-registered trainer (no native
   Giovanni trainer), with `trainer.party` replacing Honchkrow → Murkrow.
6. **Celebi's shrine float + follower.** The Crystal float-in needs an
   authored 16×16 floating sprite (Rom leaves it unused; we author our
   own). After the catch, the HGSS trigger requires Celebi **following**
   the player — our engine's Gen 2 follower system can host that if we
   spawn/attach it post-catch (spike).
7. **Red-bold words.** HGSS colors *Time Travel* and *Team Rocket* red; the
   GBC text engine has no inline color. Options: drop emphasis (faithful
   dialogue, plain text), or approximate with inherent GBC conventions
   (e.g. emphatic wording). Recommended: drop, note in docs.
8. **"Can't run" during the Celebi battle.** `BATTLETYPE_CELEBI` semantics
   are not reachable from the Gen 2 mod API; accept a normal escapeable
   wild battle (or gate via battle rules if one exists on Gen 2 — spike).
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
