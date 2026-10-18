# Solo time-travel foundation (development 0.0.5)

Confirmed adaptation: no Lyra, Ethan, substitute partner or Marill. Original
HGSS transcripts remain research; companion exposition must not enter runtime.
Keep Silver/Giovanni and the radio. Use concise time/location narration.

## Implemented

- `TimeTravel.lua`: 144 fixed logic ticks, bounded twelve-arm pixel swirl,
  white-out, public-API warp while fully white, hold and reveal. The native VM
  owns input locking. The effect draws through `render.hud` in native/voxel
  views, without textures, shaders or offscreen canvases, and draws nothing idle.
- Saved `travelPending` destination: after an interrupted departure a fresh
  native VM rebuilds the transition. Load cleanup cancels stale coroutines;
  recovery attempts once per load rather than looping on failures. This is
  transition recovery, not full historical-story resume support.
- `CelebiMotion.lua`: visual fixed-tick orbit preserves logical cell coordinates
  and restores visual positions on detach.
- `ShrineScene.lua`: requires the eligible Celebi follower at the shrine,
  suspends the trail, animates Celebi circling alone, travels to Route 22, and
  shows `THREE YEARS EARLIER... / KANTO - ROUTE 22.` as native narration pages.
  Destination Celebi spawns under white. Cleanup removes temporary actors and
  motion, and releases follower suspension.
- Text records for `THREE YEARS LATER... / TOHJO FALLS` and
  `THE PRESENT... / ILEX FOREST` are prepared; later scenes do not yet use them.

The opening is a development VM command (`CELEBI_MOD:shrineJump`), not an
ordinary shrine trigger. It currently ends after the first-arrival caption.
The Route 22 argument, story checkpoints, Giovanni battle and final return
must precede enabling normal activation. No authored voxel data or engine
files changed.

## Verification

Headless `travel.lua`, `shrine_scene.lua`, `motion.lua`, `follower.lua`,
`quest.lua`, `progress.lua`, `paths.lua`, `actions.lua`, `room.lua`, `item.lua`
and Python `art.py` passed. The scene test rejects any spawned sprite other
than Celebi, and checks one arrival caption without companion dialogue.
Decoded maps validate the arrival cells on all three editions.

Desktop Gold live `travel_live.lua` exercised all three jumps in native/voxel
modes. `shrine_live.lua` exercised the solo opening in both views, caption
text, cleanup and pending-transition recovery. Loaded products included
CELEBI_MOD, NEW_MOD_EX and GEN2_ES. Captures under ignored `dist/travel-gold/`
were inspected. New narration is English and not yet translated.

Silver/Crystal live cinematic runs, first-person captures, physical Android,
full cinematic save/reload and interruption coverage remain outstanding.
Prior Crystal-half three-edition checks are documented separately.

## Reproduce safely

Use an isolated identity with imported edition data and CELEBI_MOD/NEW_MOD_EX
enabled. From `gen1recomp/`, set `POKEPORT_GAME`, `POKEPORT_IDENTITY`,
`XDG_DATA_HOME`, `POKEPORT_SHOT_DIR`, and
`POKEPORT_DRIVER=../mods/gen2/celebi_mod/tests/shrine_live.lua`, then run `love .`.
The driver changes disposable progression/party in memory and never saves;
do not use a real playthrough. Source transcripts stay untouched.
