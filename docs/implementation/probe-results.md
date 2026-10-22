# Phase 1 probe results

2026-10-16, desktop Love/LuaJIT, current workspace engine. Development mod
`gmarcs_gen2_celebi_time_travel` 0.0.1; authored renderer `gmarcs_gen2_voxel_mod` 0.1.30. No engine or authored
voxel-profile changes were needed. These findings supersede earlier Phase 0
assumptions where they disagree.

## Verified live on Gold, Silver and Crystal

- Native shrine reads emit `script.started` and `script.command`.
  Resolve the entry script from the native bg event at (8,22), rather than
  hardcoding a Gold address. Gold/Silver: `45:6989`; Crystal: `1b:6e27`.
- Returning `"end"` from the entry script's command hook suppresses the native
  interaction cleanly. Gold/Silver begin with `jumptext`; Crystal begins with
  a conditional chain. Intercept the entry before those branches execute.
- The current VM reports `ctx.mapId` as a numeric pair: Gold/Silver `3:44`,
  Crystal `3:52`. It does **not** report `ILEX_FOREST` in these runs. Use the
  named active map and the dynamically resolved entry script together.
- A maps-registry record creates a new playable cave room. A patch adding
  one Tohjo warp and replacing one block creates a functioning entrance.
  Walking into it and back out uses native warp handling. Existing cave
  warps and unrelated blocks remain unchanged.
- The registered authored radio sprite renders with native cave/OBJ palettes.
  Its ordinary interaction opens the native text box. Both original English
  before/after messages are selected from saved mod progress. The driver
  changes that progress only in memory and never writes a game save.
- Actor handles support spawn, scripted movement with completion callbacks,
  facing and removal. Scripted movement locks input through `World:busy()`.
  Use native `STANDING_DOWN` (6) for turnable actors; `STILL` (1) deliberately
  fixes facing and is appropriate for the radio, not walking characters.
- Registered `gmarcs_gen2_celebi_time_travel:move`, `:face` and `:wait` commands run inside the
  native VM. Movement waits for its real callback, then facing and waits run
  in sequence. Completion releases the world lock and temporary actors can
  be removed without leaking objects.
- The room renders in native 2D and angled voxel mode. Captures were inspected.
  First-person room presentation and physical Android performance are still
  untested. The new English radio text is not localized yet; Gold's probe
  also ran with GEN2_ES active to check coexistence.

## Reproduction

From the workspace root:

```sh
luajit mods/gen2/celebi_mod/tests/room.lua
luajit mods/gen2/celebi_mod/tests/actions.lua
```

The data test requires all three real decoded caches and fails if absent:

- Gold: `mods/gen2/useful-bag/dist/art-identity/love/bag-art/gold/`
- Silver: `mods/gen2/moveset-plus/dist/variants/love/moveset-silver/silver/`
- Crystal: `mods/gen2/moveset-plus/dist/variants/love/moveset-crystal/crystal/`

For live tests, from `gen1recomp/`, use `POKEPORT_GAME=<edition>`,
`POKEPORT_DRIVER=../mods/gen2/celebi_mod/tests/capabilities.lua`, and an existing
`POKEPORT_SHOT_DIR`. Select the matching isolated identity through
`POKEPORT_IDENTITY` and `XDG_DATA_HOME`. The engine development link is
`mods/celebi_mod`; enable gmarcs_gen2_celebi_time_travel and gmarcs_gen2_voxel_mod. Never point this driver at
the user's real playthrough. It clears first-boot notices, visits the shrine,
walks through the entrance, checks both radio states, tests actor commands and
captures the room in 2D/voxel. Success ends with `CELEBI CAPABILITIES PASS`.

Local inspected captures are under the ignored `dist/<edition>/` folders.

## Phase 2 follow-up

The encounter/catch and native battle-type questions below were subsequently
resolved by the playable mechanics in development 0.0.2. See
`crystal-half.md` for Gold/Silver/Crystal live results and current remaining
work. This file records the earlier room/action milestone.

## Questions left open at the Phase 1 milestone

- Celebi encounter/catch payload, post-battle continuation and no-run behavior.
- Authored Celebi sprite animation and follower attachment/release.
- Giovanni trainer registration, battle start/victory/loss and reward handling.
- Time-travel rendering, actor/camera choreography, interruptions and resume.
- Actual GS Ball registration, delivery gating, Kurt day boundary and conflicts
  with his ordinary Apricorn work/native Crystal event.
- Complete HGSS dialogue verification and localization of new event text.

Do not mark these complete from the room/command probe: it does not exercise
those capabilities or implement the quest.
