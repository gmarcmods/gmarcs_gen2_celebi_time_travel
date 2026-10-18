# Continuous catch → Kurt → history — 0.0.11

The user requested an uninterrupted event rather than a separate follower
activation. The shrine refuses a party of six before offering GS Ball
placement, and checks capacity again after Yes before consuming the ball.
The same rule applies to retrying an uncaught Celebi. Eggs occupy party slots.
The refusal is localized and leaves the item and quest state intact.

After the native Celebi battle settles capture/storage/naming, the native
World:healParty restores HP, status and all move PP for every party member,
including the new Celebi. Kurt congratulates the player, retraces his path
and is removed. Quest immediately calls the historical continuation within
the same VM coroutine and input lock. Celebi appears, circles the player and
time travel begins; the player never has to walk or read the shrine again.

The automatic scene accepts the exact captured Celebi object only if it is
healthy and present in the party. It can be in slot six; original members and
lead order remain unchanged. A separate scene actor represents Celebi during
the animation. Normal overworld following still uses a healthy Celebi lead.
Old interrupted/already-caught saves retain the manual shrine recovery path.
Successful history still returns to Ilex (8,23), commits completion and changes
the permanent radio text. Original Crystal replacement behavior is unchanged.

Validation: tests/continuous.lua checks capacity before item transfer,
healing before Kurt, and direct transition after his departure without a
second interaction. tests/shrine_scene.lua checks non-leading automatic
eligibility, exact party ownership and health. The live lifecycle driver
ran on Gold and Crystal with GEN2_ES and Silver without it. Each run rejected
a six-member party, accepted five, caught the real Celebi into slot six,
started time travel automatically and fought the real Giovanni. The test
injured/statused/depleted PP of the existing five Pokémon and the wild Celebi
before capture; all six were fully healed at Giovanni's intro. Original team
order, Ilex return, saved completion and localized radio were verified.

This is a desktop result. No user save is written by the disposable drivers.
