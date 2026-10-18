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

At the user's explicit request, the original Giovanni overworld sheet and
battle portrait from their validated Red import are saved directly in this
mod as `assets/giovanni.png` (16x96) and `assets/giovanni-battle.png` (56x56).
The decoded PNGs were copied unchanged, byte for byte. No ROM file is copied
or packaged. These are original Pokémon graphics, not newly authored work;
rights remain with their original owners (Nintendo / Creatures / GAME FREAK).

`art/giovanni/source.json` records their source paths and SHA256 hashes. They
can be edited locally in Pixelorama if a later visual review requires it;
update that source record when deliberately changing them. The old custom
drawing remains under `art/giovanni-authored/` only as a development reference.
There is no runtime Gen 1 import requirement or authored fallback selection.
