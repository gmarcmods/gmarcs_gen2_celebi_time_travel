# Local original Giovanni graphics (0.0.8)

The user explicitly requested both original game sprites saved in mod files,
with edits only if needed. Both PNGs were copied unchanged from the current
validated Red import:

- `assets/giovanni.png`: original six-pose 16x96 overworld sheet.
- `assets/giovanni-battle.png`: original 56x56 trainer front portrait.

`art/giovanni/source.json` records the original paths, hashes and lack of edits.
No ROM file is copied or packaged. This user direction supersedes the earlier
Giovanni-only preference for runtime dataset references / authored fallback.
See `../../THIRD_PARTY_NOTICES.md` for original graphic attribution.

`FieldArt.giovanni` always returns the local mod asset. There is no dataset
lookup or fallback selection. `FieldArt.trainer` registers CELEBI_GIOVANNI with
the local portrait and Nidoking 42, Murkrow 43, Nidoqueen 46 and Kangaskhan 40.
A dedicated pale-skin/brown trainer palette prevents the native intro from
falling back to Nidoking's purple palette; the PNGs themselves stay unchanged.
This prepares the portrait/roster; it does not wire the story battle or its
victory/loss checkpoints into the unfinished historical quest.

The old custom drawing is retained under `art/giovanni-authored/` as a
reference, with no runtime use. The original PNGs can be modified directly in
Pixelorama if later requested; record intentional edits and update hashes.

## Review

The user confirmed the paved gate approach. `tests/review_opening.lua` uses a
disposable Gold identity, plays the current historical opening in voxel mode
with paced automatic dialogue (normal A also works), then creates a real
native battle intro to review the local Giovanni portrait. It leaves that
review session open and never writes a game save. This is a preview of battle
art, not a claim that the story's Giovanni battle is implemented.

`tests/field_art.lua` rejects any runtime dataset access and checks both local
paths and the roster. `tests/giovanni_art.py` checks physical local files,
original hashes, image sizes and six distinct directional/walking poses.
Other relevant scene/follower/motion/source-art checks passed. Gen2check has
no findings and one unresolved module-as-value data-flow note.

The opening was played once in the voxel review. The intro preview was then
reopened directly in native rendering, waiting for its entrance animation
before capture. POKEPORT_REVIEW_PORTRAIT_ONLY=1 skips replaying the opening.
