# Crystal — the shrine (placing the GS Ball, Celebi, Kurt's congratulations)

Transcribed from the pret Crystal disassembly (`maps/IlexForest.asm`; texts
verbatim). The shrine is a **bg event read facing UP at `(8,22)`** in Ilex
Forest — not an NPC object. The same bg-event slot and base text exist in
Gold with the plain protector text (`45:6989 → 45:6e11` in the engine's
extracted data).

## 0. Vanilla text when the event is not active

`IlexForestShrineScript` first checks `EVENT_FOREST_IS_RESTLESS` and
`checkitem GS_BALL`; otherwise it just plays:

| # | Speaker | Line (exact game text) | Context |
| --- | --- | --- | --- |
| 1 | —(shrine) | `ILEX FOREST SHRINE… It's in honor of the forest's protector…` | idle read (`Text_IlexForestShrine`) |

## 1. Active event read (Yes/No)

| # | Speaker | Line (exact game text) | Context |
| --- | --- | --- | --- |
| 1 | —(shrine) | `ILEX FOREST SHRINE… It's in honor of the forest's protector…` | boxes 1–2 (`Text_ShrineCelebiEvent` is one block with paras) |
| 2 | —(shrine) | `Oh? What is this?` | box 3 |
| 3 | —(shrine) | `It's a hole. It looks like the GS BALL would fit inside it.` | boxes 4–5 |
| 4 | —(shrine) | `Want to put the GS BALL here?` | box 6 → `yesorno` |

On **No**: `closetext; end` (event stays armed).

## 2. On Yes — the placing cutscene

Order of operations in the script: `takeitem GS_BALL`,
`clearevent EVENT_FOREST_IS_RESTLESS`, `setevent EVENT_AZALEA_TOWN_KURT`
(street Kurt vanishes), `disappear ILEXFOREST_LASS` (the shrine-side Lass),
`clearevent EVENT_ROUTE_34_ILEX_FOREST_GATE_LASS`, then:

| # | Speaker | Line (exact game text) | Context |
| --- | --- | --- | --- |
| 5 | —(narration) | `<PLAYER> put in the GS BALL.` | box, `waitbutton` (`Text_InsertGSBall`) |

Then: `pause 20`, shock emote on the **player** (20),
`special FadeOutMusic`, the player `applymovement` steps down toward the
shrine and turns DOWN, `pause 30`, `pause 20`,
`clearflag ENGINE_FOREST_IS_RESTLESS` (daily), `special CelebiShrineEvent`.

`CelebiShrineEvent` (engine/events/celebi.asm): blanks the player's shadow
OAM, spawns the floating Celebi anim object (`gfx/overworld/celebi`, 16×16
frames) drifting sine/cosine around the shrine, ends after a 160-frame
countdown; then sets `wBattleType = BATTLETYPE_CELEBI`.

## 3. The battle

`loadwildmon CELEBI, 30; startbattle; reloadmapafterbattle`. No unique
intro text — the wild-battle standard (`Wild CELEBI appeared!` etc.)
applies; see `celebi_battle.md`.

## 4. If the player did not catch Celebi

`iffalse .DidntCatchCelebi` — nothing else happens; the script's
restless/flag state was already consumed above.

## 5. Kurt's congratulations (caught only)

A hidden Kurt object stands in Ilex Forest at `(8,29)` facing UP
(`EVENT_ILEX_FOREST_KURT` — he came ahead into the forest). On success the
script `appear`s him, he `applymovement` steps toward the player
(`IlexForestKurtStepsUpMovement`), says this, then steps away and
disappears:

| # | Speaker | Line (exact game text) | Context |
| --- | --- | --- | --- |
| 6 | Kurt | `Whew, wasn't that something!` | box 1 |
| 7 | Kurt | `<PLAYER>, that was fantastic. Thanks!` | box 2 |
| 8 | Kurt | `The legends about that SHRINE were real after all.` | box 3 |
| 9 | Kurt | `I feel inspired by what I just saw.` | box 4 |
| 10 | Kurt | `It motivates me to make better BALLS!` | box 5 |
| 11 | Kurt | `I'm going!` | box 6 → walks off, event over |

## Shrine-side Lass (flavor, removed during the event)

Standing at `(3,24)`, `jumptextfaceplayer`:

| # | Speaker | Line (exact game text) | Context |
| --- | --- | --- | --- |
| 12 | Lass | `Did something happen to the forest's guardian?` | idle read (`Text_IlexForestLass`); she disappears when the placing starts |
