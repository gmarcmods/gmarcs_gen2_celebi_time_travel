# Design — mixing the two events

This is the plan of the **combined event**, to be refined as
`reference/` fills in. Nothing here is final until the reference breakdowns
and engine spikes agree with it.

## The combined arc

```
[Crystal flow]                    [our continuation — HGSS flow]
GS Ball  →  Kurt  →  (call)  →
  shrine  →  Celebi battle  →  CAUGHT
                                   ↓
                         NOT the end: catch fires our scene
                                   ↓
                         Time-travel transition
                                   ↓
                         Past scene(s) with original English staging
                                   ↓
                         Return to present, event closes
```

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
  the post-catch seam, not around a fragile battle patch anyway beyond the
  documented API.
- The event must be re-entry-safe: once the time-travel piece is done, it
  never re-runs (flag state), and an interrupted scene must leave the save
  in a resumable, non-broken state.

## Actor adaptation questions (to decide after dialogue research)

- **The walking partner in the past scene.** HGSS uses the counterpart
  protagonist — the user remembers **Lyra/Kotone**. Verify: is the partner
  always Lyra, or Ethan for a female player character? GSC has no Lyra/Kotone
  sprite natively. Candidate adaptations, to choose from:
  1. Author a Kotone/NPC sprite through the engine's sprite/actor surface
     (verify feasibility first).
  2. Reuse an existing native GSC NPC as the partner (identity adapted in
     dialogue).
  3. Crystal-native option: Kris (exists in Crystal edition data) — but is
     she available on a Gold/Silver boot? serde check across editions.
- **Giovanni and Persian** exist natively in GSC (Team Rocket-era sprites) —
  expected to be reusable as-is; verify sprite presence in all three
  editions.
- Dialogue tone: keep original English lines where possible; only the
  partner-related wording (and any double protagonist quirk) may need
  adaptation. Hablemos after transcription.

## End states

- After the full event, define: what is repeatable, what isn't, and whether
  the HGSS half can be skipped if the player leaves the shrine area
  mid-scene (probably: scene restarts next visit until done).
