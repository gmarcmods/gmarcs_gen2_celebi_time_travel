# Scene staging specification

Status: implementation specification, not a claim of reproduced HGSS camera
coordinates. Native Crystal placements are sourced in `reference/`; HGSS
blocking below is a GSC adaptation pending reference captures. Dialogue files
remain the source of words. Record measured durations after the animation
probes; do not confuse invented timing with reference timing.

## Scene runner contract

Every scene owns its temporary actors, input lock, camera/effect overrides and
completion callback. Actions run sequentially unless explicitly grouped.
Movement must wait for the actor's real completion callback; dialogue waits
for native paging; timed effects use fixed logic ticks. No scene progresses
by guessing how many render frames a walk took.

Persist semantic checkpoints, not running coroutines or actors. On load,
rebuild the scene's actors and resume from a documented safe point. Ordinary
visits to each map must preserve its existing events. Only the dedicated
hidden room receives a permanent new object.

## Crystal half

| Scene | Actors and blocking | Dialogue / completion |
| --- | --- | --- |
| Goldenrod delivery | Trigger at either doorway (3,7)/(4,7). Receptionist appears at (0,7), approaches the occupied doorway from its free side; player faces her; she retreats and disappears. Validate paths for both doorway tiles. | `crystal/gs_ball_delivery.md`; checkpoint after successful item delivery, never duplicate the ball. |
| Kurt hand-over | Use the live Kurt object in `KURTS_HOUSE`; freeze ambient movement and face the player. Transfer the ball only after dialogue. | `crystal/kurt_workshop.md` hand-over/same-day states; persist inspection day. |
| Kurt runs out | Surprise emote, exit path around the player's actual position, exit sound, hide Kurt. Walk player out only when the house exit is free. | Workshop later-day text; arm street scene before leaving the house. |
| Azalea street | Player arrives at (9,6); Kurt stands at (6,5). Stage approach, face player for the hand-back, then turn west toward the forest. | `crystal/kurt_restless.md`; checkpoint after ball return. |
| Shrine placement | Read the native bg event (8,22) from (8,23), facing up. Native Yes/No; No leaves the event armed. On Yes, placement text, surprise, player steps away from shrine and faces Celebi. | `crystal/shrine.md`; checkpoint encounter pending before consuming the ball. Exact player path verified against collision. |
| Celebi appears | Authored float-in from shrine, hover/wing loop, encounter cue. Hold input through animation and battle start. | Native wild Celebi level 30; catch result must be settled before continuation. Define loss/escape retry policy before shipping. |
| Kurt congratulates | Enter at (1,24) via the west shrine-clearing path, approach a free square beside the player, deliver congratulations and retrace the path before removal. The original watcher position (8,29) has no walkable route through native foliage in these maps; this is an intentional GSC adaptation. | Shrine congratulations; checkpoint caught and continuation ready. |

## HGSS continuation

The player and Celebi travel alone. Lyra, Ethan, substitute companions and
Marill are excluded. Original HGSS transcripts remain reference material;
short time/location captions replace companion exposition.

| Scene | Actors and blocking | Dialogue / completion |
| --- | --- | --- |
| Shrine start | Require the caught event Celebi as follower. Celebi hops, flashes and circles the player; no companion enters. | `hgss/shrine_start.md`; snapshot the present-day return position. |
| Jump 1 | Lead-in glow/circling → swirl → white-out → map switch → reveal. | Land on `ROUTE_22`; show THREE YEARS EARLIER / KANTO - ROUTE 22. This is three years before the hidden-room scene. |
| Route 22 | Choose a collision-checked staging area away from normal warps/trainers. Player and Celebi arrive together; time/location caption establishes the jump. Shift attention to Silver and the man in black, who face each other. Man leaves first. Silver runs toward player, stops for his line, staggers player sideways and runs off. Celebi signals the next jump. | `hgss/route_22.md`; retain unnamed man until the later reveal. Exact GSC coordinates still need a staging probe. |
| Jump 2 | Reuse transition with its own timing/cues; remove Route 22 scene actors before leaving. | Advance **three years** to the Radio Tower takeover; show THREE YEARS LATER / TOHJO FALLS. |
| Hidden room | Radio at (6,3). Reserve actor slots: Giovanni (6,4), player (6,6), Celebi (7,6). Giovanni turns from radio and approaches player; the broadcast establishes the takeover. Verify all paths with live objects before finalizing. | `hgss/tohjo_falls_hidden_room.md`; broadcast before Giovanni battle. |
| Giovanni battle/exit | Native trainer battle; after victory Giovanni backs away, moves around the group and exits south. Radio continues calling. Persist victory before departure so reload cannot repeat rewards. | Nidoking 42 / Murkrow 43 / Nidoqueen 46 / Kangaskhan 40. Confirm loss/retry and conditional Celebi recovery branch from source script. |
| Return | Celebi activates return; white-out and map change; reveal Ilex at saved return position. Show THE PRESENT / ILEX FOREST; Celebi resumes following. | No partner farewell; mark complete only after return and cleanup. |

## Ordinary hidden-room visits

New room: `CELEBI_TOHJO_HIDEOUT`, 12×10 cells. Entrance prototype: Tohjo
Falls (5,1), reached from (5,2); room exit (7,9). These are authored GSC
coordinates, not HGSS coordinates. Existing Tohjo warps and unrelated blocks
must remain intact. Validate the approach from the original waterfall route.

The room contains only its radio during ordinary exploration. Examining it
from the south uses `hgss/broken_radio.md`, selected by saved event completion.
No Giovanni, scene follower override or time-travel effect may leak into
ordinary visits. The entrance and return warp remain usable afterward.
