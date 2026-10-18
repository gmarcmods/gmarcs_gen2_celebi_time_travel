# Engine integration notes (gen1recomp)

What the merged engine offers today for everything this mod needs, from the
engine's own docs (`gen1recomp/docs/mod-api-gen2-compat.md`,
`gen1recomp/docs/preparing-your-mod-for-gen2.md`,
`gen1recomp/docs/modding.md`). Each item is either a **plan** (use as is) or
a **spike** (verify on a real boot before designing on it). Gen 2 is the
base; anything marked Gold-only must account for Silver and Crystal boots.

**Phase 0 additions (verified against the engine's decoded Gold data and
the pret disassemblies) — [gold ✓] items are facts, not assumptions:**

- Data surface shapes [gold ✓]: `text.lua` entries are keyed by ROM pointer
  strings (`["45:6e11"] = "ILEX FOREST\nSHRINE… …{DONE}"`), `scripts.lua`
  rows are keyed the same way and contain decoded VM ops
  (`{ op = "clearevent", event = 723 }`, `{ op = "writetext", text = … }` —
  **flags are numeric `wEventFlags` ids in the data**, matching the
  `flag.changed` payload fact). This is the exact shape our content would
  need to ride if we could author scripts — we cannot (`map_scripts` has no
  Gen 2 home), so the seams below are the path.
- The shrine's vanilla Gold script is a single `jumptext` (`45:6989 →
  45:6e11`); overriding the pointed text via the rom_text registry keeps the
  vanilla behavior intact — useful for the idle shrine text, but the active
  event needs its own staged cutscene (see spike 1).
- The shrine is a **bg event** (BGEVENT_UP at (8,22) in `ILEX_FOREST`),
  not an NPC object — does `world.talk` fire for bg events at all? Spike 1
  must answer this before we promise an interception seam for it.
- The engine's Gold map extract **omits event-flagged objects** (Kurt at
  (8,29), shrine Lass at (3,24) exist in the ROM but not in `maps.lua`'s
  always-on object list) — only Crystal's ROM carries them as *usable*
  objects. If the engine surfaces them per edition, fine; otherwise our
  Kurt/Lass staging is all `spawnNpc` work. Spike.
- `GS_BALL` is absent from Gold's `items.lua` [gold ✓] (Crystal-only
  item). If the design keeps a real item, the `items` registry must carry it
  with authored art.
- Sprite availability [gold ✓]: `SPRITE_RIVAL`, `SPRITE_ROCKET`,
  `SPRITE_KURT`, `SPRITE_LINK_RECEPTIONIST` exist; no Giovanni, Lyra,
  Marill, or Celebi field sprite (see `implementation/assets-checklist.md`).
- Crystal event internals (reference): `BATTLETYPE_CELEBI` disables
  running/forced switches and sets the caught-Celebi result bit; the
  float-in special uses a 160-frame countdown and `gfx/overworld/celebi`
  frames. The Gen 2 mod API exposes no battle-type control — spike 5 asks
  if any battle-rules row can; otherwise accept an escapeable battle.

## Verified implementation follow-up

`crystal-half.md` records the current playable GS Ball/catch mechanics.
Gold/Silver use a real string-ID key item without replacing numeric slot 115;
Crystal keeps its existing item. Native-VM requests arm VAR_BATTLETYPE (0x03)
with Celebi type 11 and open the normal battle/catch flow, verified on all three
editions. Earlier Phase 0 notes about accepting an escapable encounter are
superseded. `queueScript` itself still exposes only its limited wild-battle
signature. The shared native bag helper is the sole required engine module;
no engine methods are patched.

## Manifest shape (plan)

```json
{
  "id": "celebi_mod",         // final id to decide; catalog adds CELEBI_MOD
  "games": ["gold", "silver", "crystal"],   // or "gen2" (expands to the three)
  "api": 2, "entry": "main.lua", "profile": "content",
  "category": "CONTENT",
  "permissions": [...]        // keep as small as possible; no engine_internals
                              // unless a beat truly needs a served facade
}
```

Dependencies contagious; skip gating is per game. Content registries route
per generation with Gen 2 schemas.

## Key seams relevant to this mod

- **Species/Celebi is native** — dex 251 exists; the battle is an ordinary
  wild battle. Spike: exact construction params (level, intro), probably
  `mod.commands`-row or `queueScript` route.
- **`mod.world:queueScript` (Gen 2)** — Gold has an allowlist of verbs:
  `start_battle "wild" species level`, `warp`, `text`, `setflag`,
  `clearflag`; anything else refuses **by name before the first row runs**.
  Plan: powerful for shrine entrance, warp, battle, flag beats.
- **`mod.commands`** — custom mod verbs reach Gen 2's VM via a
  `modcommand` row; handler may block on `ctx.vm:showText`/`:waitFrames`.
  This is how a longer cutscene could ride inside the script VM.
- **`mod.world:spawnNpc(mapId, objectDefinition)`** — returned object ID
  resolves via `mod.world:npc(mapId, id)`; handle methods
  (`scriptMove`, `marchInPlace`, `stepNow`, `canStep`, `placeAt`,
  `isMoving`, `setPassable`, `setAppearance`) give full staged movement for
  actors (Giovanni leaving, partner walking). Not serialized; respawn on
  `map.entered`, so the scene restarts cleanly. Spike: how a scripted walking
  partner co-walks with the player.
- **`world.talk` hook** — the A press on an object, before map text tables;
  candidate seam for shrine interactions we own. **Caveat:** the shrine is a
  bg event, not an object — spike 1 must test whether the hook reaches bg
  events, or whether `script.started`/`script.command` on the shrine's
  vanilla jumptext is the real interception point.
- **`flag.changed`** carries numeric `wEventFlags` ids (not names) — all
  flag logic must be edition-aware against real GSC flag numbers.
- **`phone.*` system is live on Gen 2** — Kurt's call-back could ride
  `phone_contacts`/`phone.call_received`.
- **`pokemon.caught` / `battle.ended`** — the post-catch trigger for the
  HGSS half. Spike: exact payload/availability across the three editions.
- **`script.started` / `script.ended` / `script.command`** — observe/veto
  scripts we cannot author whole; candidate shrine-entrance gate.
- **`screen.*` events + `screens` registry** — Gold's screens are
  `Gen2`-prefixed ids; custom full-screen surfaces (e.g. the time-travel
  transition) can be authored as mod screens.
- **`render_pipelines`:** on Gold, `drawWorld` is inert; only
  `worldPresent`/`present` run. If we want a visual time-travel treatment
  (fade/flash/desaturation), it must live in `present`/`worldPresent` or a
  screen, not `drawWorld`.
- **`encounters` registry** — Gen 2 ids are kinds (`grass`, `trees`, …) with
  per-time-of-day rates; only patch if the design needs it (Celebi battle is
  a script battle, not a grass roll).
- **Text:** `text` ids are ROM pointers; `rom_text` override supports
  `{ARG:n}` reorders; the `strings` catalog serves embedded literals; item
  descriptions are patchable record fields. Plan all new English dialogue
  through these (which one per beat is a spike).
- **`mod.storage` / `mod.save`** — event progress persistence (never
  invented cache markers); `mod.save` rides the normal Pokémon SAVE.

## Known engine gaps on Gen 2 that touch this design

- `map_scripts`: **no Gen 2 home** — we cannot author a Lua row-list script
  into the VM bank; sticking to `queueScript`/mod-command rows is the plan.
- `trainer.before_battle`, `battle.field_residual`, `pokemon.before_give`,
  `trade.completed`, in-game link: not raised on Gold (check Silver/Crystal
  too, but assume same).
- `link_fields`: gated; irrelevant here unless we ever ship event Pokémon
  over link.
- `transition.style` registry: no Gen 2 home; battle transitions are a
  boolean set on Gold. If the time-travel wipe uses any transition row, it
  must be authored engine-side ourselves (screen or present pass).
- `effectiveEncounters` doesn't account for roaming legendaries; only
  relevant if we ever model a roamer (likely out of scope).

## Spike list (Phase 1 probes; write failing probe per question)

1. Shrine script: the native shrine is a jumptext bg event at (8,22) —
   what does an A press emit through the engine's seams (does `world.talk`
   reach bg events? does `script.started` name `45:6989`?); can
   `world.talk`/`script.*` seams own it in each edition?
2. Custom scripted cutscene: march/marchInPlace/steps with player input
   locked; does it resume correctly after a reload mid-scene?
3. Past-map realization: compare (a) maps-registry copy registered as a new
   map, (b) runtime block/object variation while visiting, (c) plain reuse.
   Verify warp safety and palette/tileset in each. Design now requires a dedicated
   Tohjo Falls hidden room with a radio and permanent entrance/return warps;
   probe registered-map construction and ordinary before/after exploration.
   Route 22 reuses the native map.
4. Celebi encounter construction through `queueScript`/mod-command row;
   verify level/intro/catch and that catching it emits `pokemon.caught`
   every edition. Also: can Celebi be attached to the Gen 2 follower
   system afterwards (the HGSS trigger needs a following Celebi)?
5. Time-travel transition: can a `present`-stage pipeline or custom screen
   produce the fade/flash the beat needs, without breaking battle/HUD?
   Also check whether any battle-rules row can implement the no-run flavor
   of `BATTLETYPE_CELEBI`.
6. Kurt call: `phone_contacts` route details (only if we substitute the
   vanilla movement callback; recommended vanilla path needs no phone).
7. Flag-space facts: numeric `wEventFlags` ids per edition for the flags
   the event touches (Crystal originals are named in
   `reference/crystal-gs-ball-event.md`).
8. Text placement: which text surface (rom_text/strings/text/queueScript
   text) fits each beat; verify line-fitting constraints.
9. Trainer battle: register "Rocket Boss Giovanni" (party Nidoking 42,
   Murkrow 43, Nidoqueen 46, Kangaskhan 40) via mod-registered trainer or
   `trainer.party` on a generic slot; verify the victory continuation flow
   on all editions.
10. Event-flagged objects: are Kurt (8,29)/shrine Lass (3,24) surfaced by
    the engine on Crystal/Silver, or must the mod `spawnNpc` them?
