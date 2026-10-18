# Crystal — GS Ball delivery, Goldenrod Pokémon Center

Transcribed from the pret Crystal disassembly
(`maps/GoldenrodPokecenter1F.asm`; texts verbatim). In the international
ROM the scene is coded but never triggered (the `GS_BALL_AVAILABLE` gate is
never set); the Virtual Console release arms it after the first Hall of Fame
entry. The Japanese original delivered the ball through the Pokémon
Communication Center's mobile service instead — same dialogue was used in
the JP Crystal ROM (same translation pass).

Staging: the scene is **not** an NPC talk — it fires off **coord events at
the entrance tiles `(3,7)` and `(4,7)`** as the player walks
out of the Pokémon Center (scene `SCENE_GOLDENRODPOKECENTER1F_GS_BALL`).
`SFX_EXIT_BUILDING` plays, the **Link Receptionist** object is teleported to
the PC doorway `(0,7)` and made to appear, `MUSIC_SHOW_ME_AROUND` plays, she
marches to the player's side of the door, the player turns UP, the ball is
given; she then marches back toward the stairs and disappears
(`SFX_EXIT_BUILDING`), and the map music restarts.

Flags set: `EVENT_GOT_GS_BALL_FROM_GOLDENROD_POKEMON_CENTER`,
`EVENT_CAN_GIVE_GS_BALL_TO_KURT`; item granted is `verbosegiveitem GS_BALL`.

| # | Speaker | Line (exact game text) | Context |
| --- | --- | --- | --- |
| 1 | Link Receptionist | `<PLAYER>, isn't it?` | box 1, on approaching |
| 2 | Link Receptionist | `Congratulations!` | box 2 |
| 3 | Link Receptionist | `As a special deal, a GS BALL has been sent just for you!` | box 3 |
| 4 | Link Receptionist | `Please accept it!` | box 4 → ball handed over |
| 5 | Link Receptionist | `Please do come again!` | box 5, before walking back |

Notes for the recreation:

- `GS_BALL` does **not** exist in the merged engine's Gold item data; if the
  design keeps this beat faithful, the mod registers/authors the item (see
  `implementation/assets-checklist.md` and `design/event-flow.md`).
- The approach/walk-away movement routines are paired versions for the left
  `(3,7)` and right `(4,7)` doorway tiles; our staged recreation only needs
  one walk-in path (we control the spawn).
- The original trigger condition is edition-flavored (HoF completion on VC,
  mobile activity on JP). Our mod picks its own trigger — decision logged in
  `design/event-flow.md`.
