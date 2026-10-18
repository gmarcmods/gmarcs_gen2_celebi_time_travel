# Crystal — Kurt on the street ("ILEX FOREST is restless!")

Transcribed from the pret Crystal disassembly (`maps/AzaleaTown.asm`; texts
verbatim). Vanilla has **no phone call** in this beat: Kurt physically runs
out of his house and waits on the street, and the scene fires the moment the
player steps out of the house — a coord event at `(9,6)` under scene
`SCENE_AZALEATOWN_KURT_RETURNS_GS_BALL`.

Staging: the player is walked out of the house (`applymovement`); Kurt is an
outside object `AZALEATOWN_KURT_OUTSIDE` standing on the street
(he faces the player). After the text Kurt turns LEFT (toward Ilex Forest,
i.e. west) — visually "go on ahead" — and stays gone from the street after
the shrine scene begins. During the event the Route 34/Ilex gate Lass state
is also swapped (`setevent EVENT_ROUTE_34_ILEX_FOREST_GATE_LASS`).

| # | Speaker | Line (exact game text) | Context |
| --- | --- | --- | --- |
| 1 | Kurt | `ILEX FOREST is restless!` | box 1 |
| 2 | Kurt | `What is going on?` | box 2 |
| 3 | Kurt (turns RIGHT) | `<PLAYER>, here's your GS BALL back!` | box 3 → `verbosegiveitem GS_BALL` |
| 4 | Kurt (turns LEFT) | `Could you go see why ILEX FOREST is so restless?` | box 4; then `setflag ENGINE_FOREST_IS_RESTLESS`, `clearevent EVENT_ILEX_FOREST_LASS`, `setevent EVENT_ROUTE_34_ILEX_FOREST_GATE_LASS`, scene cleared |
| 5 | Kurt (re-talk) | `Could you go see why ILEX FOREST is so restless?` | same text repeats if talked to |

Note for the recreation: the roadmap's "Kurt calls you" idea is an HGSS/
phone-inspired replacement, not vanilla Crystal behavior. Vanilla delivers
the callback by movement + coord event. If we keep a `phone_contacts`-based
call, that is a design substitution (log in `design/event-flow.md`).
