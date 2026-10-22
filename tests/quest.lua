local Progress=assert(loadfile('mods/gen2/celebi_mod/lib/Progress.lua'))()
local install=assert(loadfile('mods/gen2/celebi_mod/lib/Quest.lua'))()
local KurtScenes=assert(loadfile("mods/gen2/celebi_mod/lib/KurtScenes.lua"))()
local Path=assert(loadfile("mods/gen2/celebi_mod/lib/Path.lua"))()
local motion={attach=function()end,detach=function()end}
local bucket,events,hooks,commands,actors={},{},{},{},{}
local game={save={inventory={},hallOfFame={count=0}}}
local world={map={id='GOLDENROD_POKECENTER_1F'},player={cellX=3,cellY=3,scriptFace=function()end}}
function world:healParty()end
function world:busy()return false end
function world:playCry(species)assert(species==251)end
function world:npcAt(x,y)for _,actor in pairs(actors)do if actor.cellX==x and actor.cellY==y then return actor end end end
local ctx={vm={showText=function(_,id)coroutine.yield(id)end,
 waitFrames=function(_,ticks)coroutine.yield({kind='wait',ticks=ticks})end}}
local co
world.vm={start=function(_,rows)
 co=coroutine.create(function()return commands[rows[1].verb](ctx)end)
 local ok,why=coroutine.resume(co);assert(ok,why);return true
end}
local canGive=false
local api={
 overworld=function()return world end,
 spawnNpc=function(_,map,def)actors.actor={id='actor',def=def,cellX=def.x,cellY=def.y};return 'actor'end,
 npc=function(_,map,id)return actors[id]and{
  npc=actors[id],
  face=function()return true end,
  setPassable=function()return true end,
  position=function()return actors[id].cellX,actors[id].cellY end,
  placeAt=function(_,x,y)actors[id].cellX,actors[id].cellY=x,y;return true end,
  scriptMove=function(_,dir,tiles,done)
   local d=({up={0,-1},down={0,1},left={-1,0},right={1,0}})[dir]
   actors[id].cellX=actors[id].cellX+d[1]*tiles;actors[id].cellY=actors[id].cellY+d[2]*tiles
   done();return true end,
 }end,
 removeNpc=function(_,id)actors[id]=nil;return true end,
}
local mod={world=api,
 save={get=function(_,k,default)return bucket[k]or default end,set=function(_,k,v)bucket[k]=v end},
 events={on=function(_,id,fn)events[id]=fn end},
 hooks={wrap=function(_,id,fn)hooks[id]=fn end},
 commands={register=function(_,id,fn)commands[id]=fn end},
}
local quest=install(mod,Progress,{add=function()if canGive then game.save.inventory.GS_BALL=1;return true end;return false end},KurtScenes,Path,motion)
events['game.ready']({game=game})
assert(not hooks['warp.destination']and not commands['gmarcs_gen2_celebi_time_travel:delivery'],'obsolete Goldenrod giver remains')
assert(not quest:deliver()and quest.progress:phase()=='none','full pocket committed delivery')
canGive=true;assert(quest:deliver()and quest.progress:phase()=='delivered'and game.save.inventory.GS_BALL==1)
assert(not quest:deliver(),'duplicate GS Ball delivery')
bucket.quest={version=1,phase='encounter'}
events['battle.started']({kind='wild',species='CELEBI',battle={}})
events['pokemon.caught']({game=game,species='CELEBI',battle={}})
assert(quest.progress:phase()=='encounter','unrelated catch advanced the quest')
world.player.cellX,world.player.cellY=8,23
world.map={id='ILEX_FOREST',isWalkable=function(_,x,y)return x>=0 and x<12 and y>=20 and y<26 end,def={bgEvents={{x=8,y=22,scriptKey='SHRINE'}}}}
game.save.party={{hp=10}}
ctx.scriptKey='SHRINE'
ctx.vm.writeVarFn=function(id,value)assert(id==3 and value==11)end
co=coroutine.create(function()return hooks['script.command'](function()error('native shrine was not intercepted')end,ctx,'jumptext',{}, {})end)
local ok,request=coroutine.resume(co);assert(ok and request=='gmarcs_gen2_celebi_time_travel:retry')
ok,request=coroutine.resume(co);assert(ok and request.kind=='yesorno')
ok,request=coroutine.resume(co,true);assert(ok and request.kind=='wait'and request.ticks==160 and actors.actor)
ok,request=coroutine.resume(co);assert(ok and request.kind=='waitsfx','battle must wait for native cry completion')
ok,request=coroutine.resume(co);assert(ok and request.kind=='battle'and request.wild.species==251 and request.wild.level==30 and not actors.actor)
local battle={}
events['battle.started']({kind='wild',species='CELEBI',battle=battle})
events['pokemon.caught']({game=game,species='CELEBI',battle={}})
events['pokemon.caught']({game={},species='CELEBI',battle=battle})
events['pokemon.caught']({game=game,species='PIDGEY',battle=battle})
assert(quest.progress:phase()=='encounter','wrong battle/game/species advanced the quest')
events['pokemon.caught']({game=game,species='CELEBI',battle=battle})
assert(quest.progress:phase()=='caught','matching settled catch did not advance the quest')
ok,request=coroutine.resume(co,'caught');assert(ok and request=='gmarcs_gen2_celebi_time_travel:congratulations')
assert(coroutine.resume(co));assert(coroutine.status(co)=='dead')
assert(quest.progress:state().kurtCongratulated,'completed Kurt scene did not checkpoint')
bucket.quest.kurtCongratulated=nil
co=coroutine.create(function()return hooks['script.command'](function()error('native shrine was not intercepted')end,ctx,'jumptext',{}, {})end)
ok,request=coroutine.resume(co);assert(ok and request=='gmarcs_gen2_celebi_time_travel:congratulations',
 'post-catch interruption must resume Kurt without another battle')
assert(coroutine.resume(co));assert(quest.progress:state().kurtCongratulated and not actors.actor)
bucket.quest={version=1,phase='street'}
local nativeDef={sprite='SPRITE_KURT',x=3,y=2,eventFlag=1855}
actors.native={id='native',def=nativeDef,cellX=3,cellY=2}
world.npcs={actors.native};world.map={id='KURTS_HOUSE'}
events['map.entered']({mapId='KURTS_HOUSE'})
assert(actors.native.cellX==-32 and nativeDef.x==3 and nativeDef.y==2 and nativeDef.eventFlag==1855,
 'Kurt hiding must not mutate vanilla definitions/flags')
actors.native.cellX,actors.native.cellY=3,2
bucket.quest={version=1,phase='caught'}
events['map.entered']({mapId='KURTS_HOUSE'})
assert(actors.native.cellX==3,'Kurt remained hidden after the catch')
actors.native=nil
bucket.quest={version=1,phase='encounter'}
world.map={id='ILEX_FOREST',def={bgEvents={{x=8,y=22,scriptKey='SHRINE'}}}}
ctx.scriptKey='SHRINE'
co=coroutine.create(function()return hooks['script.command'](function()error('native shrine escaped')end,ctx,'jumptext',{}, {})end)
assert(coroutine.resume(co));assert(coroutine.resume(co))
ok,request=coroutine.resume(co,true)
assert(ok and request.kind=='wait'and actors.actor,'appearance scene did not begin')
events['save.loading']({})
assert(not actors.actor and quest.progress:phase()=='encounter','interrupted arrival leaked an actor or lost retry state')
print('CELEBI QUEST PASS: gift idempotence, full pocket, actor cleanup and scoped catch')
-- Ordinary shrine reads must start history, once, only when the actual
-- follower is eligible. The completed radio state must not replay it.
local historyCalls=0
quest:setHistory(function()historyCalls=historyCalls+1;return true end)
bucket.quest={version=1,phase='caught',kurtCongratulated=true}
world.map={id='ILEX_FOREST',def={bgEvents={{x=8,y=22,scriptKey='SHRINE'}}}}
ctx.scriptKey='SHRINE'
local function shrineRead()
 co=coroutine.create(function()return hooks['script.command'](function()error('native Crystal shrine escaped replacement')end,ctx,'checkevent',{}, {event=192})end)
 local ok,value=coroutine.resume(co);assert(ok,value);return value
end
shrineRead();assert(historyCalls==1 and coroutine.status(co)=='dead','normal shrine did not activate history')
bucket.eventComplete=true
assert(shrineRead()=='gmarcs_gen2_celebi_time_travel:idle'and historyCalls==1,'completed history replayed')
assert(coroutine.resume(co))
bucket.quest={version=1,phase='none'};bucket.eventComplete=nil
assert(shrineRead()=='gmarcs_gen2_celebi_time_travel:idle','unarmed shrine must replace native Crystal event with ordinary text')
assert(coroutine.resume(co))
print('CELEBI NATURAL HISTORY PASS: normal shrine, completed guard and vanilla replacement')
