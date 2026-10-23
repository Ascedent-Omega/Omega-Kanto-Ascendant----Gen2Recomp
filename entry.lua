-- Generation router for Kanto Ascendant (Gen 1 release for Gen2Recomp).
--
-- Red/Blue/Yellow run the complete Kanto entry. This release carries no
-- Gold/Silver/Crystal entry: on those cartridges the mod stays inactive.

local function loadSibling(mod, filename)
  local body, readErr = mod:read(filename)
  assert(type(body) == "string", readErr or ("unable to read " .. filename))
  local chunk, err = loadstring(body, "@" .. mod.path .. "/" .. filename)
  assert(chunk, err or readErr)
  return chunk()
end

return function(mod)
  local GameVersion = require("src.core.GameVersion")
  local resolveGeneration = loadSibling(mod, "lib/Gen2RecompedGeneration.lua")
  local currentGeneration = resolveGeneration(mod, GameVersion)
  if currentGeneration ~= 1 then
    mod.exports = mod.exports or {}
    mod.exports.active = false
    mod.exports.runtime = "inactive"
    if mod.log and type(mod.log.warn) == "function" then
      mod.log:warn(currentGeneration == 2
        and "Kanto Ascendant stays inactive: this release is for Red, Blue and Yellow. Gold, Silver and Crystal support will ship as a separate release."
        or "Kanto Ascendant stays inactive: unsupported generation")
    end
    return
  end
  mod.exports = mod.exports or {}
  mod.exports.generation = currentGeneration
  mod.exports.runtime = "gen1"
  loadSibling(mod,"lib/Gen2RecompedBattleContract.lua").install()
  local current = type(GameVersion.get) == "function"
    and GameVersion.get() or mod.gameVersion
  local prefix="integrated/ascendant_startup/"
  local card=loadSibling(mod,prefix.."StartupCard.lua").attach(mod,prefix)
  mod.exports.startupCard={apiVersion=1,status=function()return card:status()end}
  mod.exports.hdDownloadSupport=loadSibling(mod,'hd_download_support.lua')(
    mod,loadSibling(mod,'hd_download_log.lua'))

  mod.exports.expandedStorage = loadSibling(mod, "expanded_storage.lua")(mod, currentGeneration)
  loadSibling(mod, "main.lua")(mod)

  local Serializer = require("src.core.SaveSerializer")
  local i18n = loadSibling(mod, "localization.lua")(mod)
  local sha256 = loadSibling(mod, "legacy_bank_sha256.lua")
  local mega = mod.exports and mod.exports.megaEvolution or nil
  local crossGenerationItems = { MEGA_RING = true }
  for _, profile in ipairs(mega and mega.forms or {}) do
    if type(profile) == "table" and type(profile.stone) == "string" then
      crossGenerationItems[profile.stone] = true
    end
  end
  local function classifyItem(id)
    return crossGenerationItems[tostring(id or ""):upper()]
      and "crossgen_mega" or "kanto_only"
  end
  local Vault = loadSibling(mod, "legacy_bank_vault.lua")({
    serializer = Serializer,
    sha256 = sha256,
    classifyItem = classifyItem,
    megaProfiles = mega and mega.forms or {},
  })
  local Store = loadSibling(mod, "legacy_bank_store.lua")({
    serializer = Serializer,
    sha256 = sha256,
    vault = Vault,
  })
  local archive = mod.exports and mod.exports.legacyJourney
    and mod.exports.legacyJourney.archive or nil
  if archive and type(archive.bindSha256) == "function" then
    assert(archive.bindSha256(sha256))
  end
  return loadSibling(mod, "legacy_bank_bridge.lua")(mod, {
    serializer = Serializer,
    sha256 = sha256,
    vault = Vault,
    store = Store,
    archive = archive,
    itemRuntime = mega,
    classifyItem = classifyItem,
    edition = function()
      return type(GameVersion.get) == "function"
        and GameVersion.get() or GameVersion.current or current
    end,
    generation = function()
      return resolveGeneration(mod, GameVersion)
    end,
    i18n = i18n,
  })
end
