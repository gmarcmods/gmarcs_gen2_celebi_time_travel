# Roadmap

Status: **planning**. Nothing has been implemented yet. Order is
dependency-based: no scene recreation until the engine capability questions
in `implementation/engine-integration.md` are settled with real probes.

## Phase 0 — Research & inventory (current)

- [ ] Break down the Crystal GS Ball event (scripts, flags, actors, timing)
      in `reference/crystal-gs-ball-event.md`.
- [ ] Break down the HGSS Celebi event, scene by scene, in
      `reference/hgss-celebi-event.md`.
- [ ] Fix the exact list of "past" locations in the HGSS event and where
      each lives in both games (`reference/locations.md`).
- [ ] Transcribe original English dialogue per scene (`dialogue/hgss/`,
      `dialogue/crystal/`).
- [ ] Screenshot every scene state (`screenshots/`).
- [ ] Asset inventory: what already exists natively in GSC/Gold/Silver/Crystal
      data usable by this mod (sprites, maps, tilesets, music, cries) vs
      what must be authored (`implementation/assets-checklist.md`).

## Phase 1 — Engine capability spikes

Write one failing probe per question, run it on real Gold (and the other
editions where relevant), and record the answer in
`implementation/engine-integration.md`:

- [ ] Can we intercept/re-enter the Ilex shrine event flow (world.talk,
      script.started/script.command, or screen replacement)?
- [ ] Can we author a full scripted cutscene (actor marching, camera,
      timed dialogue, fades) from a mod, and does it hold on all three
      editions?
- [ ] Can we present a map variation ("past") without duplicating the map?
      (registered map copy vs runtime block replacement vs reuse of existing
      blocks tilesets) — see `implementation/engine-integration.md`.
- [ ] Celebi encounter construction (species 251 is native; exact level,
      battle intro, catch flow, post-catch flag).
- [ ] After-catch continuation: can a catch trigger a scene (which event
      payload reaches us — pokemon.caught / battle.ended)?
- [ ] Which engine surfaces still don't exist on Gen 2 that the design
      depends on (trainer.before_battle, drawWorld pipelines, …) and which
      of those our design avoids.

## Phase 2 — Crystal half ("start like Crystal")

- [ ] Decide the GS Ball acquisition flow (design decision, logged in
      `design/event-flow.md`) — original was a mobile/Time Capsule
      distribution; we need a lawfully authored trigger.
- [ ] Kurt: hand over, wait, call-back (phone system is live on Gen 2).
- [ ] Shrine approach and Celebi appearance/battle.
- [ ] Catch handled; save state clean (checkpoint/resume safe).

## Phase 3 — HGSS half ("continue like HGSS")

- [ ] Time-travel transition treatment.
- [ ] Past scene(s): map state, placement of every actor, staging.
- [ ] Dialogue integration (adapted to the GSC text engine; generation- and
      edition-aware where needed).
- [ ] Return to the present and event closure.

## Phase 4 — Hardening for the three editions

- [ ] Gold / Silver / Crystal boots: content registry routing per edition,
      text differences, flag/value differences.
- [ ] gen2check clean, headless SDK load on generation 2, unit tests per
      workspace rules, live drivers on all three editions.
- [ ] Screenshots compared against `screenshots/` reference sets for basic
      event-flow parity (staging only, not voxel/art details).

## Open decisions (log every one here when made)

- Partner character in the past scene and its adaptation (see
  `design/event-flow.md`).
- GS Ball acquisition design.
- Whether the "past" is one location or more, and how each is realized.
