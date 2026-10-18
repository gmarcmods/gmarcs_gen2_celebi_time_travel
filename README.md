# Celebi Mod (working title: celebi_mod)

A Gen 2 event mod that **mixes the Crystal GS Ball Celebi event with the
HeartGold/SoulSilver Celebi time-travel event**, replayed inside the
gen1recomp GSC engine.

## Objective

1. **Start like Crystal:** the player obtains the GS Ball, brings it to Kurt,
   Kurt sends them to the **Ilex Forest shrine**, and Celebi appears and is
   battled and caught (the classic Crystal GS Ball event flow).
2. **Continue like HGSS:** catching Celebi does **not** end the event. It
   starts a recreation of the HGSS Celebi event — Celebi takes the player
   back in time, the past scene(s) play out with their original English
   dialogue, and the player is returned to the present.

## Compatibility goal

- `games: gold, silver, crystal` — one mod, all three editions. Every
  edition-specific difference (scripts, text, flags, assets) must be either
  edition-aware or edition-neutral. This must be stated in everything we
  build, from probes to final text.
- Everything is done through the public engine API (registries, hooks,
  events, screens); `engine_internals` only where a documented facade exists.

## Current status

**Planning / research phase — Phase 0 reference research complete,
screenshots pending.** No engine code yet; no `manifest.json` yet.
Everything in `docs/` is being gathered: reference breakdowns of both
original events, dialogue, screenshots, map-location research, and the
asset checklist. See [`docs/README.md`](docs/README.md) for the index.

## Hard constraints from the workspace

- No HGSS assets ship in any way; HGSS is reference material only
  (transcriptions and screenshots for study). This mod is a **recreation
  authored in the GSC engine**, like the engine docs treat ports.
- Reference ROMs live outside the workspace and are never packaged.
- The authored voxel project (`new_mod_ex`) is unrelated to this mod; nothing
  here may touch `data/voxel_heights.lua`.
- Follow `workspace/AGENTS.md`: failing test/probe first, commit per purpose
  in this repository, run real drivers before claiming anything works.
