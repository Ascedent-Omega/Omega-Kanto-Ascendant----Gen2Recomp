## 6.7.35-rc.2 — gameplay follow-up (RC)

The same two Universal ZIPs remain the installation for both Recomps. Update both mods together.

KASC now adapts Gen2Recomp 0.8.x's mod-wide record storage to a separate persistent Legacy namespace for each genuine New Game. Saving/loading no longer misclassifies a new Gen2 campaign as an unmigrated pre-sandbox archive. Eligible RC1 first campaigns are adopted only when their New Game receipt is valid and no existing Legacy lineage, binding or old archive is present. Existing Legacy history is never silently replaced. Gen1Recomp keeps its native storage API.

The installation instructions now call out the bundled Gen2Recomped-DramaticShapes conflict. See GAMEPLAY_QA.md for the completed gameplay checks and their limits. This remains a prerelease; an Android emulator does not establish compatibility with every physical phone.

## 6.7.35-rc.1 — one ZIP for both Recomps (RC)

The Universal ZIP contains one shared current runtime for Gen1Recomp 0.3.96–0.3.x and Gen2Recomped 0.8.45–0.8.x. Red, Blue and Yellow are supported. Install the matching Universal RC of the companion mod as well.

The missing optional download transport no longer aborts startup. Both manifests keep API 2 and use only permissions understood by both engines. Optional mod-created workers fall back safely; Windows binary downloads use the engine-owned file pool where native staging is compatible. Windows portable-mode optional downloads and Gen2Recomp optional downloads remain unavailable.

Use the Universal ZIP release assets, replace both old mod folders, and preserve saves, options and mod_cache. See README.md and INSTALL.txt for the complete English/German instructions. This is a release candidate, with physical Android/iOS and complete playthrough verification still pending.

## Historical release notes

The notes below describe earlier packages and do not expand the supported games or validation of this Universal RC.

# Kanto Ascendant 6.7.33 — Omega continuation intro

Replaces the shared New Game / Continue intro in the complete 6.7.32 baseline.

- Preserves the Roxas2712 opening, followed by a Cobblemon Lugia flyby and Lugia cry that sweep the original scene away.
- Shows “Continued by” with Omega Dias' existing OASC wordmark and the white Eye Omega animation together on black.
- “Omega Ascendant Team” replaces the original GIF caption. Eye, Omega, triangle and blink poses follow the GameCube startup tones; the finished logo and caption settle on the final chord.
- The complete GameCube startup sound retains its original tempo and pitch. The animation follows the audible sample cursor and holds the finished logo through the decay.
- Both mods use the same intro and retain shared ownership, SFX volume, mute, skip and native preparation behavior.

Install the complete ZIP by replacing the existing mod copy. Keep saves and settings. Update both mods together: [voxel-ascendant 3.0.63](https://github.com/Ascedent-Omega/voxel-ascendant/releases/tag/v3.0.63). No separate intro mod is needed.

Validation: native LOVE 11.5/12 scene and audio checks, cue and audio-cursor synchronization, terminal logo hold, portrait drawing, resource cleanup, both mod ownership orders, Gen1/Gen2 entry lifecycle, mandatory readiness after long loads, skip and EN/DE startup labels. Source syntax, ZIP integrity and file receipts are checked before publication. Physical mobile/NX tests have not been run for this intro update.
