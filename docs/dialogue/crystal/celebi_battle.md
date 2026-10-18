# Crystal — Celebi battle texts

Transcribed from the engine + pret Crystal disassembly. The Celebi battle is
an ordinary **wild battle** (species 251, level 30) with a special battle
type applied by `CelebiShrineEvent`.

| # | Speaker | Line (exact game text) | Context |
| --- | --- | --- | --- |
| 1 | —(battle) | `Wild CELEBI appeared!` | battle intro (standard engine wild text) |
| 2 | —(battle) | standard move/turn texts | Celebi level 30; GSC wild move-set at 30 is Heal Bell, Safeguard, AncientPower, Future Sight |
| 3 | —(battle catch) | standard catch animation + `Gotcha! CELEBI was caught!` | `BATTLETYPE_CELEBI`: running away and forced switches are disabled; a successful catch sets the caught-Celebi result bit read by `special CheckCaughtCelebi` |

Notes:

- Engine-native Celebi data (Gold extract): catch rate 45, genderless,
  medium-slow growth, base stats all 100.
- The engine's `queueScript start_battle "wild"` route cannot set a special
  battle type (no BATTLETYPE equivalent on the Gen 2 API today). The
  "can't run" nicety is optional flavor — decision in `design/event-flow.md`.
- `CheckCaughtCelebi` success is what resumes the shrine script for Kurt's
  congratulations; in our mod the analogous continuation is our own
  post-catch trigger (`pokemon.caught` / `battle.ended`) — see
  `implementation/engine-integration.md`.
