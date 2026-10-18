# HGSS — Route 22, three years ago (the argument)

Transcribed verbatim from the GameFAQs player transcript ("Celebi Event NA
Version Script", PSI_Ground, Apr 2010). Bold words appear **red** on the DS
screen (`Time Travel`, `Team Rocket`); the GBC text engine has no inline
color — adaptation decision logged in `design/event-flow.md`.

Staging: you, the follower Celebi and Lyra land on **Route 22** (HGSS
`MAP_ROUTE_22`, Kanto — west of Viridian City, at the Tohjo Falls boundary).
Lyra walks around examining while she talks; then the **camera shifts away**
to the rival and "a man in black" further north by the falling-tree/Victory
Road side. Exact blocking positions are part of the screenshot task
(`screenshots/hgss/`).

| # | Speaker | Line (exact game text) | Context |
| --- | --- | --- | --- |
| 1 | Lyra | `Where are we...?` | arrival |
| 2 | —(narration) | *Lyra examines the area* | |
| 3 | Lyra | `Ilex Forest has disappeared! ...THat's not it. It's more like we have been transported somewhere else...? *NAME*, something is strange! I heard the radio mentioning the date from 3 years ago! Is that... What I am looking at... CELEBI? That explains it! CELEBI must have caused all this! My grandpa once told me that CELEBI can travel through time using its mystic power called Time Travel! Celebi must have taken us back in time! Literally!` | bold-red: **Time Travel**; poster typo `THat's` kept |
| 4 | —(narration) | *Lyra walks up* | |
| 5 | Lyra | `*NAME*, there is someone else here besides us! LEt's go find out who!` | poster typo `LEt's` kept |
| 6 | —(narration) | *Camera shifts to Rival and a man in black, music stops* | the argument begins |
| 7 | Rival | `You told me... you were the number one in the world! Are you gonna quit? What are you going to do now?` | |
| 8 | Man | `..............One must acknowledge one's defeat before he can move on... I will go solo...for now...So that one day I will form a stronger organization!` | |
| 9 | Rival | `What aspect of you was number one? Gathering so many only to be defeated by a mere child!` | |
| 10 | Man | `Putting together the potential of many is how you produce a huge power... That's what an organization is... That's the strength of an organization! I failed... to make the best use of my subordinates potential...! But you shall witness one day the revival of me and my Team Rocket!` | bold-red: **Team Rocket** |
| 11 | Rival | `I don't understand you! You don't make any sense!` | |
| 12 | Man | `.......................One day, you will understand.` | |
| 13 | —(narration) | *Man leaves* | |
| 14 | Rival | `I don't want to understand you! I will never become someone like you. A coward when you're alone and acting like a tyrant when you're in front of other cowards! I will become strong! I will become a stronger man all by myself! All by myself!` | his theme starts |
| 15 | —(narration) | *Rival music starts, he runs, and sees you* | |
| 16 | Rival | `...What are you staring at?` | |
| 17 | —(narration) | *Rival kicks you out of the way, continues running, the normal music plays* | this is the player-stagger beat we must stage |
| 18 | Lyra | `Who does he think he is? That was unnecessary! But what were they talking about? The revival of Team Rocket...? They say Team Rocket was removed from the Kanto reigon by a child three years ago. So this really is three years ago!` | `Team Rocket` bold-red again; poster typo `reigon` kept |
| 19 | —(narration) | *Celebi jumps around, it flashes again* | |
| 20 | Lyra | `Oh no! It's happening again...! It's CELEBI's Time Travel!` | bold-red: **Time Travel** |
| 21 | —(narration) | *Celebi flashes, goes through time again* | time jump 2 |

Notes:

- "Rival" = your rival (Silver); "Man" = not named on screen until the next
  scene. GSC adaptation: `SPRITE_RIVAL` is native; the man in black has no
  native field sprite (`SPRITE_ROCKET` is the grunt cloak — see
  `implementation/assets-checklist.md`).
- The name of the boy the man is arguing with is never spoken in this
  scene's dialogue.
