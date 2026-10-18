# Historical sequence — development 0.0.9

`CELEBI_MOD:historyOpening` plays the solo shrine departure, upper Route 22
argument and movements, second jump three years forward, hidden-room radio
and Giovanni conversation, native boss battle, victory departure and return.
Ordinary shrine activation and full interruption/resume hardening remain
separate development work. No partner actor or replacement exposition exists.

Route 22 blocking: player (31,8), Celebi (30,8), rival (31,4), man (29,4).
Giovanni walks west to (18,4); GSC's south-facing gate cannot reproduce HGSS's
west-facing doorway without walking through its roof. The rival approaches
(31,7), pushes the player to (32,8), then exits toward Viridian (39,16).
Celebi approaches (33,8) before orbiting. The earlier gate/ledge staging is
superseded. All paths and occupancy checks use native maps from all editions.

The saved rival name and MAN/HOMBRE prefixes identify speakers on every
native text page. The radio reveals Giovanni's identity before the challenge.
English and Spanish catalogs, battle outcome handling and room geometry are
explained in [history-localization-room.md](history-localization-room.md).
Original Red Giovanni field and battle assets are bundled locally; see
[giovanni-local-art.md](giovanni-local-art.md). The source HGSS transcript
remains unmodified reference material, not a claim that every adapted line
is an exact cartridge transcription.

## Verification

`tests/route22.lua`: real Gold/Silver/Crystal collisions, actor placement,
argument order, player stagger, safe departures and second jump.
`tests/hideout.lua`: broadcast/reveal order, actual native battle request,
victory-only dialogue/completion/return and native loss ownership.
`tests/localization.lua`: complete catalog coverage, runtime rival naming,
per-page labels, Spanish opt-in, missing/empty entry fallback and VM overlay
restoration after errors/load. Existing quest, shrine, field-art, follower,
travel, motion, progress, path, action and item tests pass.

Desktop live runs of `tests/history_live.lua` passed Gold native/voxel with
GEN2_ES, Silver voxel without GEN2_ES (English fallback), and Crystal voxel
with GEN2_ES. These runs actually fought and defeated Giovanni, returned to
Ilex, resumed the follower and examined the completed radio. Gold room-only
frames were inspected in native, angled, first-person and third-person views
using `tests/room_live.lua`, with Johto in First Person enabled. The final
room geometry opts out of native cave asset matching and procedural caps;
other authored maps retain both.

Captures are ignored under `dist/travel-<edition>/`. Drivers change only
isolated test parties/progression and never save. Physical Android, exhaustive
interruption cases and normal historical shrine activation remain unverified
or pending; this is not a release ZIP.
