> Updated in 0.0.11: [continuous catch-to-history](continuous-catch-to-history.md)
> supersedes the earlier manual shrine trigger and full-party PC behavior below.

# Normal lifecycle and Crystal replacement — 0.0.10

## Normal activation

The original mod quest begins after the Hall of Fame, on attempting to leave
Goldenrod's Pokémon Center. Kurt takes the GS BALL, checks it until the next
day, physically leaves his workshop, and returns it during the Azalea street
scene at (9,6). The Ilex shrine offers Yes/No, consumes the ball only on Yes
and starts the native no-run Celebi 30 encounter. Catching it settles the
quest and brings Kurt into the clearing for congratulations. A full-party
catch goes to the native PC and must be withdrawn before it can follow.

After congratulations, put a healthy Celebi first and examine the shrine
from (8,23), facing up. The native shrine interaction runs the full history,
not a separate development command. No partner is spawned. Victory over
Giovanni returns the party to Ilex (8,23), resumes the follower and sets
`eventComplete` only under the return's white frame. Completed shrine reads
use ordinary shrine text. Native whiteout still owns losses; no victory text
or completion is granted, and the shrine can be retried later.

## Permanent exploration and radio

The earlier entrance at (5,1) was on a disconnected native upper ledge.
The permanent entrance is now (3,5), above the left alcove, using native cave
block 55. Both Route 27 entrances connect to its approach with Surf. Tests
check real collision data in all three editions and preserve all other cave
blocks and warps. Entering and leaving use actual native door warps. Ordinary
visits contain only the radio, with no Giovanni or time-travel sequence.

Before victory/return: `There is a radio that no longer works...`
After: `You cannot turn on the radio.` / `Giovanni must have left it here...`
The Spanish catalog gives the corresponding broken-radio descriptions.
The saved completion state chooses the text independently of map visits.

## Crystal replaces the original event

`CrystalReplacement.lua` only runs for Crystal. It removes the two original
Goldenrod delivery coord events and the original Azalea (9,6) GS Ball coord
event. Unrelated Slowpoke Well scenes, map callbacks and Apricorn work stay.
In native Kurt scripts only reads of GS Ball flags 190/191/192 return false;
no native saved flag is changed. Native outside/watcher Kurt actors are moved
offscreen in the live map so only the mod's scene actors appear. Original
object definitions and persistent masks are preserved.

The mod intercepts the native shrine in every mod quest phase, including
unarmed and completed states. Crystal's original shrine script cannot also
consume the ball, call its unsupported original special or start a second
encounter. Gold/Silver retain their own maps and native item numbering.

## Verification

Headless: `tests/crystal_replacement.lua`, `tests/quest.lua`, `tests/room.lua`.
`tests/lifecycle_live.lua` chains ordinary entrance/exit and pre-event radio,
real Goldenrod/Kurt/shrine/catch/follower interactions, then normal shrine
activation, real Giovanni combat, exact Ilex return coordinates, party member
preservation, completion serialization, no-replay shrine and post-event radio.
Crystal's test also arms the old native GS Ball flags to detect overlap.
The drivers use disposable imported identities and never write a save.

Desktop lifecycle results (2026-10-17):

| Edition | Language | Result |
| --- | --- | --- |
| Gold | GEN2_ES Spanish | Ordinary entrance/exit, full Kurt/catch flow, natural history, real Giovanni win, exact Ilex return, party preservation and completed radio passed. |
| Silver | English without GEN2_ES | Same complete lifecycle passed, including English fallback. |
| Crystal | GEN2_ES Spanish | Same lifecycle passed with old native GS Ball flags armed; full-party Celebi capture went to PC and was withdrawn before following. Original delivery/street triggers were absent. |

Native event removal is tested through the engine's actual Merge.deepMerge:
empty `{}` does not replace a list, so the all-removed center list uses the
SDK DELETE sentinel. The surviving Azalea Slowpoke Well triggers stay intact.
Native and voxel entrance captures were inspected in Crystal. The authored
voxel profile retains its original SHA256.

Physical Android and exhaustive forced interruption tests are not claimed.
