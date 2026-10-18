# Crystal — GS Ball Celebi event (reference breakdown)

**Status: researched and cross-checked.** Primary source: the pret
disassembly of Crystal (`pret/pokecrystal`, mirrored read-only at
`/tmp/pokecrystal` during this research session). This is the *international*
restored event data — Game Freak programmed and translated the event for
international Crystal but left it untriggerable; the Virtual Console release
(2018) activated it, and the JP original reached it through the Mobile
System GB. Where the merged engine's decoded Gold data independently
confirmed something (map ids, script keys, text pointers), it is marked
**[gold ✓]**.

## Trigger path (as coded)

```
GS_BALL_AVAILABLE (delivery gate)          -- VC: cleared after first HoF
        │                                    JP mobile: Pokémon Communication
        ▼                                    Center activity (16 badges required)
[Goldenrod Pokémon Center]                  -- receptionist hands the GS Ball
        ▼
[Kurt's house, Azalea Town]                 -- hand over; it is "checked"
        ▼   (leave; one day must pass)
[Kurt learns the ball shook]                -- next-day scene, Kurt runs out
        ▼
[Azalea Town street]                        -- coord scene: ball returned,
        ▼                                   "ILEX FOREST is restless!"
[Ilex Forest shrine — bg event (8,22), face UP]
        ▼                                   -- "Want to put the GS BALL here?"
[yes → ball placed → Celebi appears]        -- special + loadwildmon CELEBI, 30
        ▼
[wild Celebi battle]                        -- catch → Kurt appears & lets you record the catch
```

`GS_BALL_AVAILABLE` is queried by the **Battle Tower Action** special
(`setval BATTLETOWERACTION_GSBALL; special BattleTowerAction; ifequal
GS_BALL_AVAILABLE`) — a leftover hook of the mobile system used as the
event-availability gate.

## Beat 0 — GS Ball delivery (Goldenrod Pokémon Center)

- Two **coord events** at the entrance tiles `(3,7)` and `(4,7)` of
  `GOLDENROD_POKECENTER_1F`, scene `SCENE_GOLDENRODPOKECENTER1F_GS_BALL`.
- The scene: `SFX_EXIT_BUILDING`; the **Link Receptionist** (dark blue
  palette) object pops in at the PC doorway `(0,7)`, `MUSIC_SHOW_ME_AROUND`
  plays (the PokéCom Center jingle), she walks to the player, hands the
  ball, then walks back to the stairs and disappears.
- Sets `EVENT_GOT_GS_BALL_FROM_GOLDENROD_POKEMON_CENTER` and
  `EVENT_CAN_GIVE_GS_BALL_TO_KURT`; `verbosegiveitem GS_BALL`.

Dialogue (exact):

| # | Speaker | Line |
| --- | --- | --- |
| 1 | Link Receptionist | `<PLAYER>, isn't it? …Congratulations! As a special deal, a GS BALL has been sent just for you! Please accept it!` |
| 2 | Link Receptionist | `Please do come again!` |

## Beat 1 — Kurt inspects the ball (Kurt's house, Azalea Town)

The Kurt object script chain (in order of states):

1. **Hand over** (when `EVENT_CAN_GIVE_GS_BALL_TO_KURT` and the player has
   the ball):

   | # | Speaker | Line |
   | --- | --- | --- |
   | 1 | Kurt | `Wh-what is that? …I've never seen one before. It looks a lot like a # BALL, but it appears to be something else. Let me check it for you.` |

   → `setevent EVENT_GAVE_GS_BALL_TO_KURT`, `takeitem GS_BALL`,
   `setflag ENGINE_KURT_MAKING_BALLS`.

2. **Same-day re-talks** (while `ENGINE_KURT_MAKING_BALLS` is still set —
   `ENGINE_` flags are *daily flags*, cleared at midnight, which is exactly
   the "wait a day" mechanic):

   | # | Line |
   | --- | --- |
   | 2 | `I'm checking it now.` |
   | 3 | `Ah-ha! I see! So…` |

3. **The ball shook** (a *later day*, flag reset):

   | # | Line |
   | --- | --- |
   | 4 | `<PLAYER>! This BALL started to shake while I was checking it. There must be something to this!` |

   Then: emote shock (Kurt, 30 frames), music fades out, Kurt's
   `applymovement` walks him out of the house (`playsound SFX_EXIT_BUILDING`),
   he disappears, `clearevent EVENT_AZALEA_TOWN_KURT`, and
   `setmapscene AZALEA_TOWN, SCENE_AZALEATOWN_KURT_RETURNS_GS_BALL`.
   Kurt's granddaughter meanwhile says `Grandpa's checking a BALL right now.`.

## Beat 2 — Kurt on the street (Azalea Town)

- A coord event at `(9,6)` fires `AzaleaTownCelebiScene` the moment the
  player exits the house: the player is walked out of the house by script.
- Kurt stands at `(6,5)` (`SPRITE_KURT_OUTSIDE`, `EVENT_AZALEA_TOWN_KURT`).

| # | Speaker | Line |
| --- | --- | --- |
| 1 | Kurt | `ILEX FOREST is restless! What is going on?` |
| 2 | Kurt (turns right) | `<PLAYER>, here's your GS BALL back!` ← `verbosegiveitem GS_BALL` |
| 3 | Kurt (turns left) | `Could you go see why ILEX FOREST is so restless?` |

Flags set/cleared here: `setflag ENGINE_FOREST_IS_RESTLESS`,
`clearevent EVENT_ILEX_FOREST_LASS` (a Lass standing near the shrine is
removed), `setevent EVENT_ROUTE_34_ILEX_FOREST_GATE_LASS` (the gate Lass
state changes for the duration of the visit).

## Beat 3 — the shrine (Ilex Forest)

- **bg event `(8, 22)` reading UP** `IlexForestShrineScript`. The same
  tile exists in Gold with a plain jumptext (`45:6989 → "ILEX FOREST"
  "SHRINE… It's in honor of the forest's protector…"`) **[gold ✓]** — the
  engine's own extracted data carries the identical script key and
  text pointer `45:6e11`.
- Gate: `checkevent EVENT_FOREST_IS_RESTLESS` and `checkitem GS_BALL`;
  anything else keeps the vanilla protector text.
- Yes/No scene, exact text:

| # | Speaker | Line |
| --- | --- | --- |
| 1 | —(shrine) | `ILEX FOREST SHRINE… It's in honor of the forest's protector… Oh? What is this? It's a hole. It looks like the GS BALL would fit inside it. Want to put the GS BALL here?` |
| 2 | —(after Yes) | `<PLAYER> put in the GS BALL.` |

- On Yes the script does, in order: `takeitem GS_BALL`,
  `clearevent EVENT_FOREST_IS_RESTLESS`, `setevent EVENT_AZALEA_TOWN_KURT`
  (street Kurt vanishes), `disappear ILEXFOREST_LASS`,
  `clearevent EVENT_ROUTE_34_ILEX_FOREST_GATE_LASS`, insert-ball text,
  `waitbutton` + `pause 20`, emote shock on the **player** (20),
  `special FadeOutMusic`, player `applymovement` steps down and faces DOWN,
  `clearflag ENGINE_FOREST_IS_RESTLESS` (daily now moot),
  `special CelebiShrineEvent`, then the battle.

## Under the hood: `special CelebiShrineEvent` (`engine/events/celebi.asm`)

- The player's shadow OAM is blanked for the duration and rebuilt
  afterwards (the player sprite is restored from scratch at the end);
  the only on-screen actor besides the player is the Celebi anim
  object.
- Loads `gfx/overworld/celebi.2bpp` (16×16, 4 float frames) and cut-grass
  leaf tiles, spawns a **sprite anim object** at `depixel 0, 10, 7, 0`
  (cell `(0,10)` area — the shrine cell), animation `SPRITE_ANIM_FUNC_CELEBI`:
  sine/cosine floating drift with left/right framesets, freezing when a
  height threshold is reached; a 160-frame countdown ends the intro.
- Unreferenced leftovers show a leaf-spawn routine that never made it.
- Ends with `CelebiEvent_SetBattleType`: `wBattleType = BATTLETYPE_CELEBI`.
  `BATTLETYPE_CELEBI` semantics in the battle engine:
  - wild mon **cannot escape** (Run fails),
  - `ForceSwitch`-type effects fail,
  - **catching sets `BATTLERESULT_CAUGHT_CELEBI`** (bit 6) which the
    `CheckCaughtCelebi` special then reads as the script's success signal.

## The battle

- `loadwildmon CELEBI, 30` → `startbattle` → `reloadmapafterbattle`.
- Engine-native Celebi data **[gold ✓]**: dex 251, catch rate 45, growth
  medium-slow, genderless, moves by level 1 Leech Seed/Confusion/Recover/
  Heal Bell, 10 Safeguard, 20 AncientPower, 30 Future Sight — so the level-30
  wild set is **Heal Bell, Safeguard, AncientPower, Future Sight** (GSC roll
  learns 4 by rote-fading). Sun/rain rules do not apply.
- Note for our engine: the `queueScript` wild-battle signature has no
  battle-type argument. Our implemented native-VM scene instead arms
  VAR_BATTLETYPE (0x03) with type 11; running is refused on all three editions
  (see `../implementation/crystal-half.md`).

## Beat 4 — Kurt's congratulations (only on success)

Kurt is present all along as a **hidden object in Ilex Forest at `(8,29)`
standing UP** (`EVENT_ILEX_FOREST_KURT`) — he ran ahead into the forest from
the street scene; he watches the battle from behind, then:

| # | Speaker | Line |
| --- | --- | --- |
| 1 | Kurt | `Whew, wasn't that something! <PLAYER>, that was fantastic. Thanks!` |
| 2 | Kurt | `The legends about that SHRINE were real after all. I feel inspired by what I just saw. It motivates me to make better BALLS! I'm going!` |

(Kurt then walks down and disappears. `DidntCatchCelebi` ends the script
without anything else — the shrine event is consumed,
`EVENT_FOREST_IS_RESTLESS` got cleared just above, so vanilla players can
never re-enter… one more reason the HGSS half needs its own trigger.)

## Flags and events inventory (Crystal, names → engine is numeric)

Used by the vanilla event: `EVENT_FOREST_IS_RESTLESS`,
`EVENT_CAN_GIVE_GS_BALL_TO_KURT`, `EVENT_GAVE_GS_BALL_TO_KURT`,
`EVENT_GOT_GS_BALL_FROM_GOLDENROD_POKEMON_CENTER`,
`EVENT_AZALEA_TOWN_KURT`, `EVENT_ILEX_FOREST_LASS`,
`EVENT_ROUTE_34_ILEX_FOREST_GATE_LASS`, `EVENT_KURT_GAVE_YOU_LURE_BALL`
(Kurt's own plot line — beware interplay), plus daily
`ENGINE_KURT_MAKING_BALLS`, `ENGINE_FOREST_IS_RESTLESS`. The merged engine
carries flags as **numeric `wEventFlags` ids** (`clearevent 723 …` shapes
appear in the engine's own extracted scripts) **[gold ✓]**; the numeric ids
for Crystal differ per edition and must be looked up edition-by-edition.

## What the merged engine already has (verified)

- Gold's `ILEX_FOREST` map, the shrine bg event at `(8,22)` and its vanilla
  text **[gold ✓]**.
- The whole event *data* (scripts, texts, items) is Crystal-edition data:
  none of it is reachable from the merged engine's registries today —
  `map_scripts` has no Gen 2 home. Everything must be re-authored by the
  mod (see `implementation/engine-integration.md`).
- `GS_BALL` **does not exist in the merged engine's Gold item data** — the
  Crystal item was left out of Gold's ROM. The mod must decide: register an
  authored item through the `items` registry (faithful) or hold the "ball
  state" in mod state (lighter). Logged in `design/event-flow.md`.

## Open verifications

- [ ] Confirm against `references/pokegold-es/` where the Spanish source
      overlaps (Gold-only; Crystal event is not in it — mark as
      un-verifiable from that repo).
- [ ] Silver/Crystal caches not yet imported in the workspace decode identity;
      any per-edition offsets/ids must be probed once each cache exists.
- [ ] The Route 34 gate Lass's exact role during the event (block vs cosmetic).
