local Progress=assert(loadfile('mods/gen2/celebi_mod/lib/Progress.lua'))()
local install=assert(loadfile('mods/gen2/celebi_mod/lib/Quest.lua'))()
local bucket,events,hooks,commands,actors={},{},{},{},{}
local game={save={inventory={},hallOfFame={count=0}}}
local world={map={id='GOLDENROD_POKECENTER_1F'},player={cellX=3,scriptFace=function()end}}
function world:busy()return false end
local ctx={vm={showText=function(_,id)coroutine.yield(id)end}}
local co
world.vm={start=function(_,rows)
 co=coroutine.create(function()return commands[rows[1].verb](ctx)end)
 local ok,why=coroutine.resume(co);assert(ok,why);return true
end}
local canGive=false
local api={
 overworld=function()return world end,
 spawnNpc=function(_,map,def)actors.actor={};return 'actor'end,
 npc=function(_,map,id)return actors[id]and{
  face=function()return true end,
  scriptMove=function(_,dir,tiles,done)done();return true end,
 }end,
 removeNpc=function(_,id)actors[id]=nil;return true end,
}
local mod={world=api,
 save={get=function(_,k,default)return bucket[k]or default end,set=function(_,k,v)bucket[k]=v end},
 events={on=function(_,id,fn)events[id]=fn end},
 hooks={wrap=function(_,id,fn)hooks[id]=fn end},
 commands={register=function(_,id,fn)commands[id]=fn end},
}
local quest=install(mod,Progress,{add=function()if canGive then game.save.inventory.GS_BALL=1;return true end;return false end})
events['game.ready']({game=game})
local exits=0
local function next_(map,x,y)exits=exits+1;return map,x,y end
local warp=hooks['warp.destination']
assert(warp(next_,'GOLDENROD_CITY',1,1,{})=='GOLDENROD_CITY'and exits==1)
game.save.hallOfFame.count=1
assert(warp(next_,'GOLDENROD_CITY',1,1,{})==nil)
assert(coroutine.status(co)=='suspended')
assert(warp(next_,'GOLDENROD_CITY',1,1,{})==nil and exits==1,'second carpet check escaped an active delivery')
assert(coroutine.resume(co));assert(quest.progress:phase()=='none','full bag committed delivery')
assert(coroutine.resume(co));assert(coroutine.status(co)=='dead'and not actors.actor)
assert(warp(next_,'GOLDENROD_CITY',1,1,{})=='GOLDENROD_CITY','full bag trapped the player in the center')
events['map.entered']({mapId='GOLDENROD_POKECENTER_1F'});canGive=true
assert(warp(next_,'GOLDENROD_CITY',1,1,{})==nil)
assert(coroutine.resume(co));assert(quest.progress:phase()=='delivered'and game.save.inventory.GS_BALL==1)
while coroutine.status(co)~='dead'do assert(coroutine.resume(co))end
assert(not actors.actor,'delivery actor leaked')
assert(warp(next_,'GOLDENROD_CITY',1,1,{})=='GOLDENROD_CITY','completed delivery blocked ordinary exit')
bucket.quest={version=1,phase='encounter'}
events['battle.started']({kind='wild',species='CELEBI',battle={}})
events['pokemon.caught']({game=game,species='CELEBI',battle={}})
assert(quest.progress:phase()=='encounter','unrelated catch advanced the quest')
world.map={id='ILEX_FOREST',def={bgEvents={{x=8,y=22,scriptKey='SHRINE'}}}}
game.save.party={{hp=10}}
ctx.scriptKey='SHRINE'
ctx.vm.writeVarFn=function(id,value)assert(id==3 and value==11)end
co=coroutine.create(function()return hooks['script.command'](function()error('native shrine was not intercepted')end,ctx,'jumptext',{}, {})end)
local ok,request=coroutine.resume(co);assert(ok and request=='CELEBI_MOD:retry')
ok,request=coroutine.resume(co);assert(ok and request.kind=='yesorno')
ok,request=coroutine.resume(co,true);assert(ok and request.kind=='battle'and request.wild.species==251 and request.wild.level==30)
local battle={}
events['battle.started']({kind='wild',species='CELEBI',battle=battle})
events['pokemon.caught']({game=game,species='CELEBI',battle={}})
events['pokemon.caught']({game={},species='CELEBI',battle=battle})
events['pokemon.caught']({game=game,species='PIDGEY',battle=battle})
assert(quest.progress:phase()=='encounter','wrong battle/game/species advanced the quest')
events['pokemon.caught']({game=game,species='CELEBI',battle=battle})
assert(quest.progress:phase()=='caught','matching settled catch did not advance the quest')
ok,request=coroutine.resume(co,'caught');assert(ok and request=='CELEBI_MOD:congratulations')
assert(coroutine.resume(co));assert(coroutine.status(co)=='dead')
bucket.quest={version=1,phase='none'}
world.map={id='GOLDENROD_POKECENTER_1F'}
events['map.entered']({mapId=world.map.id})
assert(warp(next_,'GOLDENROD_CITY',1,1,{})==nil and actors.actor)
assert(events['save.loading'],'save reload must retire old scene state')({raw={}})
assert(not actors.actor,'reload leaked a cutscene actor')
game.save.hallOfFame.count=0
assert(warp(next_,'GOLDENROD_CITY',1,1,{})=='GOLDENROD_CITY','stale scene guard blocked the loaded save')
print('CELEBI QUEST PASS: HoF gate, repeated carpet veto, full-bag recovery, actor cleanup and scoped catch')
