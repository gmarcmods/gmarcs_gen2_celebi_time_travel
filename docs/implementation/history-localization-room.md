# Historical scenes and localization — 0.0.9

The upper-path GSC adaptation uses player (31,8), Celebi (30,8), rival
(31,4) and Giovanni (29,4). All movement routes are checked against native
Gold, Silver and Crystal collision maps. GSC's gate faces south; HGSS's gate
faces west. The man leaves along the upper path rather than walking through
the GSC gate roof. Silver passes the player and heads toward Viridian.

`HistoryText.lua` labels the rival with the native `{RIVAL}` token. It is
resolved from the save at display time, never hard-coded to SILVER. The man
is MAN/HOMBRE until the radio identifies Giovanni. Every explicit dialogue
page retains its speaker prefix. Long paragraphs still wrap in native boxes.

`HideoutScene.lua` stages Giovanni by the radio, plays the warning,
recognition, Rocket broadcast and challenge. It yields a native scripted
trainer battle using the bundled Red portrait, dedicated palette and the
Gen 2 substitute Murkrow. Only a real win plays defeat text and his departure,
then the continuing radio and return trip. Loss retains native whiteout and
never sets `eventComplete`. Completion is stored under the white return
frame. Ordinary room visits show the appropriate broken-radio examination
text and never spawn historical actors.

Since 0.0.13, `Text.lua` registers stable English `gmarcs_gen2_celebi_time_travel:<id>` records
and reads the merged official Gen 2 `text` registry at display time. Spanish
is owned by `GEN2_ES/companions/celebi.lua`, loaded after the optional quest.
There are no language flags or Spanish dictionaries in the quest. The central
catalog covers the Crystal quest, solo captions, argument, Giovanni,
broadcast, both radio states and Gold/Silver's new GS BALL description.
Crystal retains its native item and original Spanish catalog description.
Speaker labels repeat on every native two-line page via a scoped VM overlay,
restored on normal completion, errors, save changes and script end.
Every missing/empty Spanish entry falls back to English without a dependency
on the Spanish mod. Spanish is an authored event adaptation; the original
English source transcripts remain unmodified in `docs/dialogue/hgss`.

The hidden room declares `map.def.voxelShapes`, consumed by the voxel
runtime's `TileShape.at`. This replaces shared cave-tile assumptions only
for this new map: walkable cells remain at height zero, solid cells form
24-pixel rock walls, and out-of-map cells are empty. Native solid boundary blocks close the northern edge; the floor uses flat
native cave blocks. Tile 16 stays empty, and this room opts out of automatic
boulder matching and procedural cave caps so they cannot replace its walls.
No authored asset data or existing-map collision is changed. Native 2D ignores the metadata.

Run `tests/route22.lua`, `tests/room.lua`, `tests/hideout.lua`,
`tests/localization.lua`, and the runtime `tests/test_mod_map_shapes.lua`.
`tests/history_live.lua` uses disposable identities, actually fights Giovanni,
asserts victory/return, checks localized radio interaction and captures
native/voxel frames. It changes test party and progression but never saves.
Natural historical activation is implemented in 0.0.10. Read the shrine
with a healthy Celebi follower after Kurt's congratulations. Exhaustive
interruption/resume hardening remains separate development work. This is not yet a release ZIP.
