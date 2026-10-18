# HGSS — Tohjo Falls hidden room (Giovanni + radio + battle)

Transcribed verbatim from the GameFAQs player transcript ("Celebi Event NA
Version Script", PSI_Ground, Apr 2010). Bold words appear red on screen.

Staging: the second time jump lands in the cave-like **hidden room off
Tohjo Falls** (HGSS `MAP_TOHJO_FALLS_HIDDEN_ROOM`, map 298). **Giovanni
stands by a radio box**; the Team Rocket theme plays once the broadcast
starts. After the battle Giovanni walks off; the radio keeps talking.

The battle is a **trainer battle against Rocket Boss Giovanni**:
Nidoking 42, Honchkrow 43, Nidoqueen 46, Kangaskhan 40 (Serebii). Note
Honchkrow does not exist in Gen 2 — substitution logged in
`design/event-flow.md`.

| # | Speaker | Line (exact game text) | Context |
| --- | --- | --- | --- |
| 1 | —(narration) | *You appear in a cave, the man and a Radio are in there* | arrival |
| 2 | Man | `...I don't know why you have come here. Anyway, I have to warn you that this is not a place for kids like you.` | |
| 3 | Lyra | `Huh? That's the guy we just saw arguing with that boy!` | |
| 4 | Man | `You have a certain look... It reminds me of the kid who stood in front of my three years ago... You have the same eyes... .... I'm on my way to Goldenrod City to answer the call and join my team. Are you going to get in my way?` | "the kid… three years ago" = Red, from his perspective |
| 5 | Lyra | `Three years ago...? Goldenrod City...? Could this be the one that the radio was trying to reach? Giovanni, their boss? Do you hear it, Ian? The radio is saying something strange! Team Rocket has occupied the Radio Tower at Goldenrod City! It can't be! Ian, you solved this case already!` | `Team Rocket` bold-red. "Ian" appears twice — likely the transcript poster's own player name where the game substitutes it; other player mentions are `*NAME*`. Verify against a second transcription (open item, reference/hgss-celebi-event.md). |
| 6 | —(narration) | *Team Rocket theme plays* | |
| 7 | Radio | `...This is the Radio Tower. This is the Radio Tower. We are pleased to declare Team Rocket's revival. ...Giovanni? ...Can you hear us? We have finally made it!...` | the Archer broadcast |
| 8 | Giovanni | `My old associates need me... We will not repeat the failure of three years ago! Team Rocket will be born again, and I will rule the world!` | bold-red: **Team Rocket**; battle starts |
| 9 | —(narration) | *Battle* | Rocket Boss Giovanni (see staging note above) |
| 10 | Giovanni | `What are you? How can an unexperienced kid be this good?` | last Pokémon down (poster typo `unexperienced` kept) |
| 11 | —(narration) | *Win* | |
| 12 | Giovanni | `What in the world are you?` | victory screen text |
| 13 | Giovanni | `How is this possible...? The past three years have been a waste...? How can a kid like you manage to destroy my team again? The precious dream of Team Rocket has become little more than an illusion...` | after the battle closes |
| 14 | —(narration) | *Giovanni leaves* | |
| 15 | Radio | `... ...Hey! Where has Giovanni gone? I wonder if he is listening to our broadcast... ...` | |
| 16 | Lyra | `They keep calling for their boss. I feel sorry they don't know he's not coming. After this, *NAME*, you will defeat them! ...Wait a second! Ian, you're still here. Then, who will defeat Team Rocket...?` | second `Ian` occurrence; same caveat |
| 17 | —(narration) | *Celebi flashes* | |
| 18 | Lyra | `Not again...! I've had enough! Please let me go back to my time!` | |
| 19 | —(narration) | *Celebi teleports you* | return jump |

Notes:

- If the player *loses* the battle, the usual whiteout happens and the event
  does not close (screenshots task: capture the loss-state behavior).
- The battleHUD "trainer class/name" presentation uses the Rocket boss
  identity only here; in the Route 22 scene he is never named.
