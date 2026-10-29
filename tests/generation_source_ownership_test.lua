-- Run from the KASC repository with Lua 5.1 / LuaJIT.
local factory=assert(loadfile('backend_generation_rules_67.lua'))()
local data={schema='kasc.backend-generation-rules/v1',learnsetPaths={['1']='one',['2']='two'},
 groups={['2']={generation=1,order=1}}}
local catalog={entries={a={key='a',pokeapiId=1,isBase=true,originGeneration=1},
 b={key='b',pokeapiId=2,isBase=true,originGeneration=1}}}
local inputs={}
local function loader(path)
 local source={['2']={{1,1,'TACKLE',0},{1,1,'TACKLE',0},{1,1,'WITH:COLON',0},
  {1,1,'TACKLE',0,extra='preserved'},{1.5,1,'FRACTION',0}}}
 inputs[path]=source;return source
end
local M=factory{data=data,catalog=catalog,load=loader}
local a=M.learnset('a',1);local b=M.learnset('b',1)
assert(inputs.one['2'][1]~=inputs.one['2'][2],'loader duplicate rows overwritten')
assert(inputs.one['2'][1]~=inputs.two['2'][1],'loader inputs shared across species')
assert(a.rows[1]~=a.rows[2]and a.rows[1]~=b.rows[1],'public result rows shared')
a.rows[1][3]='CHANGED'
assert(a.rows[2][3]=='TACKLE'and M.learnset('a',1).rows[1][3]=='TACKLE','public mutation leaked')
assert(b.rows[3][3]=='WITH:COLON'and b.rows[4].extra=='preserved'and b.rows[5][1]==1.5,
 'row key collision or unsupported row lost')
local function up(fn,wanted)
 for i=1,100 do local name,value=debug.getupvalue(fn,i);if not name then break end
  if name==wanted then return value end
 end
end
local source=assert(up(M.learnset,'source'));local cache=assert(up(source,'cache'))
local one,two=cache[1]['2'],cache[2]['2']
assert(type(one.bytes)=='string'and type(two.bytes)=='string','historical references not packed')
assert(one.bytes:sub(1,4)==two.bytes:sub(5,8)and one.bytes:sub(1,4)~=string.char(0,0,0,0),'scalar row IDs not shared')
inputs.one['2'][1][3]='LOADER_CHANGED'
assert(M.learnset('a',1).rows[1][3]=='TACKLE','canonical value borrowed from loader')
assert(cache[1]['2']~=inputs.one['2'],'source array borrowed from loader')
assert(M.learnset('a',1,999)==nil,'invalid version group accepted')
print('PASS historical source ownership, exact row formats, duplicate/public mutation isolation')

local comparisons=0
local function equal(expected,actual)
 assert(type(expected)==type(actual))
 if type(expected)=='table'then
  for k,v in pairs(expected)do equal(v,actual[k])end
  for k in pairs(actual)do assert(expected[k]~=nil)end
 elseif type(expected)=='number'then
  if expected~=expected then assert(actual~=actual)else
   assert(expected==actual);if expected==0 then assert(1/expected==1/actual)end
  end
 else assert(expected==actual)end
 comparisons=comparisons+1
end
for _,method in ipairs{'','WITH:COLON','a'..string.char(0)..'b','ä終',string.char(255,0,128)}do
 for _,n in ipairs{-2147483648,-1,0,1,2147483647,2147483648,4294967295,.5,math.huge,-math.huge}do
  local rows={{n,7,method,-1},{n,7,method,-1},{-0.0,-0.0,method,-0.0},
   {1,2,method,3,extra='kept'},setmetatable({2,3,method,4},{tag='preserved'})}
  local facts=factory{data=data,catalog=catalog,load=function()return{['2']=rows}end}
  local result=facts.learnset('a',1);equal(rows,result.rows)
  assert(result.rows[1]~=result.rows[2]);result.rows[1][3]='PUBLIC_CHANGED'
  equal(rows,facts.learnset('a',1).rows)
 end
end
for _,rows in ipairs{{[1]={1,2,'A',3},[3]={4,5,'B',6}},{[1]={1,2,'A',3},metadata='kept'}, {}}do
 local facts=factory{data=data,catalog=catalog,load=function()return{['2']=rows}end}
 equal(rows,facts.learnset('a',1).rows)
end
print('PASS '..comparisons..' packed-source format/range/binary-string/signed-zero/ownership comparisons')
