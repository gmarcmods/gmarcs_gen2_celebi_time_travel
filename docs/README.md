# celebi_mod — documentation index

This folder is the research and design base for the mod. Engine code lives
up one level (Phase 1 room and cutscene-action foundation now implemented). Write everything in
English unless a file is explicitly a non-English artifact.

## Folders

| Folder | Purpose | Filled during |
| --- | --- | --- |
| `plan/` | Roadmap, milestone list, open decision log | now, kept current |
| `reference/` | Step-by-step breakdowns of the **two original events** (Crystal GS Ball, HGSS Celebi), and where every location lives in each game | research |
| `dialogue/` | Original English dialogue transcripts, per source and per scene, with the speaker and the in-game context of every line | research |
| `screenshots/` | Reference captures, per source game, of every scene state (map setup, actor positions, dialogue boxes, effects) | research |
| `design/` | How we mix the two events in this engine: event flow, actor/character adaptation questions (Lyra/Kris/Ethan…), scene-by-scene plan | design, after reference files start filling |
| `implementation/` | Engine-side notes: which registries/hooks/events each beat maps to, the asset inventory (what exists natively in GSC vs what must be authored), and open capability questions to settle with probes | design + spikes |

## Conventions

**Screenshots.** `screenshots/<source>/<source>-<location>-<nn>.png` with
`<source>` = `hgss` or `crystal`, `<location>` = short scene key from the
reference breakdowans (e.g. `shrine-clearing`, `past-forest-a`). One image
per notable state; a numbered sequence means the scene is ordered.
Companion notes for a batch go in `screenshots/<source>/NOTES.md`.

**Dialogue.** `dialogue/<source>/<scene>.md`, one file per scene. Header
table with `# | speaker | line | context`, exactly the in-game English
text (keep `[MORE]`, `…` repetitions if they matter for pacing), plus a
short "staging" paragraph describing who is where when each line plays.
Mark paraphrased/uncertain readings with `?`.

**Probes and captures.** In-engine captures use the standard driver flow
from `gen1recomp/` (`POKEPORT_DRIVER=... POKEPORT_SHOT_DIR=/tmp/...`).
Driver/fact-check screenshots saved there for comparison are copied here
only after a real look at the images; never claim verification from
aborted/empty captures.

**Sources.** Crystal-side research can be verified against
`references/pokegold-es/` (original Spanish disassembly source) and the
merged engine's Gen 2 docs; HGSS-side research currently has no
disassembly in the workspace — transcribe from an emulator and mark it as
transcribed.

## Current implementation evidence

- `design/scene-staging.md`: scene-by-scene actor choreography, checkpoints
  and coordinate status.
- `implementation/probe-results.md`: live findings and remaining engine spikes.
- `../tests/room.lua`, `../tests/actions.lua`, `../tests/capabilities.lua`:
  collision/data checks, native-VM action checks and actual gameplay probes.
