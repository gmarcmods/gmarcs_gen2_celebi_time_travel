# Roadmap

Status: **planning**. Nothing has been implemented yet. Order is
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
      sharpened in Phase 0: the shrine is a bg event (8,22); test whether
      world.talk reaches it at all.*
- [ ] Can we author a full scripted cutscene (actor marching, camera,
      timed dialogue, fades) from a mod, and does it hold on all three
      editions?
- [ ] Storyboard the required animations in `design/event-flow.md`:
      Celebi float/follower/circling, all time-travel transitions and actor
      choreography. Probe sprite animation, effect timing, input locking,
      renderer compatibility and interruption cleanup before building scenes.
- [ ] Can we present a map variation ("past") without duplicating the map?
      (registered map copy vs runtime block replacement vs reuse of existing
      blocks tilesets) — see `implementation/engine-integration.md`; now
      scoped to implementing the required dedicated Tohjo Falls hidden room
      with permanent entrance/return warps, not choosing a substitute room.
- [ ] Celebi encounter construction (species 251 is native; exact level,
      battle intro, catch flow, post-catch flag).
- [ ] After-catch continuation: can a catch trigger a scene (which event
      payload reaches us — pokemon.caught / battle.ended)?
- [ ] Can Celebi be attached to the Gen 2 follower system after the catch
      (the HGSS trigger requires a following Celebi)?
- [ ] Which engine surfaces still don't exist on Gen 2 that the design
      depends on (trainer.before_battle, drawWorld pipelines, …) and which
      of those our design avoids.

## Phase 2 — Crystal half ("start like Crystal")

- [ ] Decide the GS Ball acquisition flow (design decision, logged in
      `design/event-flow.md` decision 2) — `GS_BALL` itself is not in
      Gold's data (decision 1: register a real item vs mod state).
- [ ] Kurt: hand over, wait, call-back (phone system is live on Gen 2).
- [ ] Shrine approach and Celebi appearance/battle.
- [ ] Author and implement Celebi's shrine float-in/hover animation and
      Kurt/receptionist choreography, synchronized with dialogue and battle.
- [ ] Catch handled; save state clean (checkpoint/resume safe).

## Phase 3 — HGSS half ("continue like HGSS")

- [ ] Time-travel transition treatment (white-out → swirl → land; staged,
      not 3-D).
- [ ] Implement Celebi's animated follower and time-travel activation;
      author the reusable jump/return effects and arrival sequences.
- [ ] Animate partner reactions, Silver's run-past/player stagger,
      Giovanni's departure and Marill's return greeting.
- [ ] Route 22 scene: partner arrives, the argument (rival + man in
      black), the run-you-down beat.
- [ ] Create the dedicated hidden cave room, permanently discoverable from
      Tohjo Falls, with entrance/return warps and authored broken radio art.
- [ ] Implement the original HGSS radio examination text before/after the
      event; ordinary visits must not trigger cutscene actors or replay.
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

1. GS Ball as a real item vs mod state; delivery trigger condition.
2. Kurt callback: vanilla movement scene (recommended) vs phone call.
3. Partner character and her sprite (author GBC-style Lyra vs adapt a
   native sprite).
4. Giovanni field sprite (grunt reuse vs authored) + trainer registration.
5. Red-bold handling, no-run flavor in the Celebi battle, transition
   treatment. The dedicated hidden room and broken radio are required;
   implementation details still need probes.
