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

**Development 0.0.12: GS Ball quest and solo historical sequence implemented.**
Hall of Fame → Oak’s incoming invitation → Pallet lab GS Ball → Kurt inspection → next-day street callback
→ shrine Yes/No → native level-30 Celebi battle/catch. Leave at least one
party slot empty before placing the GS BALL; a full party is refused without
consuming it. Celebi joins that slot instead of being sent to the PC.
Gold/Silver register a separate key item; Crystal retains its native item.
Original item slots, vanilla event flags and unrelated authored voxel assets
are preserved.

After the Celebi battle, the team receives a full HP/status/PP heal. Kurt
congratulates you and leaves; Celebi immediately animates and starts time
travel in the same input-locked event. No walking, party reordering, lead swap
or second shrine read is needed. The historical sequence follows: upper Route 22 path, Silver's argument and player stagger,
second jump three years forward, Giovanni/radio conversation, native trainer
battle, victory departure and return to the Ilex shrine. There is no partner.
Winning returns the whole party to the Ilex shrine at (8,23), restores normal
following behavior and records completion. Reading the shrine afterward does not replay
history. A loss follows native whiteout, leaves the story incomplete and
permits a later retry with a healthy Celebi leading. Development preview
commands remain available for testing.

All quest, history and broken-radio text uses a local Spanish catalog when
`GEN2_ES` is loaded. Without it, the mod uses English. A missing Spanish entry
falls back to its English entry. Speaker prefixes use the actual saved rival
name; the unnamed man becomes GIOVANNI after the radio identifies him.
Spanish HGSS/solo text is an authored adaptation, not a claim of verbatim GSC
cartridge dialogue.

Original Red Giovanni overworld and battle sprites are stored in the mod,
as requested, without requiring a Red import at runtime. The battle party is
Nidoking 42 / Murkrow 43 / Nidoqueen 46 / Kangaskhan 40. See
`THIRD_PARTY_NOTICES.md` for asset provenance.

The new room uses map-local voxel geometry supported by the current voxel
runtime: flat traversable floor, solid rock walls and an empty outer border.
It does not change the cave tileset's shared authored profile. Native 2D uses
native cave blocks and collisions. The permanent entrance is in Tohjo's
left-hand alcove at (3,5), reachable by Surf from either Route 27 entrance.
The old upper-ledge entrance was disconnected and has been replaced. Normal
visits contain only the broken radio. Its examination text changes after
victory/return and follows the active English/Spanish catalog.

On Crystal this replaces the original GS Ball event. Native delivery/street
entry points and Kurt's original GS Ball branches are suppressed while the mod
is enabled; normal Apricorn work and unrelated Slowpoke Well scenes remain.
No saved vanilla event flags are rewritten. Gold and Silver receive the same
mod quest without Crystal-only map edits.

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

Oak’s invitation requires no registered phone number and waits behind native
special calls, including Elm’s S.S. Ticket call. His ordinary lab conversation
and Pokédex evaluation run first, including the 16-badge Mt. Silver unlock.
Talk to him again if the key-item pocket is full. The lab gift remains
available even without completing the invitation call; an interrupted call
can ring again. Existing saves that already received the ball continue their
quest without a second gift. See [Oak delivery](docs/implementation/oak-delivery.md).
