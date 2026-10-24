## Gen2Recomp startup transport fix (release candidate)

On engines without mod.fetch, the optional sprite downloader no longer aborts mod initialization. Downloads return a clear unavailable message, while bundled graphics and file imports remain available. Native Gen1 transports and the Windows binary worker retain their existing behavior.

Distribution: retain the unchanged Gen1Recomp packages (VASC 3.0.63 / KASC 6.7.33), and provide separate Gen2Recomp candidates (VASC 3.0.65-rc.1 / KASC 6.7.35-rc.1). Gen2Recomp rejects the compute permission required by the Gen1 packages; one universal ZIP is not supported. Both Gen2 candidates are for Red, Blue and Yellow only.

Validation: the reported failure is reproduced by the actual Gen2Recomped 0.8.45 loader and removed by this patch. Both stable Gen1 packages load in Gen1Recomp 0.3.96. Offline transport tests cover Android, iOS, macOS, Linux and Windows simulations; existing Windows binary-streaming, bounds, timeout and cancellation tests pass. These checks do not constitute a full playthrough or a physical Android/iOS test.

# Kanto Ascendant 6.7.33 — Omega continuation intro

Replaces the shared New Game / Continue intro in the complete 6.7.32 baseline.

- Preserves the Roxas2712 opening, followed by a Cobblemon Lugia flyby and Lugia cry that sweep the original scene away.
- Shows “Continued by” with Omega Dias' existing OASC wordmark and the white Eye Omega animation together on black.
- “Omega Ascendant Team” replaces the original GIF caption. Eye, Omega, triangle and blink poses follow the GameCube startup tones; the finished logo and caption settle on the final chord.
- The complete GameCube startup sound retains its original tempo and pitch. The animation follows the audible sample cursor and holds the finished logo through the decay.
- Both mods use the same intro and retain shared ownership, SFX volume, mute, skip and native preparation behavior.

Install the complete ZIP by replacing the existing mod copy. Keep saves and settings. Update both mods together: [voxel-ascendant 3.0.63](https://github.com/Ascedent-Omega/voxel-ascendant/releases/tag/v3.0.63). No separate intro mod is needed.

Validation: native LOVE 11.5/12 scene and audio checks, cue and audio-cursor synchronization, terminal logo hold, portrait drawing, resource cleanup, both mod ownership orders, Gen1/Gen2 entry lifecycle, mandatory readiness after long loads, skip and EN/DE startup labels. Source syntax, ZIP integrity and file receipts are checked before publication. Physical mobile/NX tests have not been run for this intro update.
