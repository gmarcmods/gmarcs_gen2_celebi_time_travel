# Asset inventory

**Status: initial inventory researched against decoded Gold data; current
mechanics and room probes also use the real Silver/Crystal caches.** Evidence key: [gold ✓] = verified in
`~/.local/share/love/pokemon-love2d/gold/data/generated`; from the pret
disassemblies; HGSS facts are reference-only (nothing ships from HGSS).

## Current adaptation scope

No Lyra/Ethan or replacement partner, and no Marill. Their rows below describe
HGSS source inventory only and are not production asset requirements. Use time
and location captions, retaining Silver/Giovanni and the radio narrative.

## Pokémon / battle

| Need | Exists natively? | Evidence / notes |
| --- | --- | --- |
| Celebi (dex 251) battle front/back, cry, dex sprite | **Yes** [gold ✓] | `pokemon.lua` CELEBI row with sprite paths under `assets/generated/battle/…` |
| Celebi level-30 wild battle data | **Yes** [gold ✓] | catch rate 45, all-100 base stats; moves at 30 = Heal Bell, Safeguard, AncientPower, Future Sight |
| Murkrow (battle + field) | **Yes** [gold ✓] | native; this is the Gen 2 stand-in for HGSS's **Honchkrow** in the Giovanni battle (Honchkrow is a Gen 4 evolution — not in GSC data) |
| Honchkrow | **No** | absent from Gen 2; battle team adaptation = Murkrow 43 (design decision, `design/event-flow.md`) |
| Nidoking / Nidoqueen / Kangaskhan (battle) | **Yes** [gold ✓] | native Gen 2 species for the rest of the boss team |
| Marill (Lyra's companion, return beat) | Battle art yes [gold ✓] (dex 183); **field sprite no** | no MARILL in the field sprite list; only needed if we stage Marill on the return screen — authoring candidate |

## Field sprites (overworld)

| Need | Exists natively? | Evidence / notes |
| --- | --- | --- |
| Kurt | **Yes** [gold ✓] | `SPRITE_KURT` in `sprites.lua` |
| Link/Trade Corner Receptionist (GS Ball giver) | **Yes** [gold ✓] | `SPRITE_LINK_RECEPTIONIST` (+ `SPRITE_OLD_LINK_RECEPTIONIST`) |
| Silver (the rival) | **Yes** [gold ✓] | `SPRITE_RIVAL` — direct fit for the Route 22 scene |
| "Man in black" (Giovanni) field sprite | **No** | no boss-cloak sprite (`SPRITE_ROCKET` is the grunt sprite, present [gold ✓]). Options: (a) use `SPRITE_ROCKET` and reveal "Giovanni" in text, (b) author a GBC-style boss sprite; battle-side has no Giovanni trainer sprite in Gen 2 either — see trainer note below |
| Lyra (past-scene partner) | **No** | no native GSC counterpart (`SPRITE_KIMONO_GIRL`, `SPRITE_TEACHER`-class sprites exist for adaptation). Authoring a GBC-style Kotone/Lyra sheet is the faithful option; decision in `design/event-flow.md` |
| Celebi floating field sprite | **No** (in the engine's field sprite set) | Crystal's `gfx/overworld/celebi.2bpp` exists as unused event art in the ROM data (pret); our version must be **authored** to ship (mod asset), can be styled after the 4-frame float; must not be an extracted ROM graphic in the mod ZIP |
| Shrine tile art | **Yes** (part of the Ilex Forest tileset) [gold ✓] | shrine is a bg-event region of `ILEX_FOREST` at (8,22), tiles native |
| Ilex Forest native actors (Farfetch'd-ish BIRD objects, youngster, Black Belt, rocker) | **Yes** [gold ✓] | all present in the Gold extract's object list |

## Maps

| Need | Exists natively? | Notes |
| --- | --- | --- |
| Ilex Forest incl. shrine area | **Yes** [gold ✓] | `ILEX_FOREST`, shrine bg (8,22), warps at (1,5) and (3,42/43) |
| Kurt's house, Azalea Town, Goldenrod Pokémon Center | **Yes** [gold ✓] | all native |
| Route 22 (past, beat 1) | **Yes** [gold ✓] | reuse native; staging-only changes |
| Tohjo Falls (past, beat 2 surroundings) | **Yes** [gold ✓] | native |
| Tohjo Falls **Hidden Room** (past, beat 2 proper) | **No** | HGSS-added interior (`MAP_D45R0102`); create a dedicated cave map + permanent Tohjo entrance/return warp; registry/warp feasibility remains a Phase 1 spike |
| Pokémon Communication Center (JP delivery venue — only if we choose that flavor) | Crystal-only in original data | not in the Gold extract; irrelevant if the delivery uses Goldenrod PC (pret's international coding) |

## Hidden-room radio (required)

- [x] Author a GSC-style **broken radio field sprite/object**; do not ship
      HGSS artwork. Define its palette, footprint, collision and interaction.
- [ ] Stage an active radio for the historical broadcast, with any authored
      active-state frames/effects required by the storyboard.
- [x] Integrate original before/after examination text from
      `../dialogue/hgss/broken_radio.md` and persist the event-dependent state.
- [x] Build the dedicated cave room and permanent entrance/return warp;
      verify ordinary visits before and after completion on all editions.

## Authored animations and effects (required)

See `../design/event-flow.md` §Required animation work for the complete
scene requirements. Track animation sequences separately from static art:

- [x] Celebi directional follower/idle-hover frames and shrine float-in (0.0.4).
- [ ] Celebi circling/hopping, glow/flash, departure and arrival sequences.
- [ ] Reusable time-travel swirl, white-out and reveal effects for all
      three transitions, with per-scene timing and map-change cues.
- [ ] Native walking/emote choreography plus any missing frames for Kurt,
      receptionist, Silver/player stagger, Giovanni.
- [ ] Storyboards/timing sheets, frame layouts, palettes and sound cues.
- [ ] Live captures verifying animation timing, actor alignment and effect
      cleanup across editions and renderer modes; performance measurements
      for the transition effects.

All new art/effects are authored for this mod. Native engine assets may be
referenced; HGSS assets remain reference-only. Checked rows above are implemented; unchecked animations and HGSS scene
assets remain unfinished. See `crystal-half.md` for current verification.

## Audio

| Need | Exists natively? | Notes |
| --- | --- | --- |
| Celebi cry | **Yes** [gold ✓] | native |
| `MUSIC_SHOW_ME_AROUND` ("Show Me Around!" — the delivery jingle) | **Yes in Crystal's music set** (pret) | engine music registry availability per edition = spike |
| HGSS themes (Lyra's theme, Team Rocket theme) | **No** — may not be imported | native GSC substitutes to pick in design (e.g. Rocket vs Rocket-revival-adjacent GSC tunes) |
| Radio broadcast SFX/music | **No** | adapt: reuse native GSC radio/Pokégear-ish SFX or plain text staging |

## Items

| Need | Exists natively? | Evidence / notes |
| --- | --- | --- |
| `GS_BALL` item | **No in Gold data** [gold ✓ — absent] | Gold's `items.lua` has no GS_BALL (Crystal-only item). Implemented: register a real `GS_BALL` key item by string ID on Gold/Silver, retaining the numeric 115 TERU-SAMA placeholder; reuse Crystal's native item. Native pack has no item icons; shrine placement art is still pending. |

## Trainers

| Need | Exists natively? | Evidence / notes |
| --- | --- | --- |
| "Rocket Boss Giovanni" trainer battle | **No as a native trainer** | Giovanni never battles in Gen 2 (no trainer-table entry). Build the battle through a mod-registered trainer or `trainer.party` hook over a generic trainer slot — spike (engine docs raise `trainer.party` on Gen 2) |

## Text

Original English dialogue is transcribed in `dialogue/` (Crystal: verbatim
from the disassembly; HGSS: verbatim from the player transcript, typos
marked). Fitting to the GBC text engine happens at Phase 2/3 (ROM text
pointer overrides vs Strings catalog — see
`implementation/engine-integration.md`).

## Explicitly out of scope / forbidden

- Any HGSS asset (graphics, audio, map data, models) — reference only.
- Shipping extracted ROM graphics inside the mod ZIP — anything not native
  to the merged engine's data must be **authored** (GBC-style) as a mod
  asset.
- Touching `mods/gen2/new_mod_ex`'s authored data — unrelated project.
- Any ROM source material from outside the player's own validated imports.
