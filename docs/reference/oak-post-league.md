# Oak after the League — research, not a delivery change

Verified 2026-10-17 against the user's decoded Gold, Silver and Crystal data,
the merged engine's Phone.CONTACTS and the pret Gold/Crystal scripts. Repeat
with `luajit mods/gen2/celebi_mod/tools/audit_oak.lua` from workspace root.
The audit does not read/write ROMs or saves.

## Existing appearances and events

1. Early game: Oak meets the player in Mr. Pokémon's house, grants the Pokédex
   and leaves. This script does not register a working Oak phone number.
2. Immediately after defeating Lance, Mary enters Lance's room, followed by
   Oak. Oak congratulates the new Champion. Mary tries to interview the player;
   Lance leads the player toward the Hall of Fame. This is an existing,
   scripted physical encounter with Oak in all three editions.
3. Hall of Fame: Lance conducts registration. The game heals the team and,
   if Elm's S.S. Ticket has not yet been collected, queues **Elm's** ticket
   call. This is not an Oak phone event.
4. Kanto: Oak is in his Pallet Town lab. First conversation welcomes the
   player to Kanto. At eight total badges he encourages collecting Kanto's;
   with some Kanto badges he encourages returning after all are collected.
   At sixteen total badges he unlocks Mt. Silver, then evaluates the Pokédex.
   Later visits retain Pokédex evaluation. This is not a GS Ball gift.
5. His Pokédex evaluation is also exposed through the Professor's PC; his
   Pokémon Talk broadcasts are separate radio content, not a phone contact.

## Does the player have Oak's number?

No usable native Oak contact is registered by these story events. A misleading
legacy `PHONE_OAK` name exists at zero-based slot 2 in the decoded constants.
The actual contact row is disabled: both caller/callee time masks are zero
and both scripts are `UnusedPhoneScript`. In the modern table its non-trainer
name field uses the Bike Shop identity and its map still says OAKS_LAB. The
constant's name alone is not evidence that a player can phone Oak.

Elm is a real contact, and the post-League ticket call belongs to him. A new
Oak invitation call would need an explicit working contact/script and save
registration; it must preserve Elm's pending ticket call and the real Bike
Shop contact. Merely queuing a call using the legacy Oak constant is wrong.

## Workspace cross-check

| Edition | Oak lab interaction | Championship congratulations text |
| --- | --- | --- |
| Gold | `59:58c3` | `5a:5aca` |
| Silver | `59:58c3` | `5a:5aca` |
| Crystal | `66:73c8` | `60:521b` |

All three have the 8/16-badge lab branches and native ProfOaksPCBoot call.
Their maps contain SPRITE_OAK in Mr. Pokémon's house, Lance's room and Oak's
lab. Runtime integration should resolve native objects/scripts per edition,
not assume Gold's pointer keys work on Crystal.

## Possible GS Ball handovers

The most natural early post-League option is Oak's existing congratulations
scene after Lance: Oak is already present, with native movement and dialogue.
A one-time handover could follow his congratulations without inventing a new
phone event. This precedes the actual Hall of Fame registration, so the gate
would be the real Lance victory/scene and the mod's delivered flag rather
than assuming `hallOfFame.count` is already one at that exact frame.

A handover at Oak's lab is simpler as a normal interaction but delays the
quest until the player travels into Kanto. A call inviting the player there
is another option, with extra contact/queue work. All options must preserve
Mt. Silver unlocking, Pokédex ratings and original Spanish dialogue, avoid
duplicate gifts on repeat League wins, handle a full key-item pocket, and
replace the old Goldenrod delivery route rather than accidentally keeping
two independent givers. The user selected the incoming-call invitation and lab handover. This is now
implemented in 0.0.12; see [implementation](../implementation/oak-delivery.md).

## Primary sources

- [Gold Lance's room](https://github.com/pret/pokegold/blob/master/maps/LancesRoom.asm)
  and [Crystal Lance's room](https://github.com/pret/pokecrystal/blob/master/maps/LancesRoom.asm).
- [Gold Hall of Fame](https://github.com/pret/pokegold/blob/master/maps/HallOfFame.asm).
- [Crystal Oak's lab](https://github.com/pret/pokecrystal/blob/master/maps/OaksLab.asm).
- [Crystal Mr. Pokémon's house](https://github.com/pret/pokecrystal/blob/master/maps/MrPokemonsHouse.asm).
- [Crystal contact table](https://github.com/pret/pokecrystal/blob/master/data/phone/phone_contacts.asm).
- Local engine: `gen1recomp/src/core/gen2/Phone.lua` (disabled slot 2), and
  local Gold reference maps/phone tables under `references/pokegold-es/`.
