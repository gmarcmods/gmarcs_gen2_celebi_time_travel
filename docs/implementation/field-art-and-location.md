# Field art and Route 22 placement (0.0.7)

## Celebi

Compared the supplied Wilds library's GSC / Poke Followers sheet and its
separate HGSS/PokeMMO sheet against the earlier authored drawing. Selected
`assets/enhanced_overworld/poke_followers/follower_251_normal.png`: it fits
the native GSC scale/style and includes six distinct native poses.

`art/celebi/sprite.json` preserves the exact source silhouettes, frame order
and colors. The shipped PNG encodes opaque colors as native shades 170/85/0;
`FieldArt.celebiColors` maps them back to the original pale/green/black palette.
Transparent RGB is normalized. No resizing, recropping or independent frame
redrawing is done. Existing hover, wing/step and follower behavior remains.
`tools/draw_celebi.py` now rebuilds this maintained source and cannot silently
regenerate the superseded drawing. The earlier drawing remains in Git history.

See `../../THIRD_PARTY_NOTICES.md` for source attribution. The supplied pack's
GSC artwork is not relabeled as our original art or assigned a new license.
The separate HGSS and PMDCollab sheets were inspected/identified but not used.

## Giovanni

`FieldArt.giovanni` tries the public read-only datasets API for Red, Blue,
then Yellow. It uses the native SPRITE_GIOVANNI six-frame walker in place,
removing Gen 1 metadata when constructing the Gen 2 sprite registry record.
The native brown object palette gives it GSC-compatible colors. No ROM bitmap
is copied to this repository or any exported ZIP.

Missing, stale or invalid imports retain the existing authored fallback. A
Gen 1 import is optional, and Wilds is not a runtime dependency. Source
telemetry is exported as `fieldArt.giovanniSource` for development checks.

## First flashback location

The previous eastern grass placement was selected for collision convenience,
not faithful staging. The opening now uses the paved approach immediately
below the native GSC gate: player (14,11), Celebi (13,11), Silver (14,8),
Giovanni (12,8). Silver approaches (14,10), pushes the player to (15,11), then
uses the existing native south ledge at (20,12) to depart toward Viridian.
Celebi begins its next orbit from the player's left, preserving its position.

This is a GSC layout adaptation, not identical HGSS coordinates. The HGSS
reference's gate entrance has two vertical warp cells at the same X; GSC's
single door is at (13,5), with its approach to the south. The adaptation rotates
the scene to fit that geometry. The question asking the user to confirm this
specific gate clearing remained unanswered during implementation; it must not
be treated as user confirmation of the exact desired spot.

Sources checked:

- [HGSS Route 22 script](https://github.com/pret/pokeheartgold/blob/master/files/fielddata/script/scr_seq/scr_seq_0212_R22.s)
- [HGSS Route 22 events](https://github.com/pret/pokeheartgold/blob/master/files/fielddata/eventdata/zone_event/024_R22.json)
- [Event reference](https://www.serebii.net/heartgoldsoulsilver/celebi.shtml)

## Verification

- Headless art/source equality checks, optional imported-data selection and
  fallback checks, actor/motion/follower/quest checks passed.
- Route 22 movement paths pass all three editions' actual collision data.
- Relocated complete history opening passed Gold native and voxel live runs
  using the authored fallback (the first Red cache was correctly rejected as
  stale). A separate live probe with a current Red cache verified original
  Giovanni, the GSC Celebi palette and both native/voxel rendering.
- Captures under ignored `dist/travel-gold/` were inspected. The imported-data
  API emits an engine adapter diagnostic for FieldDefaults.seed while hydrating
  Red; the sprite record and actual rendering were verified independently.
- No authored voxel data or engine files changed. Silver/Crystal paths were
  checked headlessly; the relocated scene was not rerun live on those editions.

Use `tests/field_art_live.lua` in a disposable identity containing a current
Red import and Gold data for the native/voxel sprite check. The driver never
writes a game save. Story activation/battle/resume work remains as before.
