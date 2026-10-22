# Kurt's Azalea street scene

Kurt appears on the accessible road at `(6,8)`. The scene finds a route to a
cell beside the player before showing the restless forest / GS Ball dialogue.
If the key-item bag is full, the scene keeps Kurt on the street and preserves
the quest state so the player can make room and try again.

After the GS Ball is handed back and the player advances through the
`goForest` dialogue, Kurt walks toward the Azalea gate to Ilex Forest. His
route ends at the verified `ILEX_FOREST_AZALEA_GATE` warp at `(2,10)` or
`(2,11)`, faces left, pauses for 12 frames at the doorway, then removes the
actor.

The old spawn at `(6,5)` is isolated from the road by a ledge and wall. The
house door at `(9,5)` is also unreachable while the player occupies `(9,6)`;
the other adjacent cells are blocked. `Path.find` therefore accepts an
optional `allowGoal` callback for a requested terminal warp only. This does
not permit crossing intermediate walls, and the scene still treats NPCs and
the player as blocked cells.

`tests/kurt_street.lua` covers the street interaction, `tests/paths.lua`
checks native Gold, Silver and Crystal collision routes, and `tests/quest.lua`
checks quest behavior. `tests/kurt_street_live.lua` passed in a disposable English Silver identity
using a fresh native cache: adjacency, actual GS Ball delivery, visible walking
and removal only at the forest gate were checked. Gold/Crystal use the same
scene logic; their native collision routes passed the offline test.
