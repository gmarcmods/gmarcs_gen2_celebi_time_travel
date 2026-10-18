# Historical opening (development 0.0.6)

This implements the solo Route 22 chapter and second jump. It does not enable
ordinary shrine activation. The Giovanni battle, story-level save/resume
checkpoints and final return are still required.

## Behavior

`CELEBI_MOD:historyOpening` runs the solo shrine/orbit/first jump, then stages
Silver and the unnamed man under white before Route 22 reveals. Current staging (0.0.7): player (14,11),
Celebi (13,11), Silver (14,8), and man (12,8) all fit near the native camera.
No camera override is necessary for this GSC adaptation.

`HistoryText.lua` takes only rival/man lines from the recorded HGSS Route 22
transcript, with native paging. No companion, legend speech or replacement
exposition is added. Giovanni is not named in this chapter's displayed text.
The source transcript and its uncertainties remain unchanged; a second-source
text verification is not claimed.

After the argument:

1. Giovanni follows a collision-checked path to the native gate door (13,5)
   before removal; he does not vanish from the clearing.
2. Silver rejects him, approaches (14,10), and delivers the stare line.
3. A real native scripted step pushes the player to (15,11), after verifying
   walkability and occupancy. The script waits for actual movement completion.
4. Silver runs to (20,12), takes the native south-ledge jump to (20,14), and
   follows a path to the Viridian-side boundary (39,16) before removal. The
   starting ledge must face south; the wall below is not an ordinary walk.
5. Celebi approaches the orbit's start before circling, avoiding a visual snap,
   then jumps to the radio room (6,6). The chapter ends on
   `THREE YEARS LATER... / TOHJO FALLS.`

Actors belong to the enclosing ShrineScene scope. Movement waits for native
callbacks, with timeouts and cancellation checks. Appearance/motion detaches
even after map changes. Cleanup releases follower suspension on completion
or errors. Source maps and unrelated native story flags are not edited.
The development sequence does not set final completion or change the normal
broken-radio text.

## Original field art

`art/giovanni-authored/sprite.json` is original layered GBC-scale art: dark overcoat,
broad shoulders, brown fedora and stern eyes. Head/hat cels are shared by
walking poses. Six 16x16 poses use the native brown/skin/black object palette.
`assets/giovanni.png` is the exact native fallback export; 0.0.7 prefers
the original sheet through a validated imported Gen 1 dataset when available. No extracted source bitmap
or Rocket grunt substitution is used. Version 0.0.8 stores both original Red overworld/battle PNGs in the mod
at the user's request; this authored drawing is now development reference only.

From the workspace root:

```sh
python3 workspace/tools/sprites.py build mods/gen2/celebi_mod/art/giovanni-authored/sprite.json --out mods/gen2/celebi_mod/dist/art/giovanni
python3 mods/gen2/celebi_mod/tests/giovanni_art.py
luajit mods/gen2/celebi_mod/tests/route22.lua
```

Pixelorama can edit the generated master; reconcile visual changes with the
JSON before replacing the shipped sheet. Contact sheets and in-game captures
were inspected. All authoring uses free open-source local tools.

## Verification

`tests/route22.lua` checks actual map/collision data from all three editions:
argument order, gate exit, stagger, ledge, eastward exit, Celebi approach and
second jump. `tests/shrine_scene.lua` verifies continuation ordering and
cleanup on errors. Existing quest/progress/item/room/action/path/follower/
motion/art checks pass.

`tests/history_live.lua` uses real input, native VM dialogue and movement in
disposable profiles. Gold native/voxel, Silver native and Crystal native runs passed. It checks temporary actor cleanup, resumed
following, unfinished quest state and normal radio interaction afterward.
Gold includes GEN2_ES; new quest text remains English. Gen2check has no
findings, with one unresolved module-as-value data-flow note at main.lua.

Captures are under ignored `dist/travel-<edition>/`. These are desktop results;
first-person framing, physical Android, full story save/reload and exhaustive
interruption coverage are outstanding. The driver changes disposable party
and progression in memory and never saves; do not run it on a real playthrough.
