# Dialogue folder

One `.md` file per scene, per source game. Template:

```markdown
# <game> — <scene> (transcribed from <how: emulator capture / disassembly>)

Staging: who is on screen, where, facing where; what condition starts the
scene; camera/screen state.

| # | Speaker | Line (exact game text) | Context (when in the scene) |
| --- | --- | --- | --- |
| 1 | | | |
```

Rules:

- **Exact text** from the game (English). Do not clean up punctuation; the
  GSC text engine has its own line-break/`<NEXT>`-style conventions, and we
  will re-fit lines to it later, so the source must stay untouched.
- Mark uncertain reading of a gameboy-font line with `?` on that cell.
- Keep multi-page boxes as consecutive rows (one row per page), and note
  the paging with `[…]` where it occurs.
- Non-dialogue on-screen prose (title cards, item get text, sound effects
  captions) captured as rows with speaker `--narration--`.

Planned files (create as research progresses):

- `crystal/kurt_workshop.md`
- `crystal/kurt_call.md`
- `crystal/shrine.md`
- `crystal/celebi_battle.md` (intro text only)
- `hgss/arrival_past.md`
- `hgss/past_scenes.md` (or one per past location once locations.md settles)
- `hgss/shrine_giovanni.md`
- `hgss/return_present.md`
