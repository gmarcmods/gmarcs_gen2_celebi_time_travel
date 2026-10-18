# Crystal — GS Ball Celebi event (reference breakdown)

Source game: **Pokémon Crystal** (the original event was distributed in
Japan via the Pokémon Communication Center; restored by the standard fan
translation). Everything here is for study; the GSC engine already serves
Crystal, so the Crystal-side scripts and text are the ground truth we must
validate against `references/pokegold-es/` where possible.

## Event flow (to verify and refine)

1. **GS Ball delivery.** After a trigger (mobile/Time Capsule event
   originally), an NPC at the Pokémon Communication Center hands the player
   the **GS Ball**.
2. **Kurt.** The player takes the GS Ball to **Kurt** in Azalea Town. Kurt
   takes it into his workshop ("leave it with him") and asks the player to
   come back later.
3. **Kurt's call.** When the player exits and re-enters Azalea Town (or
   after a wait — verify exact condition against the script), Kurt calls the
   player on the Pokégear and says he has strange news about the GS Ball.
4. **The shrine.** Kurt examines the GS Ball at the **Ilex Forest shrine**
   (the protagonist enters the shrine clearing and places the ball — verify
   the exact interaction: is it Kurt who places it, or the player? The
   staging here must be right; check screenshots).
5. **Celebi appears.** A level-30 Celebi battle starts. Catch it.
6. **End.** In Crystal, this is where the event ends. **Our mod continues
   from here with the HGSS half** — this end point is ours to replace.

## Details to gather

- [ ] Exact trigger condition for GS Ball delivery.
- [ ] Kurt workshop script: flags set, wait rule, call condition.
- [ ] Ilex Forest shrine map id(s), script bank, warp in rules.
- [ ] Celebi battle parameters (level, catch rate used, shiny qualities,
      battle intro music/entries, weather/time-of-day influence).
- [ ] Post-catch state: flags cleared, Kurt's follow-up dialogue (if any).
- [ ] Differences between the Japanese original and the restored fan flow
      that matter for our recreation (dialogue availability in English).

## Files expected

- Dialogue: `dialogue/crystal/<scene>.md` — Kurt workshop, Kurt call,
  shrine scene, Celebi appearance text.
- Screenshots: `screenshots/crystal/crystal-<scene>-<nn>.png`.
