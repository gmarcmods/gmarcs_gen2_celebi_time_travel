# Third-party field art

## Celebi — GSC / Poke Followers pack

Selected from the user-supplied `mods/gen1/overworld-spawn-mod` (Wilds of Kanto):
`assets/enhanced_overworld/poke_followers/follower_251_normal.png`.

The upstream mod credits its built-in GSC walker pack to the Followers EX /
PokePC Followers / ShockSlayer (Pokémon Crystal Clear) lineage. It explicitly
does not claim ownership of this third-party artwork. No separate license or
sprite-specific author is established by the supplied file; this mod makes
no new ownership or licensing claim over it. Preserve that attribution when
redistributing. Upstream sources named by the supplied notices:

- https://github.com/masterwebx/gen1recomp-followers-ex
- https://github.com/gamecorner-033/PokePCFollowers

This is the GSC pack, not Wilds' separate HGSS/PokeMMO or PMDCollab asset set.
No PMDCollab license or contributor attribution is asserted for this sheet.

Adaptation: native grayscale palette encoding and transparent RGB normalization
only. Original opaque colors, frame order and pixel silhouettes are retained
through `FieldArt.celebiColors`. The editable source records the original file
SHA256. No artwork was taken from a ROM during this adaptation.

## Giovanni — original Pokémon Red art

Giovanni's overworld sheet and battle portrait are read from the player's
own imported Red cache at runtime. No ROM-derived bytes are shipped with
this mod. The paths are resolved from `assets/generated/sprites/giovanni.png`
and `assets/generated/battle/trainers/giovanni.png` in the player's cache.

The old custom drawing remains under `art/giovanni-authored/` only as a
development reference.
