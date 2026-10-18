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

**Phase 2 mechanics implemented; cinematic work and HGSS continuation pending.**
Development version `CELEBI_MOD` 0.0.2 includes the dedicated Tohjo Falls room,
authored broken radio, native-VM actor actions and a playable GS Ball flow:
Hall of Fame → Goldenrod delivery → Kurt inspection → next-day/street callback
→ shrine Yes/No → native level-30 Celebi battle/catch. New quest dialogue is
currently English. Gold/Silver register a separate real key item; Crystal
retains its native item. Original item slots and vanilla event flags are preserved.

Live mechanic checks passed on Gold, Silver and Crystal. Gold also exercised
the voxel battle renderer with GEN2_ES enabled; Crystal exercised full-party
PC capture. Inspection progress passed native save serialization/rebinding.

Celebi's field art/follower/appearance animation, Kurt's run-out and physical
congratulations, the Giovanni battle and time-travel scenes are still unfinished.
This development mod is not a release ZIP. See
[`docs/implementation/crystal-half.md`](docs/implementation/crystal-half.md),
[`docs/implementation/probe-results.md`](docs/implementation/probe-results.md)
and [`docs/design/scene-staging.md`](docs/design/scene-staging.md).
See [`docs/README.md`](docs/README.md) for the full documentation index.

## Hard constraints from the workspace

- No HGSS assets ship in any way; HGSS is reference material only
  (transcriptions and screenshots for study). This mod is a **recreation
  authored in the GSC engine**, like the engine docs treat ports.
- Reference ROMs live outside the workspace and are never packaged.
- The authored voxel project (`new_mod_ex`) is unrelated to this mod; nothing
  here may touch `data/voxel_heights.lua`.
- Follow `workspace/AGENTS.md`: failing test/probe first, commit per purpose
  in this repository, run real drivers before claiming anything works.

## Development checks

From the workspace root:

```sh
luajit mods/gen2/celebi_mod/tests/room.lua
luajit mods/gen2/celebi_mod/tests/actions.lua
luajit mods/gen2/celebi_mod/tests/progress.lua
luajit mods/gen2/celebi_mod/tests/item.lua
luajit mods/gen2/celebi_mod/tests/quest.lua
```

`tests/room.lua` uses the isolated Gold/Silver/Crystal caches documented in
`docs/implementation/probe-results.md`; missing caches fail rather than skip.
From `gen1recomp/`, run `tests/capabilities.lua` as a normal POKEPORT_DRIVER
with an isolated imported identity, the authored voxel mod enabled and an
existing POKEPORT_SHOT_DIR. The driver never saves. `tools/draw_radio.py`
regenerates the hand-authored radio pixels; no source-game art is copied.

`tests/crystal_half.lua` drives the playable event mechanics in a disposable
identity, including native choices, pack display, save serialization and catch.
Never run it on the user's real playthrough; it modifies test progression in
memory but never writes a game save.
