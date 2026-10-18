# Oak invitation and GS Ball delivery — 0.0.12

After the first Hall of Fame entry, an outdoor step with phone service can
queue Oak's incoming call. He says Elm provided the number and invites the
player to his Pallet lab whenever convenient. It uses the native phone ring,
caller box, paging and hang-up. No phonebook entry is required or added.

`PHONE_OAK` is the original disabled contact at index 2 in all three editions.
Only its displayed name is patched to OAK, with both random-call and outgoing
call time masks kept at zero. The real Bike Shop contact remains unchanged.
The call does not use or clear the native single special-call slot. Pending
native calls, a busy world, deferred scripts and queued field scripts take
priority. A first VM command rechecks native call priority and outdoor
service before any ring, handling calls queued or warps taken after our
landing listener. A lost queued ring can retry on the next eligible step. Successful
completion stores `oakCallHeard` in the current save's mod data.

The lab gift requires Hall of Fame and quest phase `none`, independently of
whether the player heard the invitation. This deliberately prevents hanging
up, a load or an overwritten queued ring from stranding the quest.

The native lab script is neither replaced nor patched. Its per-edition Oak
object script key identifies a successfully completed foreground interaction
through `script.ended`. Only then is a separate native VM gift script queued.
Callbacks, other actors, Professor's PC, abandoned scripts and pending native
deferred work do not trigger the handover. This preserves welcome-to-Kanto,
8/16-badge branches, Mt. Silver flag and native Pokédex evaluation, including
Spanish's existing translation hooks.

The gift asks the player to take the mysterious GS Ball to Kurt. Native bag
insertion checks the key-item pocket before `Progress.deliver` changes phase.
On failure Oak keeps the ball and asks the player to make room and talk again.
On success the phase becomes `delivered`, preventing further calls or gifts.
Old saves already at `delivered` or later continue unchanged. Existing GS Ball
inventory is acknowledged rather than duplicated. All new lines have authored
English and Spanish catalogs, using English without GEN2_ES.

The Goldenrod warp interception, receptionist scene and delivery command have
been removed. Crystal's original GS Ball event remains disabled by the
edition-specific replacement module; Kurt and the continuous capture/history
quest are unchanged.

## Validation

- `tests/oak.lua`: no call before League, native call/queued script priority,
  service/busy guards, a native call arriving after scheduling, interrupted
  ring retry, completion suppresses repeat
  calls, completed native Oak interaction only, full pocket retry, one gift,
  and lab delivery without completing the invitation.
- `tools/audit_oak.lua`: actual decoded Gold/Silver/Crystal scripts retain
  8/16-badge paths and ProfOaksPCBoot; unused phone slot verified per edition.
- `tests/quest.lua`: old giver absent, bag failure and duplicate protection,
  Kurt/shrine interception, catch scoping and interruption cleanup.
- `tests/localization.lua`: complete bilingual catalogs and English fallback.
- `tests/oak_live.lua`: focused native phone and lab run, including real
  8/16-badge branches, full pocket retry and unchanged phonebook.
- `tests/lifecycle_live.lua`: disposable three-edition native gameplay probe;
  Oak invitation, native lab dialogue, real full key pocket/retry, 16-badge
  Mt. Silver unlock and no duplicate, then Kurt,
  actual Celebi capture, healing, time travel, Giovanni and return to Ilex.

Desktop results (2026-10-17): Gold with GEN2_ES, Silver in English and Crystal
with GEN2_ES passed native incoming invitation, full pocket refusal/retry,
Mt. Silver unlock and duplicate prevention. All three completed the live
Kurt → Celebi catch → six-member healing → Giovanni → Ilex/radio lifecycle.
The final before-ring priority safeguard also passed the focused Gold live
probe; its late-native-call and intervening-warp paths are unit-tested.
Caller and gift images were inspected. All headless Celebi tests and the
workspace layout checks passed. Disposable profiles did not write user saves;
these results do not claim a physical Android test.
