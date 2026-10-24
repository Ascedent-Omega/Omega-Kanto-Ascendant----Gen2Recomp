## Kanto Ascendant 6.7.35 - 2026-10-24

Fix: the mod no longer fails to load with "SpriteMirrorFetch:9: missing transport
dependency" on Gen2Recomp. The engine has no mod download API; HdBinaryFetch now
returns an offline transport, so HD and Cobblemon download screens report the
network as unavailable. Seen on Android and PC with only VASC and KASC enabled.

## Kanto Ascendant 6.7.34 - 2026-10-23

Gen 1 release for Gen2Recomp (Gen2Recomped 0.8.45). Red, Blue and Yellow run
the full Kanto entry; the Gold/Silver/Crystal entry is left out and the mod
stays inactive on those cartridges. Built from the Johto Ascendant 6.7.37
snapshot with the Gen2Recomped port: optional engine seams (RomText, battle
checkpoint), lazy gift catalogue, shared data tables at boot, new Mega sprite
sets and shorter ASCENDANT menu labels.

