# Locations research (both events, both engines)

**Status: researched** (Phase 0 done for locations; screenshots pending).
HGSS side comes from the `pret/pokeheartgold` decomp (`include/constants/maps.h`)
and the event transcript; GSC side comes from the merged engine's decoded
Gold data (`~/.local/share/love/pokemon-love2d/gold/data/generated/maps.lua`)
cross-checked against `pret/pokecrystal`. Coordinates below are GSC object
grid coordinates as used by the games' scripts.

## The one permanent location (Crystal half — all on GSC native maps)

### Shrine (present day) — Ilex Forest

| Fact | Value |
| --- | --- |
| Map | `ILEX_FOREST` (native in all GSC editions; Gold extract: map 44, music 40, landmark 14) [gold ✓] |
| Shrine interaction | **bg event read facing UP at tile (8,22)** (pret `bg_event 8, 22, BGEVENT_UP, IlexForestShrineScript`) |
| Vanilla Gold text at that spot | `45:6989 → text 45:6e11` "ILEX FOREST SHRINE… It's in honor of the forest's protector…" [gold ✓] |
| Shrine region of the map | The shrine set-piece sits in the north-east part of Ilex Forest, behind the cut-tree obstruction and the small pond area |
| Kurt (hidden watcher) | object `SPRITE_KURT` at **(8,29) facing UP**, flagged `EVENT_ILEX_FOREST_KURT` (only appears during the event catch) |
| Shrine-side Lass | object `SPRITE_LASS` at **(3,24) facing RIGHT**, `EVENT_ILEX_FOREST_LASS` (removed when placing begins) |
| Warps into the map | `(1,5)` → Route 34/Ilex gate; `(3,42)/(3,43)` → Ilex/Azalea gate |
| Native objects in Gold's extract | Farfetch'd-like BIRD objects (6 of them + 4 more BIRDs), youngster (7,28), Black Belt (5,28), rocker (15,14), item balls at (20,32)… — **the Kurt and Lass objects are event-flagged and absent from the Gold extract's object list** (extract keeps only always-on objects; verify how the engine surfaces flagged objects) |

Note: in GSC the shrine is **part of the Ilex Forest map**, not a submap —
it is an interaction tile region, which is good news: no map duplication is
needed for the shrine.

### Kurt's house & Azalea street

| Fact | Value |
| --- | --- |
| Map | `KURTS_HOUSE` (native) — Kurt objects `KURTSHOUSE_KURT1/2`, granddaughter twins `TWIN1/2`; Kurt exits via the door movement |
| Street scene | `AZALEA_TOWN` coord event **(9,6)** under scene `SCENE_AZALEATOWN_KURT_RETURNS_GS_BALL`; Kurt outside object stands on the street (faces player, then turns LEFT/west toward forest) |
| Delivery beat | `GOLDENROD_POKECENTER_1F` coord events **(3,7) / (4,7)** (entrance tiles); receptionist object spawns at the PC doorway (0,7) |

## The two "past" locations (HGSS half) — now confirmed

The user's memory of **two past locations** resolves exactly to these:

| # | HGSS map | HGSS map id | Scene | GSC-native counterpart in the engine |
| --- | --- | --- | --- | --- |
| 1 | `MAP_ROUTE_22` (`MAP_R22`) | 27 | Three years ago: the Silver-vs-the-man-in-black argument; Silver runs you down | **`ROUTE_22` exists natively in GSC** [gold ✓] — the map key `ROUTE_22` is present in the engine's Gold `maps.lua` (GSC's Route 22 sits southwest of Viridian City, toward the Tohjo Falls/Route 26 side, so the geography matches HGSS's setting) |
| 2 | `MAP_TOHJO_FALLS_HIDDEN_ROOM` (`MAP_D45R0102`) | 298 | "Three years later": Giovanni + radio + boss battle | `TOHJO_FALLS` exists natively [gold ✓]; **the hidden room is an HGSS-added interior submap with no GSC equivalent** — realization decision needed (see below) |

Adjacent on purpose: Route 22 borders Tohjo Falls on the Kanto/Johto
boundary; the event's two jumps stay inside one neighborhood.

Hidden-room realization is now a design requirement: **author a dedicated
small cave map with a radio**, connected to `TOHJO_FALLS` for ordinary
exploration before and after the event. Include an entrance and return warp;
final entrance coordinates and collision need an in-engine probe. A temporary
cutscene-only nook or unrelated reused interior does not meet this requirement.
The event stages Giovanni and the partner in this room; ordinary visits leave
it empty except for its scenery and broken radio. Radio examination text is
recorded in `../dialogue/hgss/broken_radio.md`.

Timeline: the hidden-room scene is **three years later than Route 22**, during
the Radio Tower takeover. It follows immediately in the travelers' experience
because of the second time jump, not because both scenes share a day.

Route 22 (option: **reuse the native map as-is**; only actor placement +
scripted staging differ) is the low-risk half.

## Open questions

- [ ] How does the engine surface **event-flagged objects** (Kurt in Ilex,
      street Kurt) that the Gold extract's object list omits — `spawnNpc`
      vs native object re-use.
- [ ] Per-edition numeric ids: map ids, the shrine text pointer
      (`45:6e11` is Gold's; Crystal/Silver ids differ), and event-flag
      numbers all shift between editions — probe each edition's cache.
- [ ] Does any beat interact with `world.tod`/`clock.day_changed`? The
      Crystal event already uses a day-change mechanic (Kurt's daily flag)
      — if we keep that, the day boundary is a core seam, not decoration.
