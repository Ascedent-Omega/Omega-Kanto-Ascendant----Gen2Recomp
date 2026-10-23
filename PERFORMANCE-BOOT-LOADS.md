# Boot loads: shared data files and lazy Gift Code catalogs

`main.lua` used to compile a fresh copy of every sibling file at each call
site (537 loads at boot). Two changes cut that work:

1. `loadShared(mod, filename)` keeps one compiled copy for ten files that no
   consumer mutates (each call site was checked): damage math, SHA-256, rank
   JSON, national catalog, national art, mega and Gigantamax metadata, held
   projectiles, Neo Crystal 2D and authored Crystal data. The first national
   art load stays a private `loadSibling` copy because the wave1 art modules
   patch its rows in place.
2. The three Gift Code catalogs (about 106,000 digests) are no longer loaded
   at boot. `gift_codes.lua` accepts a builder function and runs it the first
   time the Gift Code screen opens, a code is redeemed, or `catalogReady` /
   `hasCampaigns` is asked. The six cross-generation profiles still register
   at boot (`registerProfiles`); their digests join the catalog in the builder
   (`appendEvents`). If the builder fails, Gift Codes report "not available"
   instead of stopping the boot. A table catalog is still validated at once.

Measured headless with the audit bench (LuaJIT, compile + run of the boot
file list, not total game startup), three runs each, before -> after:
- loads: 537 -> 510
- compile + run: 763-999 ms -> 496-675 ms (about 30% less)
- data kept alive after boot: 67.5 -> 45.1 MiB
- one full GC over the boot data: 75-108 ms -> 40-46 ms (heap 110 -> 83 MiB)

The digests now cost their load time once, on the first Gift Code entry.

Validation:
- `tests/gift_catalog_lazy_test.lua`: no build at construction or from the
  start menu; one build on screen open; same "unknown" outcome as the eager
  path; failing builder; known-code lookup identical in both paths.
- `tests/kasc_boot_shared_test.lua`: `loadShared` only on the reviewed files,
  the wave1 art copy stays private, Gift catalogs only inside the builder.
- One-off check against `main`: old and new compositions give the same
  campaigns, events and 105,981 digests in the same order, and the same six
  profiles.
