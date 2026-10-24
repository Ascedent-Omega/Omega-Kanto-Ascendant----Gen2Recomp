# Kanto Ascendant 6.7.35-rc.1

## Engine-specific downloads

This Gen2Recomp package is a release candidate fixing the missing optional download transport at startup. For Gen1Recomp, use the unchanged stable Kanto Ascendant 6.7.33 package from the original Ascendant repository. Gen1Recomp and Gen2Recomp need separate manifests and downloads. Both Gen2 packages must be updated together. Android hardware verification is pending.


**A living, 251-Pokémon Kanto for Pokémon Red, Blue and Yellow, on Gen2Recomp.**

Kanto Ascendant (KASC) expands the Gen 1 adventure: more Pokémon to find, wild Pokémon that roam the routes, ranked trainer rematches, research habitats, shinies, Mega Evolution and a full post-game, while the original story stays intact. It is a mod for the **Gen2Recomp** engine (Gen2Recomped 0.8.45 or newer in the 0.8 line) and is made to run together with **[Voxel Ascendant](https://github.com/Ascedent-Omega/Voxel-Omega-Ascendant-----Gen2Recomp)**, which draws it all in 3D.

> This release is for **Red, Blue and Yellow only**. On Gold, Silver and Crystal the mod stays switched off and says so in the log. Gen 2 support will come later as a separate release.

## What's in it

- **251 Pokémon in Kanto.** Optional early Johto migrations, Gorochu, regional forms, and the mythical Mew and Celebi signals.
- **Wilds of Kanto.** Wild Pokémon walk the overworld with their own habits, and research habitats show where each species lives.
- **Trainers that come back.** Ranked rematches, a difficulty setting and a story level cap.
- **Mega Evolution.** The Mega Ring, Mega Stones and the Route 5 Evolution Machine, with animated Mega sprites.
- **Shinies, gifts and the bank.** Shiny Pokémon, gift codes, expanded PC storage and the Legacy Bank.
- **The ASCENDANT menu.** One start-menu hub for every option, in English and German.

## New in 6.7.35-rc.1

- **Gen2Recomp support.** Runs on Gen2Recomped 0.8.45. Parts of the battle and text code that this engine lays out differently are now optional, so a missing engine module switches one detail off instead of stopping the mod.
- **Gen 1 only.** The Gold/Silver/Crystal entry (Gen 2 menus, Gen 2 Mega bridge, Johto wardrobe and Gen 2 trainer progress) is not part of this package.
- **Faster start.** The gift catalogue and gift profiles load only when they are first needed, and shared data tables are read once instead of several times.
- **Mega Evolution.** New Mega sprite sets, including animated Megas.
- **Menus.** Shorter, clearer ASCENDANT menu labels.

## Install

1. Install **Gen2Recomp** (Gen2Recomped 0.8.45) and import your own Red, Blue or Yellow cartridge in its launcher.
2. Close the game. If you already have Kanto Ascendant, keep a copy of your `mods/kanto_ascendant` folder.
3. Download `Kanto-Ascendant-6.7.35-rc.1.zip` from the [release page](../../releases), delete the old `mods/kanto_ascendant` folder and unzip the new one into `mods/`. You should end up with `mods/kanto_ascendant/entry.lua`.
4. Install **Voxel Ascendant 3.0.64** the same way. Update both mods together.
5. Start the game. Your saves and settings are kept.

## Known limitations

- Tested on Windows PC with Pokémon Yellow. **Android has not been tested on a real phone yet.**
- In-game HD downloads are switched off on Gen2Recomp: the engine does not offer the download feature they need yet.
- A save that was carried over from another engine can log a "Legacy archive" message. Your save still loads and plays; only the Legacy Bank history from the old engine is not linked.

## Credits

- **Roxas2712 (Pandy)**: the original Kanto Ascendant and Voxel Ascendant.
- **Omega Ascendant Team (Omega Dias)**: the continuation of both mods.
- **Cedric / UNDERdecoded**: the Gen2Recomp engine.
- **Wilds of Kanto contributors**: the bundled Wilds 1.12.2 overworld Pokémon.
- **pret** contributors: the pokered and pokecrystal disassemblies.

Sprites, cries and music sources are listed in [THIRD_PARTY_NOTICES.md](THIRD_PARTY_NOTICES.md).

Pokémon is © Nintendo, Creatures Inc. and GAME FREAK inc. This is an unofficial, non-commercial fan mod, not affiliated with or endorsed by them. Gen2Recomp is a separate project with its own licence; no engine file and no ROM is included here.
