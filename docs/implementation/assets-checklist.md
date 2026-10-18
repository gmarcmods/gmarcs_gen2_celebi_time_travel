# Asset inventory

What this mod needs, split by **exists natively in the GSC engine data** vs
**must be authored by the mod**. Fill the table as Phase 0 research
progresses; every row eventually cites evidence (map id, registry probe, a
screenshot, or the engine docs that guarantee it).

## Sprites / actors

| Need | Exists natively? | Evidence / notes |
| --- | --- | --- |
| Celebi (dex 251) front/back, icon | Expected yes (Gen 2 dex includes 251) | verify in all three editions |
| Giovanni (Rocket boss) field + battle sprite | Expected yes | verify per edition |
| Persian field/battle sprite | Expected yes | verify per edition |
| Kurt field sprite | Expected yes | verify |
| Shrine object / shrine tile art | Expected yes (Ilex Forest shrine is native) | verify exact map/tiles |
| Partner walker sprite (Lyra/Kotone) | **No native GSC counterpart** | decide in design/; sprite authoring vs reuse |
| Forest trainer NPCs (past-scene extras) | Native trainer NPCs exist | pick and confirm identities |
| GS Ball item icon | GS Ball is a Gen 2 item — expected native (verify dribble) | verify registry record exists |

## Maps / tilesets

| Need | Exists natively? | Notes |
| --- | --- | --- |
| Ilex Forest (present) | yes — native GSC map | verify exact map id + shrine submap access |
| Shrine clearing | native part of Ilex flow | verify walk-in cell |
| Kurt's house / Azalea | native | verify script banks per edition |
| "Past Ilex" states | **Author**: no HGSS assets; decide per implementation/engine-integration.md (map-registry copy vs runtime block/props variation vs plain reuse with actors) | the big open item |
| Pokémon Communication Center (if Crystal delivery beat is kept) | native in Crystal; may not exist in Gold/Silver data | verify across editions |

## Audio

| Need | Exists natively? | Notes |
| --- | --- | --- |
| Celebi cry | yes | native |
| Shrine/forest themes | native GSC music | verify ids to use |
| HGSS event theme | **Author** (or reuse native theme) — no HGSS music may be imported, decide native substitute | open decision |

## Text

Original English dialogue from both games goes in `dialogue/`, then gets
fitted to the GSC text engine (ROM text labels / VM text / Strings catalog
— see `implementation/engine-integration.md`). Some fitting means keeping
`<NEXT>` separators; some label-keyed prose supports `{ARG:n}` reordering if
we repurpose engine lines.

## Explicitly out of scope / forbidden

- Any HGSS asset (graphics, audio, map data) — reference only.
- Touching `mods/gen2/new_mod_ex`'s authored data — unrelated project.
- Any ROM source material from outside the player's own validated imports.
