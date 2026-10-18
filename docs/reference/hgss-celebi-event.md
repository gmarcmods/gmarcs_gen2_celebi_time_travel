# HGSS — Celebi time-travel event (reference breakdown)

Source game: **Pokémon HeartGold / SoulSilver**. This is the second half of
our mod: it begins where the Crystal event ends (Celebi caught at the Ilex
shrine). No HGSS disassembly exists in this workspace — everything is
transcribed from an emulator and marked as transcribed.

## What we know we must recreate (to verify in detail)

1. **Trigger.** Celebi must be in the party (verify: first slot?) when the
   player returns to the **Ilex Forest shrine**. Verify whether time of day
   or any other state gates it.
2. **Time travel.** A Celebi-branded transition takes the player **three
   years into the past**. Verify the exact presentation (fade/flash, screen
   treatment, what the engine would need to reproduce it).
3. **Past scene(s).** Ilex Forest **three years ago**, with the shrine
   accessible. The player is accompanied by a walking partner (the user
   remembers **Lyra/Kotone**; verify whether the partner depends on the
   player's chosen gender — Ethan vs Lyra). Actors to confirm: Past-aligned
   forest residents, and at the shrine — the scene centers on a
   **Giovanni** moment (verify who else is present and the exact staging).
4. **Dialogue.** All original English lines, transcribed per moment, with
   staging. We will adapt them later (see `design/event-flow.md`); first
   capture everything faithfully.
5. **Return.** Celebi returns the player to the present at (or near) the
   shrine, and the event closes.

## Details to gather

- [ ] Trigger conditions exactly (party slot, Celebi ownership check,
      entrance cell that starts it, any day/time gating).
- [ ] The full scene order in the past: where the player lands, which maps
      are used, whether the player walks the scene or it walks itself.
- [ ] Every actor in the past: identity, sprite, movement path, facing;
      particularly the partner, Giovanni (and Persian), and anyone else at
      the shrine.
- [ ] **The "both locations of the past" question** — the user remembers
      two past locations in the event. Confirm exactly which two (are they
      two areas of the past forest, or Ilex and a second place?), and record
      each one's exact coordinates relative to the present-day map (see
      `reference/locations.md`).
- [ ] Beats of the Giovanni moment: approach order, who says what, the
      flashback/dialogue rhythm, what triggers his departure.
- [ ] Return beat: how Celebi ends the event, where the player reappears in
      the present, flags set by the event to prevent re-entry.

## Files expected

- Dialogue: `dialogue/hgss/<scene>.md` — outer shrink/arrival lines per
  participant, every beat of the past scene, return lines.
- Screenshots: `screenshots/hgss/hgss-<scene>-<nn>.png` — one numbered
  sequence per scene; include actor-position frames before and after each
  movement beat.
