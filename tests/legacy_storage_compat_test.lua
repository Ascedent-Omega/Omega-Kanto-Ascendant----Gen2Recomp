local root = assert(arg[1])
local factory = assert(loadfile(root .. '/legacy_storage_compat.lua'))()
local SaveData = {}
package.loaded['src.core.SaveData'] = SaveData
local records, calls, serial = {}, 0, 0
love = {math={random=function()serial=serial+1;return serial end}}
local store = {
 context=function()calls=calls+1;return {root='modstorage/kanto_ascendant'}end,
 read=function(_,g,k)return records[k] end,
 write=function(_,g,k,v)records[k]=v;return true end,
 delete=function(_,g,k)records[k]=nil;return true end,
 list=function(_,g,prefix)local out={};for k in pairs(records)do if k:sub(1,#prefix)==prefix then out[#out+1]=k end end;return out end,
}
local mod={id='kanto_ascendant',storage=store}
local compat=factory(mod);assert(compat~=store)
local game={save={version='red'}};local bound=compat:edition(game)
local before=next(records)
assert(not bound:write('legacy/archive',{x=1}));assert(next(records)==before)
assert(compat.beginFresh(game.save));local first=game.save
assert(bound:write('legacy/archive',{x=1}));assert(bound:read('legacy/archive').x==1)
game.save={version='red'};assert(compat.beginFresh(game.save));local second=game.save
assert(not bound:read('legacy/archive'));assert(bound:write('legacy/archive',{x=2}))
game.save=first;assert(bound:read('legacy/archive').x==1)
assert(compat.beginFresh(first));assert(bound:read('legacy/archive').x==1)
first.version='blue';assert(not bound:read('legacy/archive'));first.version='red'
assert(not bound:write('../legacy/archive',{x=3}));assert(not bound:write('/legacy/archive',{x=3}))
assert(bound:delete('legacy/archive'));assert(not bound:read('legacy/archive'))
game.save=second;assert(bound:read('legacy/archive').x==2)
local function rc1()return {version='red',modData={kanto_ascendant={legacy_fresh_origin={version=1,edition='red'}}}}end
local old=rc1();assert(compat.adoptFresh(old));assert(old.modData.kanto_ascendant.gen2_legacy_storage_scope)
for _,field in ipairs({'legacy_journey','legacy_lineage_handoff','legacy_storage_binding'})do
 local unsafe=rc1();unsafe.modData.kanto_ascendant[field]={};assert(not compat.adoptFresh(unsafe))
end
local foreign=rc1();foreign.modData.kanto_ascendant.legacy_fresh_origin.playthroughId='foreign';assert(not compat.adoptFresh(foreign))
local unsafe=rc1();records['legacy_lineage/files/old']={};assert(not compat.adoptFresh(unsafe));records['legacy_lineage/files/old']=nil
assert(not compat.adoptFresh({version='red'}))
-- The modern host must not allocate an identity just to detect capabilities.
SaveData.ensurePlaythroughId=function()error('must not allocate provisional ID')end
local oldCalls=calls;assert(factory(mod)==store);assert(calls==oldCalls)
SaveData.ensurePlaythroughId=nil
local modern={edition=function()end};assert(factory({id=mod.id,storage=modern})==modern)
local unknown={context=function()return {root='other'}end};assert(factory({id=mod.id,storage=unknown})==unknown)
print('PASS Gen2 Legacy namespaces: new game, slot/edition isolation, dynamic Continue, no unverified writes, Gen1 delegation')
