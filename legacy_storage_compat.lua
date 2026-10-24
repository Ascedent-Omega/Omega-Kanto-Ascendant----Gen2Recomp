-- Gen2Recomp 0.8.x exposes mod-wide records, while Gen1Recomp exposes
-- playthrough records. Keep Legacy's transactional archive interface and
-- give the older host an explicit namespace belonging to a real New Game.
-- The namespace lives in modData, not engine meta (0.8.x rebuilds meta on save).
return function(mod)
  local storage = mod.storage
  if not storage or type(storage.edition) == "function"
      or type(storage.context) ~= "function"
      or type(storage.read) ~= "function"
      or type(storage.write) ~= "function"
      or type(storage.delete) ~= "function" then return storage end
  if type(require("src.core.SaveData").ensurePlaythroughId) == "function" then
    return storage
  end
  local ok, context = pcall(storage.context, storage, mod.game)
  -- Recognize the old bulk-storage contract, never infer it from a slot
  -- number alone or change the newer engine's opaque playthrough storage.
  if not ok or type(context) ~= "table"
      or context.root ~= "modstorage/" .. mod.id then return storage end

  local adapter = {}
  local scopeKey = "gen2_legacy_storage_scope"
  local function bucket(save)
    return type(save) == "table" and type(save.modData) == "table"
      and save.modData[mod.id] or nil
  end
  local function validId(id)
    return type(id) == "string" and #id == 32
      and id:match("^[0-9a-f]+$") ~= nil
  end
  function adapter.beginFresh(save)
    if type(save) ~= "table" then return false end
    save.modData = save.modData or {}
    save.modData[mod.id] = save.modData[mod.id] or {}
    local b = save.modData[mod.id]
    if b[scopeKey] ~= nil then return validId(b[scopeKey]) end
    local random = love and love.math and love.math.random or math.random
    local parts = {}
    for i = 1, 4 do parts[i] = string.format("%08x", random(0, 0x7fffffff)) end
    b[scopeKey] = table.concat(parts)
    return true
  end
  function adapter.adoptFresh(save)
    local b = bucket(save)
    if type(b) ~= "table" or b[scopeKey] ~= nil then return false end
    local origin = b.legacy_fresh_origin
    -- RC1 first campaigns have an authentic New Game receipt, but no
    -- archive namespace. Never adopt a started/imported Legacy lineage or
    -- turn a Gen1 identity into a different archive.
    if type(origin) ~= "table" or origin.version ~= 1
        or origin.edition ~= save.version or origin.playthroughId ~= nil
        or (save.meta and save.meta.playthroughId ~= nil)
        or b.legacy_journey ~= nil or b.legacy_lineage_handoff ~= nil
        or b.legacy_storage_binding ~= nil
        or type(storage.list) ~= "function" then return false end
    local keys = storage:list({ save = save }, "legacy_lineage")
    if type(keys) ~= "table" or next(keys) ~= nil then return false end
    return adapter.beginFresh(save)
  end
  local function keyFor(game, key)
    local save = game and game.save
    local b = bucket(save)
    local id = b and b[scopeKey]
    local edition = save and save.version
    if not validId(id) or type(edition) ~= "string"
        or not edition:match("^[%w_-]+$") then
      return nil, "Legacy archive needs a verified Gen2 New Game namespace"
    end
    if type(key) ~= "string" or key == "" or key:find("[^%w_/-]")
        or key:sub(1, 1) == "/" or key:find("//", 1, true) then
      return nil, "invalid Legacy archive key"
    end
    return "gen2_legacy/" .. edition .. "/" .. id .. "/" .. key
  end
  function adapter:edition(game)
    -- Resolve the incoming save on every operation: Continue and New Game
    -- replace game.save without replacing the game object or this facade.
    local facade = {}
    for _, method in ipairs({ "read", "write", "delete" }) do
      local operation = method
      facade[operation] = function(_, key, value)
        local scoped, err = keyFor(game, key)
        if not scoped then return nil, "unverified_scope", err end
        return storage[operation](storage, game, scoped, value)
      end
    end
    return facade
  end
  return adapter
end
