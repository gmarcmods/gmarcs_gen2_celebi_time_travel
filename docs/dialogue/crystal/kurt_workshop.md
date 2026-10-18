# Crystal — Kurt's workshop (hand-over, inspection, the ball shook)

Transcribed from the pret Crystal disassembly (`maps/KurtsHouse.asm`; texts
verbatim). Scene runs in Kurt's house in Azalea Town. Three Kurt object
states (`KURTSHOUSE_KURT1` working at the machine / `KURTSHOUSE_KURT2` at the
counter), plus the granddaughter twin object, swap positions via a
`MAPCALLBACK_OBJECTS` callback while `ENGINE_KURT_MAKING_BALLS` is set.

## 1. Hand the ball over

Talk to Kurt while holding the GS Ball (`EVENT_CAN_GIVE_GS_BALL_TO_KURT`).
After the text: `setevent EVENT_GAVE_GS_BALL_TO_KURT`, `takeitem GS_BALL`,
`setflag ENGINE_KURT_MAKING_BALLS`.

| # | Speaker | Line (exact game text) | Context |
| --- | --- | --- | --- |
| 1 | Kurt | `Wh-what is that?` | box 1 |
| 2 | Kurt | `I've never seen one before.` | box 2 |
| 3 | Kurt | `It looks a lot like a # BALL, but it appears to be something else.` | box 3 |
| 4 | Kurt | `Let me check it for you.` | box 4 → ball taken |

## 2. Same-day re-talks (daily flag still set)

While `ENGINE_KURT_MAKING_BALLS` remains set (that whole flag family is
cleared when the day changes — this is the engine-level "wait a day"
mechanic; no Phone call is involved in the vanilla event):

| # | Speaker | Line (exact game text) | Context |
| --- | --- | --- | --- |
| 5 | Kurt | `I'm checking it now.` | repeat visits, same day |
| 6 | Kurt | `Ah-ha! I see! So…` | follow-up box |

## 3. A later day — the ball shook

Talking to Kurt once the daily flag has reset (i.e. on another day):

| # | Speaker | Line (exact game text) | Context |
| --- | --- | --- | --- |
| 7 | Kurt | `<PLAYER>!` | box 1 |
| 8 | Kurt | `This BALL started to shake while I was checking it.` | box 2 |
| 9 | Kurt | `There must be something to this!` | box 3 |

Immediately after: shock emote on Kurt (30 frames), `special FadeOutMusic`,
and Kurt **runs out of his house** (`applymovement …KurtExitHouseMovement`,
or the run-around-the-player variant if the player is in his way; both
end with `playsound SFX_EXIT_BUILDING`, Kurt disappears, `waitsfx`,
`special RestartMapMusic`). The script then
`setevent EVENT_FOREST_IS_RESTLESS`,
`clearevent EVENT_CAN_GIVE_GS_BALL_TO_KURT`,
`clearevent EVENT_GAVE_GS_BALL_TO_KURT`, and arms
`setmapscene AZALEA_TOWN, SCENE_AZALEATOWN_KURT_RETURNS_GS_BALL` so the
street scene fires when the player next exits through the house doorway
(coord event `(9,6)`, see `kurt_restless.md`).

## Granddaughter flavor lines (house state)

| # | Speaker | Line (exact game text) | Context |
| --- | --- | --- | --- |
| 10 | Kurt's granddaughter | `Grandpa's checking a BALL right now.` | while the ball is with Kurt |
| 11 | Kurt's granddaughter | `Grandpa's gone… I'm so lonely…` | after Kurt ran out |
