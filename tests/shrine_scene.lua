local install=assert(loadfile('mods/gen2/celebi_mod/lib/ShrineScene.lua'))()
local Path=assert(loadfile('mods/gen2/celebi_mod/lib/Path.lua'))()
local actors,events,removed={},{},0
local player={cellX=8,cellY=23,facing='up',px=128,py=368,scriptFace=function()end}
local w={map={id='ILEX_FOREST',isWalkable=function(_,x,y)return y==24 and x>=1 and x<=8 or y==23 and x>=7 and x<=9 end},player=player}
function w:npcAt()end
local following=true
local follower={following=function()return following end,suspend=function(_,value)following=not value end}
local game={save={player={gender='female'}}}
local api={overworld=function()return w end,spawnNpc=function(_,map,def)
 assert(def.sprite=='SPRITE_CELEBI','time travel must not spawn Lyra, Ethan or a substitute companion')
 actors[def.name]={def=def,cellX=def.x,cellY=def.y,px=def.x*16,py=def.y*16}
 return def.name end,
 npc=function(_,map,id)local a=actors[id];if a then return {npc=a,face=function()end,
 setPassable=function()end,scriptMove=function(_,dir,n,done)
 local d=({up={0,-1},down={0,1},left={-1,0},right={1,0}})[dir]
 a.cellX=a.cellX+d[1]*n;a.cellY=a.cellY+d[2]*n;done();return true end}end end,
 removeNpc=function(_,id)actors[id]=nil;removed=removed+1 end}
local texts,orbited,attached={},false,0
local scene=install({world=api,events={on=function(_,id,fn)events[id]=fn end}},follower,
 {attach=function()attached=attached+1 end,detach=function()attached=attached-1 end,
 orbit=function()orbited=true end},
 {jump=function(_,ctx,map,x,y,dir,onLand)
 assert(not following and orbited,'travel started without follower suspension and Celebi orbit')
 assert(map=='ROUTE_22');w.map.id=map;player.cellX=x;player.cellY=y;onLand()
 end})
local ctx={vm={showText=function(_,id)texts[#texts+1]=id end,waitFrames=function()end}}
assert(scene:eligible(game))
scene:play(ctx,game)
assert(w.map.id=='ROUTE_22'and player.cellX==31 and player.cellY==8)
assert(removed==2 and attached==0 and following,'scene leaked actors, motion or follower suspension')
assert(#texts==1 and texts[1]=='CELEBI_MOD:timeRoute22','use a time/location caption instead of partner exposition')
w.map.id='ILEX_FOREST';player.cellX,player.cellY=8,23
local arrived,continued=false,false
scene:play(ctx,game,{
 arrive=function(_,c,scope)assert(w.map.id=='ROUTE_22'and scope.celebi);arrived=true end,
 play=function(_,c,scope)assert(arrived and texts[#texts]=='CELEBI_MOD:timeRoute22');scope.check();continued=true end,
})
assert(arrived and continued,'historical continuation was ignored')
assert(not scene:eligible(game),'scene accepted a non-shrine position')
w.map.id='ILEX_FOREST';player.cellX,player.cellY=8,23
following=false;assert(not scene:eligible(game),'inventory presence alone must not activate time travel')
following=true
local ok=pcall(function()scene:play(ctx,game,{
 arrive=function(_,c,scope)scope.spawn('ROUTE_22','CELEBI_EXTRA','SPRITE_CELEBI',7,24)end,
 play=function()error('interrupted historical continuation')end,
})end)
assert(not ok and next(actors)==nil and attached==0 and following,'continuation failure leaked scene resources')
w.map.id='ILEX_FOREST';player.cellX,player.cellY=8,23
ctx.vm.waitFrames=function()error('interrupted animation')end
assert(not pcall(function()scene:play(ctx,game)end))
assert(next(actors)==nil and attached==0 and following,'failed scene leaked actor or follower lock')
print('CELEBI SHRINE SCENE PASS: follower trigger, no companion, time caption, orbit, arrival and cleanup')
