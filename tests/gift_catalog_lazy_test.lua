-- Gift Code catalogs load on first use: profiles still register at boot, the
-- ~106k digests are only built when the Gift Code screen or a redeem needs them.
local function load(name) return assert(loadfile(name))() end

local function archive()
  local profiles = {}
  local root = {}
  return {
    profile = function(id) return profiles[id] end,
    registerGiftProfiles = function(list)
      for _, p in ipairs(list) do profiles[p.id] = p end
      return #list
    end,
    state = function() return root end,
    persist = function() return true end,
  }
end

local function fakeMod()
  local hooks, screens = {}, {}
  return {
    hooks = { wrap = function(_, name, fn) hooks[name] = fn end },
    content = { screens = { register = function(_, name, def) screens[name] = def end } },
    events = { on = function() end },
    ui = {
      insertBefore = function(list, _, item) list[#list + 1] = item; return list end,
      ListMenu = { new = function(_, _, rows) return { rows = rows } end },
    },
  }, hooks, screens
end

local sha256 = load("legacy_bank_sha256.lua")
-- Attempts are rate-limited; move the clock on between redeems.
local clock = 0
local function now() clock = clock + 100; return clock end
local game = { writeSave = function() return true end }
local cross = load("cross_generation_gift_profiles_66.lua")
local ev = archive()
local registered = ev.profile
assert(cross.registerProfiles(ev))
for _, p in ipairs(cross.profiles) do assert(ev.profile(p.id) == p) end
-- The base catalogs' profiles come from other owners at real boot.
ev.profile = function(id) return registered(id) or { id = id } end

local builds = 0
local function builder()
  builds = builds + 1
  local catalog = load("gift_code_catalog.lua")
  local stats = cross.appendEvents(catalog)
  assert(stats.campaignEvents == 16 and stats.campaignDigests == 48000)
  for _, file in ipairs({ "alola_gift_code_catalog.lua", "backend_gift_code_catalog_67.lua" }) do
    for _, campaign in ipairs(load(file).campaigns or {}) do
      catalog.campaigns[#catalog.campaigns + 1] = campaign
    end
  end
  return catalog
end

local mod, hooks, screens = fakeMod()
local G = load("gift_codes.lua")(mod, {
  catalog = builder, eventArchive = ev, sha256 = sha256, now = now, enabled = function() return true end,
})
assert(builds == 0, "catalog built at construction")

-- The start menu shows the row without building the catalog.
local items = hooks["ui.start_menu.items"](function() return {} end, {}, {})
assert(#items == 1 and items[1].ascendantKey == "gift_codes")
assert(builds == 0, "start menu built the catalog")

-- Opening the screen builds it once and offers ENTER CODE.
local menu = screens.KantoGiftCodes.new({})
assert(builds == 1 and menu.rows[1] and menu.rows[1].value == "enter")
screens.KantoGiftCodes.new({})
assert(G.catalogReady() and G.hasCampaigns() and G.catalogError() == nil)
assert(builds == 1, "catalog built more than once")

-- Unknown code: same outcome as the eager path.
local out = G.redeem(game, "23456789")
assert(out and out.status == "unknown", tostring(out and out.status))

-- A builder that fails makes Gift Codes unavailable instead of crashing boot.
local mod2 = fakeMod()
local broken = load("gift_codes.lua")(mod2, {
  catalog = function() error("boom") end, eventArchive = ev,
  enabled = function() return true end,
})
local bad = broken.redeem(game, "23456789")
assert(bad.status == "unavailable" and not broken.catalogReady())
assert(tostring(broken.catalogError()):find("boom", 1, true))

-- A table catalog is still validated at once (old behaviour).
local mod3 = fakeMod()
local eager = load("gift_codes.lua")(mod3, {
  catalog = builder(), eventArchive = ev, sha256 = sha256, now = now, enabled = function() return true end,
})
assert(eager.catalogReady() and eager.hasCampaigns())
assert(eager.redeem(game, "23456789").status == "unknown")

-- A known code finds its digest the same way through both paths.
local fixture = function()
  return { schema = "ka-offline-gift-code-catalog/v1", version = 1, campaigns = {
    { version = 1, id = "lazy-test", buildId = "t", status = "active", testOnly = true,
      events = { { version = 1, id = "e1", profileId = "lazy-profile",
        digests = { sha256("23456789") } } } } } }
end
local statuses = {}
for i, source in ipairs({ fixture, fixture() }) do
  local m = fakeMod()
  local a = archive()
  a.registerGiftProfiles({ { id = "lazy-profile" } })
  local g = load("gift_codes.lua")(m, { catalog = source, eventArchive = a,
    sha256 = sha256, now = now, allowTestFixtures = true, enabled = function() return true end })
  statuses[i] = g.redeem(game, "2345-6789").status
end
assert(statuses[1] == statuses[2], statuses[1] .. " vs " .. statuses[2])
assert(statuses[1] ~= "unknown" and statuses[1] ~= "unavailable", statuses[1])

print("gift_catalog_lazy_test ok")
