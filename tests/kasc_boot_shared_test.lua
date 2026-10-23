-- main.lua shares one loaded copy only for files no consumer mutates. Adding a
-- file here needs the same check of every call site.
local allowed = {
  ["pokemon_damage_math_67.lua"] = true, ["legacy_bank_sha256.lua"] = true,
  ["world_rank_json.lua"] = true, ["backend_national_catalog_67_data.lua"] = true,
  ["backend_national_art_67_data.lua"] = true, ["backend_mega_catalog_67_data.lua"] = true,
  ["backend_gigantamax_catalog_67_data.lua"] = true,
  ["pokemon_held_projectiles_67_data.lua"] = true, ["neo_crystal_2d_67_data.lua"] = true,
  ["authored_crystal_67_data.lua"] = true,
}
local f = assert(io.open("main.lua", "rb"))
local src = f:read("*a")
f:close()
local shared = 0
for name in src:gmatch("loadShared%(%s*mod%s*,%s*['\"]([^'\"]+)['\"]") do
  assert(allowed[name], "loadShared on an unreviewed file: " .. name)
  shared = shared + 1
end
assert(shared == 34, "expected 34 shared call sites, got " .. shared)
-- The wave1 art modules patch this copy's rows in place: it must stay private.
assert(src:find('local art = loadSibling(mod, "backend_national_art_67_data.lua")', 1, true),
  "the art copy patched by wave1 must stay a fresh loadSibling")
-- Gift catalogs are no longer loaded at boot.
for _, name in ipairs({ "gift_code_catalog.lua", "alola_gift_code_catalog.lua",
    "backend_gift_code_catalog_67.lua" }) do
  local at = src:find(name, 1, true)
  assert(at, name .. " missing from main.lua")
  local before = src:sub(math.max(1, at - 600), at)
  assert(before:find("catalog = function()", 1, true), name .. " loaded outside the lazy builder")
end
assert(not src:find("crossGenerationGiftProfiles66.register(", 1, true))
print("kasc_boot_shared_test ok (" .. shared .. " shared sites)")
