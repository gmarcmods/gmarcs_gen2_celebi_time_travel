# Changelog

## 0.0.14
- Renamed to gmarcs_gen2_celebi_time_travel.
- Removed ROM-derived Giovanni images; reads from player cache.

## 0.0.15
- Display name is now **Gmarc's Gen 2 Celebi Through Time**; the "(development)"
  label is gone.
- The mod id stays `gmarcs_gen2_celebi_time_travel`. It is the update key: a
  released mod that changes its id can never receive an in-place update, and the
  launcher would install the new build as a separate mod.
- Release ZIP is `gmarcs_gen2_celebi_time_travel-<version>.zip`, the name
  `ModUpdate.pickZipAsset` prefers.
- Still 0.0.x: `docs/plan/ROADMAP.md` records the quest as incomplete.

## 0.0.16
- The Oak invitation no longer renames the bike shop's phone contact for good.
  Contact 2 is the shop's row on every cartridge (its caller script is the
  shop's, and StepEvents queues the bike-shop call on it), so the invitation
  borrows the name for the length of its own call and puts the row's previous
  name back afterwards. That keeps "BIKE SHOP" in English and "TIENDA BICIS" in
  Spanish, including on the shop's own call.
- A dataset without that contact now disables the invitation instead of failing
  the whole mod to load.

## 0.0.17
- The Oak name now actually reaches the caller-ID box. 0.0.16 held
  `Phone.CONTACTS[2]` from install time, but `Phone.useRegistry`
  (src/core/Game2.lua:1226) replaces that table with a fresh copy after the
  mods load, so the borrow was writing into an orphan and the box still said
  BIKE SHOP / TIENDA BICIS. The row is now looked up when the call starts and
  written back by index when it ends. The Oak test rebuilds the table after
  install to cover exactly this.
