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
Development version `CELEBI_MOD` 0.0.8 includes the dedicated Tohjo Falls room,
authored broken radio, native-VM actor actions and a playable GS Ball flow:
Hall of Fame → Goldenrod delivery → Kurt inspection → next-day/street callback
→ shrine Yes/No → native level-30 Celebi battle/catch. New quest dialogue is
currently English. Gold/Silver register a separate real key item; Crystal
retains its native item. Original item slots and vanilla event flags are preserved.

Live mechanic checks passed on Gold, Silver and Crystal. Gold also exercised
the voxel battle renderer with GEN2_ES enabled; Crystal exercised full-party
PC capture. Inspection progress passed native save serialization/rebinding.

Kurt now walks out of the workshop, remains outside without changing vanilla
flags or saved object masks, and approaches/departs after the catch. Interrupted
congratulations resume from the shrine without another battle.

Celebi now floats into the shrine with animated wings and its native Pokémon
palette. After the catch and Kurt's congratulations, put a healthy Celebi first
in the party to have it follow you through the native trail system. A boxed
Celebi must first be withdrawn. Changing the lead removes it.

Kurt's surprise emote, the Giovanni battle and full time-travel story
are still unfinished. The historical story is adapted for the player and Celebi
alone: no Lyra/Ethan, replacement companion or Marill. Short time/location
captions replace the partner's exposition.
Development 0.0.8 stores original Red Giovanni overworld and battle sprites
in the mod, as explicitly requested. They need no additional import at runtime.
`CELEBI_GIOVANNI` registers the local portrait and correct boss team; the quest's
Giovanni battle/return sequence is still pending. The GSC Celebi sheet and
paved gate approach remain. See `THIRD_PARTY_NOTICES.md` for provenance.

Development 0.0.6 adds original GBC-style Giovanni field art, the Route 22
argument and departures, Silver pushing past the player and hopping the native
ledge, and Celebi's second jump three years forward to the radio room.
`CELEBI_MOD:shrineJump` previews the first jump; `CELEBI_MOD:historyOpening`
runs the historical opening through the second-arrival caption. These are
development VM commands, not ordinary shrine triggers. The Giovanni battle,
story save/resume checkpoints and final return are still required before
normal activation. See `docs/implementation/route22.md`.

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
luajit mods/gen2/celebi_mod/tests/paths.lua
luajit mods/gen2/celebi_mod/tests/follower.lua
luajit mods/gen2/celebi_mod/tests/motion.lua
python3 mods/gen2/celebi_mod/tests/art.py
```

`tests/room.lua` uses the isolated Gold/Silver/Crystal caches documented in
`docs/implementation/probe-results.md`; missing caches fail rather than skip.
From `gen1recomp/`, run `tests/capabilities.lua` as a normal POKEPORT_DRIVER
with an isolated imported identity, the authored voxel mod enabled and an
existing POKEPORT_SHOT_DIR. The driver never saves. `tools/draw_radio.py`
regenerates the hand-authored radio pixels; `tools/draw_celebi.py` regenerates
the directional Celebi sheet. No source-game bitmap is copied.

`tests/crystal_half.lua` drives the playable event mechanics in a disposable
identity, including native choices, pack display, save serialization and catch.
Never run it on the user's real playthrough; it modifies test progression in
memory but never writes a game save.
