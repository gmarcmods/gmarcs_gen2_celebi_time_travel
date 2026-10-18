# HGSS — Celebi time-travel event (reference breakdown)

**Status: researched.** Sources: Serebii's HGSS Celebi event page, the
full NA-version player transcript (GameFAQs, PSI_Ground, Apr 2010), and the
`pret/pokeheartgold` decomp (`src/field/event_cutscene_celebi.c`,
`include/constants/maps.h`). All HGSS material is reference only — nothing
ships from it.

## What the event actually is (correcting our own first guesses)

It is **not** a single shrine scene. With a **Fateful-Encounter Celebi
following the player** (HGSS follow-mon), examining the **Ilex Forest
shrine** triggers **two further time jumps and a trainer battle**:

```
[Ilex Forest shrine, present]     examine shrine; Celebi must be following
      │  Celebi jumps around; Lyra (or Ethan) arrives, her/his theme plays
      │  legend speech; light flash; Lyra: "...What was that?"
      │  Celebi flashes, flies in circles   (if the Celebi is shiny it turns
      ▼                                     green during this)
────  TIME JUMP 1  ────  white palette fades + camera swirl + 3D swirl model
      ▼
[Route 22 — three years ago]      Kanto, west of Viridian City
      │  reveals the famous argument (the man is Silver's father in HGSS
      │  lore; the scene never names either party) — no battle
      │  Silver bumps past the player, remarks, keeps running
      ▼
────  TIME JUMP 2  ────           → three years later than Route 22
      ▼
[Tohjo Falls Hidden Room]         Giovanni + a radio; the Archer broadcast
      │  radio declares Team Rocket's revival; Giovanni reacts
      │  **trainer battle: Rocket Boss Giovanni** (no Celebi involvement)
      │  after defeat, he leaves; the radio keeps calling him
      ▼
────  RETURN  ────                 present-day Ilex Forest; Lyra's Marill
      ▼                                     marks their own time (happy)
[Present]                          event over. Trigger never re-fires.
```

The user's memory of **"two locations of the past"** is exactly this:
`MAP_ROUTE_22` and `MAP_TOHJO_FALLS_HIDDEN_ROOM`.

## Presentation internals (from the decomp)

`FieldSystem_BeginCelebiTimeTravelCutsceneTask` shows how the jump plays:

1. Palette fade **both brightness types to RGB white**, main screen only.
2. The **follow-mon map object is hidden**; a 3D model
   (`demo/legend.naix`, NSBMD + NSBTA/NSBTP/NSBCA animations) — the "swirl"
   Celebi — is loaded and **positioned exactly at the follower's position**.
3. ~30 frames later a **swirl task** starts: camera rotates —
   `Camera_SetLookAtCamUp` spins the up-vector around Z over a fixed count
   (~0xB4 steps at 0x500 speed) while the perspective angle interpolates —
   a 3D "tunnel swirl".
4. Another ~80 frames later, a final palette fade **out to white** on both
   screens; the resources unload; the map switch happens off-screen.

Recreation idea (to settle in Phase 1 spikes): flash + fade + an authored
spin/fade effect. A GSC-engine equivalent can live in a custom screen or a
`present`-stage pipeline (`drawWorld` is inert on Gen 2). Do not chase 3D
parity; stage the beats (Celebi circles + white-out + flash + land).

## Beats, staging and full script

The complete transcribed script is split per beat under `dialogue/hgss/`
(`shrine_start.md`, `route_22.md`, `tohjo_falls_hidden_room.md`,
`return_present.md`).
Beat summary with staging facts:

### Beat A — shrine (present)

- Trigger: examine the shrine **with the event Celebi following**. Verify
  (modern releases): whether time of day or anything else gates it — no
  evidence of extra gating so far.
- Celebi hops around the player; **Lyra arrives** (the user remembered
  correctly; the counterpart depends: Ethan for a female player, Lyra for a
  male one — her theme plays), delivers the "people disappear when they
  tamper with it" legend lines, then a light flash startles her.
- Celebi flashes and **flies in circles**; a hacked/shiny Celebi turns
  green — i.e. the swirl uses the mon's shiny bit for tinting.

### Beat B — Route 22, three years ago

- You, Celebi and Lyra appear on **`MAP_ROUTE_22`** (map id 27, `MAP_R22`).
  Lyra's confusion monologue (verify exact lines in transcript, incl. the
  bold-red words **Time Travel** and **Team Rocket** — HGSS colors these;
  the GBC text engine has no inline color, an adaptation decision to make).
- **Camera shifts away from the player**: Silver argues with "a man in
  black" by the falling tree/Victory Road side; the full exchange is in the
  transcript. Notable staging:
  - The man leaves first ("One day, you will understand.").
  - Silver's yelled-answer solo ("…all by myself!") with his theme; he runs
    off, notices you, says `…What are you staring at?`, **pushes/kicks you
    out of the way**, continues running.
- Lyra names the wider stakes ("They say Team Rocket was removed from the
  Kanto region by a child three years ago. So this really is three years
  ago!") — Celebi starts glowing again ("It's happening again…! It's
  CELEBI's Time Travel!").

### Beat C — Tohjo Falls Hidden Room

- The second jump lands inside **`MAP_TOHJO_FALLS_HIDDEN_ROOM`** (map id
  298, `MAP_D45R0102`) — a small hidden room off Tohjo Falls (Route 22 side)
  holding **Giovanni and a radio**. This jump advances three years from
  the Route 22 argument to the Radio Tower takeover; the scenes are
  consecutive for the travelers because Celebi moves them through time.
- The room plays the Radio Tower revival broadcast (the transcript's
  "Radio" lines); "Team Rocket theme" plays.
- Giovanni notices you ("...I don't know why you have come here…"), notes
  the resemblance ("You have the same eyes…"), states his destination
  ("I'm on my way to Goldenrod City to answer the call and join my team.
  Are you going to get in my way?") and you battle him.
- **Battle team (Serebii):** Nidoking 42, Honchkrow 43, Nidoqueen 46,
  Kangaskhan 40. **Honchkrow does not exist in Gen 2** — the Gen 2-native
  substitute is **Murkrow** (adaptation logged in design/).
- Post-win lines: "What are you? How can an unexperienced kid be this
  good?" → "What in the world are you?" → after the battle "How is this
  possible…? The past three years have been a waste…? …The precious dream
  of Team Rocket has become little more than an illusion…" — he leaves.
- The radio keeps piping: "…Hey! Where has Giovanni gone? I wonder if he is
  listening to our broadcast…" Lyra: "They keep calling for their boss. I
  feel sorry they don't know he's not coming. After this, <NAME>, you will
  defeat them! …Wait a second! [Ian→<PLAYER>?], you're still here. Then,
  who will defeat Team Rocket…?"
- Celebi flashes once more; Lyra: "Not again…! I've had enough! Please let
  me go back to my time!"

### Beat D — return

- Back in present-day Ilex Forest (near the shrine), Lyra complains that
  "Traveling through time sure doesn't feel good."
- Her **Marill** catches her eye ("Hey, my MARILL! …So we must be back to
  our own time!") — the Marill-indicator beat is the event's own
  "you're home" marker; verify whether the Marill is visible in the past
  scenes or only on arrival (screenshots task).
- Send-off: "It was all so bizarre. But now that we are safely back to our
  time and Team Rocket's terrible design fell through, we can say… All's
  well that ends well, right? <NAME>, you never cease to inspire great
  adventures. It sure was an exhausting day, though. I better get going."
  "See you!" — she leaves and the event ends for good.

## Trigger facts to nail down

- [ ] The requirement is the Celebi **following you** (follow-mon).
      Walkthrough sources say the caught-but-not-following case does NOT
      trigger it — exactly which check HGSS uses (species-follow + fateful
      flag) needs emulator verification.
- [ ] Is the shrine examined once, or does the player re-examine? (The
      swirl seems to start from the examine action itself.)
- [ ] Whether the event is reachable in HGSS before beating the Elite Four,
      or is gated by story state — affects our own gating defaults.
- [ ] In our mod the trigger will be **Celebi caught via our Crystal-style
      shrine event + revived shrine interaction**; the exact hand-off beat
      is a design decision (immediately after the catch vs. a later visit).

## GSC-side feasibility snapshot (verified against the engine's Gold data)

| HGSS element | Native in the merged engine? |
| --- | --- |
| Ilex Forest map + shrine | ✓ (`ILEX_FOREST`, shrine bg `(8,22)`) [gold ✓] |
| Route 22 | ✓ native GSC map `ROUTE_22` exists [gold ✓] |
| Tohjo Falls | ✓ native GSC map `TOHJO_FALLS` exists [gold ✓] |
| Hidden room (a real map) | ✗ needs a map-realization decision (copy/variant) |
| Silver field sprite | ✓ `SPRITE_RIVAL` [gold ✓] |
| Kurt, link receptionist sprites | ✓ [gold ✓] |
| Giovanni field sprite | ✗ no boss-cloak sprite (`SPRITE_ROCKET` is the grunt) |
| Lyra/Kotone field sprite | ✗ none; authoring or adaptation decision |
| Marill field sprite | ✗ none |
| Celebi field-floating sprite | ✗ no field sprite (only battle art); Crystal's shrine art exists only as an unused ROM graphic of the event (`gfx/overworld/celebi.2bpp`) — our version must be authored |
| Murkrow | ✓ native |
| Honchkrow | ✗ not in Gen 2; substitute Murkrow (decision in `design/event-flow.md`) |

## Open verifications

- [ ] Walkthrough video + screenshots for every staging beat (see
      `screenshots/README.md`).
- [ ] Whether HGSS allows the event pre-E4 with a transferred/event Celebi
      (probably yes) — affects our own gating defaults.
- [ ] This transcript is from a NA emulated copy; verify nothing differs in
      version text used by us (we must not paraphrase — check a second
      transcription against the GameFAQs one before finalizing script text).
