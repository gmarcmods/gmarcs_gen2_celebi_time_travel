# Engine integration notes (gen1recomp)

What the merged engine offers today for everything this mod needs, from the
engine's own docs (`gen1recomp/docs/mod-api-gen2-compat.md`,
`gen1recomp/docs/preparing-your-mod-for-gen2.md`,
`gen1recomp/docs/modding.md`). Each item is either a **plan** (use as is) or
a **spike** (verify on a real boot before designing on it). Gen 2 is the
base; anything marked Gold-only must account for Silver and Crystal boots.

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
  candidate seam for shrine interactions we own.
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

1. Shrine script: what does the native shrine do on A press in each
   edition; can `world.talk`/`script.*` seams own it?
2. Custom scripted cutscene: march/marchInPlace/steps with player input
   locked; does it resume correctly after a reload mid-scene?
3. Past-map realization: compare (a) maps-registry copy registered as a new
   map, (b) runtime block/object variation while visiting, (c) plain reuse.
   Verify warp safety and palette/tileset in each.
4. Celebi encounter construction through `queueScript`/mod-command row;
   verify level/intro/catch and that catching it emits `pokemon.caught`
   every edition.
5. Time-travel transition: can a `present`-stage pipeline or custom screen
   produce the fade/flash the beat needs, without breaking battle/HUD?
6. Kurt call: `phone_contacts` route details.
7. Flag-space facts: which numeric event flags the event uses (check
   against Crystal's original event where possible).
8. Text placement: which text surface (rom_text/strings/text/queueScript
   text) fits each beat; verify line-fitting constraints.
