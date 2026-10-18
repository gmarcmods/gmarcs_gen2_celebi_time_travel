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

Done files, with sources:

- `crystal/gs_ball_delivery.md` — pret disassembly (verbatim).
- `crystal/kurt_workshop.md` — pret disassembly (verbatim).
- `crystal/kurt_restless.md` — pret disassembly (verbatim). Note: vanilla
  Crystal has no phone call in this beat; `kurt_call.md` was renamed after
  research showed the callback is a movement/coord-event scene.
- `crystal/shrine.md` — pret disassembly (verbatim).
- `crystal/celebi_battle.md` — battle texts (mostly standard wild text).
- `hgss/shrine_start.md` — GameFAQs player transcript (verbatim,
  typos kept and marked).
- `hgss/route_22.md` — same transcript.
- `hgss/tohjo_falls_hidden_room.md` — same transcript (two `Ian?`
  uncertainties marked).
- `hgss/return_present.md` — same transcript (typos kept and marked).
- `hgss/broken_radio.md` — original English before/after room examination
  messages and state selection verified against the HGSS decompilation.

Still open: every HGSS file needs a second-source check before its text is
used verbatim in the mod (the transcript is one player's capture).
