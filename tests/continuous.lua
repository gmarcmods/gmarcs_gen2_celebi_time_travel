local install=dofile('mods/gen2/celebi_mod/lib/Quest.lua')
local Progress=dofile('mods/gen2/celebi_mod/lib/Progress.lua')
local events,hooks,commands,actors={},{},{},{}
local bucket={quest={phase='restless'}}
local game={save={party={},inventory={GS_BALL=1}}}
local w={map={id='ILEX_FOREST',def={bgEvents={{x=8,y=22,scriptKey='SHRINE'}}}},player={cellX=8,cellY=23,scriptFace=function()end}}
function w:healParty()for _,m in ipairs(game.save.party)do m.hp=m.maxHp;m.status=nil;m.moves[1].pp=35 end end
function w:playCry()end
local mod={save={get=function(_,k,d)return bucket[k]or d end,set=function(_,k,v)bucket[k]=v end},
 events={on=function(_,id,fn)events[id]=fn end},hooks={wrap=function(_,id,fn)hooks[id]=fn end},commands={register=function(_,id,fn)commands[id]=fn end},
 world={overworld=function()return w end,spawnNpc=function(_,map,d)actors[d.name]={def=d};return d.name end,
 npc=function(_,map,id)return {npc=actors[id],face=function()end,setPassable=function()end}end,removeNpc=function(_,id)actors[id]=nil end}}
local kurtGone=false
local quest=install(mod,Progress,{remove=function()game.save.inventory.GS_BALL=nil end},function()
 return {reconcile=function()end,congratulate=function(ctx,say)
  for _,m in ipairs(game.save.party)do assert(m.hp==m.maxHp and not m.status and m.moves[1].pp==35,'team was not fully healed before Kurt/history')end
  say(ctx,'congratulations');kurtGone=true
 end}
end,{}, {attach=function()end,detach=function()end})
events['game.ready']({game=game})
local ctx={scriptKey='SHRINE',vm={showText=function(_,id)coroutine.yield(id)end,waitFrames=function()end,writeVarFn=function()end}}
local function start()
 local co=coroutine.create(function()return hooks['script.command'](function()error('native shrine escaped')end,ctx,'jumptext',{}, {})end)
 local ok,v=coroutine.resume(co);assert(ok,v);return co,v
end
for i=1,6 do game.save.party[i]={species='PIDGEY',hp=1,maxHp=50,status='PSN',moves={{id='TACKLE',pp=0}}}end
local co,v=start();assert(v=='CELEBI_MOD:partyFull','full party must block before offering GS Ball placement')
assert(game.save.inventory.GS_BALL==1 and bucket.quest.phase=='restless','full-party rejection consumed the GS Ball')
assert(coroutine.resume(co));table.remove(game.save.party)
co,v=start();assert(v=='CELEBI_MOD:shrine')
local ok;ok,v=coroutine.resume(co);assert(ok and v.kind=='yesorno')
ok,v=coroutine.resume(co,true);assert(ok and v=='CELEBI_MOD:inserted')
ok,v=coroutine.resume(co);assert(ok and v.kind=='waitsfx')
ok,v=coroutine.resume(co);assert(ok and v.kind=='battle')
local battle={};local celebi={species='CELEBI',hp=1,maxHp=100,status='PAR',moves={{id='CONFUSION',pp=0}}}
game.save.party[6]=celebi
local originalLead=game.save.party[1]
quest:setHistory(function(c,g,mon)
 assert(kurtGone,'history began before Kurt left')
 assert(mon==celebi and g.save.party[6]==celebi,'automatic history did not use the just-caught Celebi')
 assert(g.save.party[1]==originalLead,'event reordered the real team')
 coroutine.yield('AUTO_TRAVEL');return true
end)
events['battle.started']({kind='wild',species='CELEBI',battle=battle})
events['pokemon.caught']({game=game,species='CELEBI',battle=battle,mon=celebi,destination='party'})
ok,v=coroutine.resume(co,'caught');assert(ok,v);assert(v=='CELEBI_MOD:congratulations')
ok,v=coroutine.resume(co);assert(ok,v);assert(v=='AUTO_TRAVEL','event required another player interaction after Kurt left')
assert(bucket.quest.kurtCongratulated)
assert(coroutine.resume(co));assert(coroutine.status(co)=='dead')
print('CELEBI CONTINUOUS PASS: full-party guard, healing HP/status/PP, Kurt departure directly into history, team order preserved')
