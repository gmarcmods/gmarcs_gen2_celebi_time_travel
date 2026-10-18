# Locations research (both events, both engines)

The goal of this file is a **definitive map of where everything happens**,
in two coordinate families:

- **HGSS reality** — where each event beat happens in HeartGold/SoulSilver
  (maps, tile coordinates, which tileset each map uses).
- **GSC/Gold reality** — where the equivalent spot lives in Gold/Silver/Crystal
  as brought into this engine (map ids from `data.gen2Maps`, tilesets,
  warp rows, coordinates), since **all of our recreation is authored on top
  of the GSC engine's maps**.

## Known starting points (verify)

| Beat | HGSS | Gold/Silver/Crystal (engine) |
| --- | --- | --- |
| GS Ball delivery | — (Crystal-side flow) | Pokémon Communication Center? To decide. |
| Kurt's workshop | Kurt's house, Azalea Town | Same map in GSC; verify script bank per edition |
| Shrine (present day) | Ilex Forest shrine clearing | Ilex Forest shrine submap; verify exact map id, entering warp, walk-in cell |
| Celebi battle | (HGSS has its own continue) | Engine-native wild battle vs Celebi 251 |
| Past — location 1 | Past Ilex Forest (three years ago) — **name and bounds TBC** | Realize as map variation of the native Ilex map |
| Past — location 2 | **TBC — the user remembers a second past location; confirm what it is** | Realization method decided after location 1 research |

## Method

1. For each GSC (Gold / Silver / Crystal) map involved, record:
   map id/name from the engine's map registry, warp rows that lead in and
   out, the walk-in cell after each warp, and the shrine object's cell.
2. For HGSS, capture equivalent entrances/exits with numbered screenshots
   and note approximate tile coordinates.
3. Identify whether the "past" is the same map geometry (then a runtime map
   variation is enough) or different geometry (then check what the engine's
   maps registry can offer — see `implementation/engine-integration.md`).

## Open questions

- [ ] Exact GSC shrine map id for each edition (Gold/Silver/Crystal may
      differ; the engine merges the three but scripts and maps differ per
      edition).
- [ ] Does the engine expose the shrine as a separate map or as a blockset
      inside Ilex Forest?
- [ ] The two past locations of the HGSS event: bound them to present-day
      coordinates.
- [ ] Time-of-day: does any of this interact with the engine's
      `world.tod`/`clock.day_changed` seams (e.g. a night-only variant)?
