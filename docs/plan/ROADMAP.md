# Roadmap

Status: **Phase 2 mechanics implemented; cinematics in progress**. The
room/radio, native-VM actions and playable GS Ball/catch mechanics are
implemented; see `implementation/probe-results.md` and
`implementation/crystal-half.md`.
The complete quest is not implemented. Order is
dependency-based: no scene recreation until the engine capability questions
in `implementation/engine-integration.md` are settled with real probes.

## Phase 0 — Research & inventory (reference work done; screenshots pending)

- [x] Break down the Crystal GS Ball event (scripts, flags, actors, timing)
      in `reference/crystal-gs-ball-event.md` (pret/pokecrystal +
      engine data cross-check).
- [x] Break down the HGSS Celebi event, scene by scene, in
      `reference/hgss-celebi-event.md` (Serebii + NA transcript +
      pret/pokeheartgold).
- [x] Fix the exact list of "past" locations in the HGSS event and where
      each lives in both games (`reference/locations.md`) — resolved:
      Route 22 and the Tohjo Falls hidden room.
- [x] Transcribe original English dialogue per scene (`dialogue/hgss/`,
      `dialogue/crystal/`).
- [ ] Screenshot every scene state (`screenshots/`) — HGSS reference caps
      and the second-source dialogue check remain.
- [x] Asset inventory: what already exists natively in GSC/Gold/Silver/Crystal
      data usable by this mod (sprites, maps, tilesets, music, cries) vs
      what must be authored (`implementation/assets-checklist.md`).

## Phase 1 — Engine capability spikes

Write one failing probe per question, run it on real Gold (and the other
editions where relevant), and record the answer in
`implementation/engine-integration.md`:

- [x] Can we intercept/re-enter the Ilex shrine event flow (world.talk,
      script.started/script.command, or screen replacement)? — *question
      resolved by live probes: intercept its edition-specific entry script
      through `script.command`; the NPC talk hook does not own this bg event.*
- [ ] Can we author a full scripted cutscene (actor marching, camera,
      timed dialogue, fades) from a mod, and does it hold on all three
      editions?
- [ ] Storyboard the required animations in `design/event-flow.md`:
      Celebi float/follower/circling, all time-travel transitions and actor
      choreography. Probe sprite animation, effect timing, input locking,
      renderer compatibility and interruption cleanup before building scenes.
- [x] Can we present a map variation ("past") without duplicating the map?
      (registered map copy vs runtime block replacement vs reuse of existing
      blocks tilesets) — see `implementation/engine-integration.md`; now
      scoped to implementing the required dedicated Tohjo Falls hidden room
      with permanent entrance/return warps, not choosing a substitute room.
      Registered room and actual entrance/exit passed all three editions.
- [x] Celebi encounter construction (species 251 is native; exact level,
      battle intro, catch flow, post-catch flag).
- [x] After-catch continuation: can a catch trigger a scene (which event
      payload reaches us — pokemon.caught / battle.ended)?
- [x] Celebi attaches to the native Gen 2 follower system after the catch,
      with party eligibility, map/party cleanup and authored animation (0.0.4).
- [ ] Which engine surfaces still don't exist on Gen 2 that the design
      depends on (trainer.before_battle, drawWorld pipelines, …) and which
      of those our design avoids.

## Phase 2 — Crystal half ("start like Crystal")

- [x] Decide and implement a real GS Ball and delivery after first Hall of
      Fame; preserve Gold/Silver's original TERU-SAMA slot and Crystal's item.
- [x] Kurt hand-over, next-day inspection and street callback mechanics;
      ordinary original event flags remain untouched. No phone substitution.
- [x] Shrine Yes/No, item consumption, level-30 Celebi no-run battle and
      normal native catch/nickname/storage; reject unrelated catch events.
- [x] Inspection state survives native save serialization/rebinding; pure
      state tests cover failed inventory transactions and encounter retry.
- [x] Authored Celebi directional/wing sheet, shrine float-in/hover and native
      cry synchronized with battle start (0.0.4).
- [ ] Remaining character emote/sound cues and shrine player step-away.
- [x] Kurt workshop exit, temporary visibility, forest approach/departure and
      interrupted post-catch congratulations checkpoint (0.0.3).
- [ ] Finish cinematic interruption/resume checkpoints, loss/retry live
      checks and migration of an already-active native Crystal GS Ball quest.

## Phase 3 — HGSS half ("continue like HGSS")

- [ ] Time-travel transition treatment (white-out → swirl → land; staged,
      not 3-D).
- [x] Celebi animated follower through the native Gen 2 trail loop, gated by
      caught progress and a healthy Celebi lead (0.0.4).
- [ ] Time-travel activation, reusable jump/return effects and arrival sequences.
- [ ] Animate partner reactions, Silver's run-past/player stagger,
      Giovanni's departure and Marill's return greeting.
- [ ] Route 22 scene: partner arrives, the argument (rival + man in
      black), the run-you-down beat.
- [x] Create the dedicated hidden cave room, permanently discoverable from
      Tohjo Falls, with entrance/return warps and authored broken radio art.
- [x] Implement the original HGSS radio examination text before/after the
      event; ordinary visits must not trigger cutscene actors or replay.
      Both states are live-tested through saved mod data; the future quest
      still needs to set the completion state at its real conclusion.
- [ ] Hidden room scene: radio broadcast staging, Giovanni reveal, boss
      battle (Nidoking 42 / Murkrow 43 / Nidoqueen 46 / Kangaskhan 40).
      This scene is three years after Route 22, reached by time travel.
- [ ] Return scene: Marill beat + send-off; event closure flags.
- [ ] Dialogue integration (adapted to the GSC text engine; generation- and
      edition-aware where needed).

## Phase 4 — Hardening for the three editions

- [ ] Gold / Silver / Crystal boots: content registry routing per edition,
      text differences, flag/value differences.
- [ ] gen2check clean, headless SDK load on generation 2, unit tests per
      workspace rules, live drivers on all three editions.
- [ ] Screenshots compared against `screenshots/` reference sets for basic
      event-flow parity (staging only, not voxel/art details).
- [ ] Capture and inspect animation sequences on all three editions, in
      native 2D and voxel/first-person modes. Verify timing, safe resume,
      input/camera/effect cleanup and bounded effect rendering cost.

## Open decisions (tracked in `design/event-flow.md` §Open decisions)

1. GS Ball item, HoF delivery and native Celebi no-run behavior are resolved
   in `implementation/crystal-half.md`.
2. Finish Kurt's emote/sound cues; physical workshop exit and forest congratulations are implemented without a phone substitution.
3. Partner character and her sprite (author GBC-style Lyra vs adapt a
   native sprite).
4. Giovanni field sprite (grunt reuse vs authored) + trainer registration.
5. Red-bold handling and time-travel transition treatment. The dedicated hidden room and broken radio are required;
   implementation details still need probes.
