package.path='gen1recomp/?.lua;'..package.path
local install=assert(loadfile('mods/gen2/celebi_mod/lib/CelebiFollower.lua'))()
local Native=require('src.world.gen2.Follower')
local Runtime=require('src.mods.Runtime')
local hooks,events={},{}
local phase,state='caught',{kurtCongratulated=true}
local game={save={party={{species='CELEBI',hp=10}}}}
local world={map={id='ILEX_FOREST'},player={cellX=8,cellY=23,px=128,py=368,facing='up'},npcs={},entities={}}
local function makeNpc(map,def)
 return {id=map..'_obj_'..def.index,mapId=map,def=def,cellX=def.x,cellY=def.y,
  px=def.x*16,py=def.y*16,facing='up',update=function(self)self.progress=self.progress+1 end}
end
local mod={world={overworld=function()return world end,
 npc=function(_,map,id)for _,npc in ipairs(world.npcs)do if npc.id==id then return {
  setAppearance=function(_,sprite)npc.appearance=sprite;return true end,
 }end end end},hooks={wrap=function(_,id,fn)hooks[id]=fn end},
 events={on=function(_,id,fn)events[id]=fn end}}
world.sprites={SPRITE_CELEBI={}}
function world:applySpritePalette()end
local follower=install(mod,makeNpc,{phase=function()return phase end,state=function()return state end},
 {attach=function()end,detach=function()end})
Runtime.install({emit=function()end},{call=function(_,name,next_,...)
 if hooks[name]then return hooks[name](next_,...)end
 return next_(...)
end})
Native.onMapEntered(game,world,nil,true)
local actor=assert(Native.current(world),'Celebi did not spawn')
assert(actor.def.sprite=='SPRITE_CELEBI'and actor.passable and #world.npcs==1)
assert(#world.entities==1 and follower:following(game,world))
world.player.targetX,world.player.targetY=9,23
Native.update(game,world)
assert(world.followerTrail.x==9 and actor.cellX==8 and not actor.moving,
 'native trail must keep Celebi on the previous player cell')
world.player.cellX=9;world.player.targetX=10
Native.update(game,world)
assert(actor.moving and actor.targetX==9,'native follower did not walk after player')
Native.onMapEntered(game,world,nil,true)
assert(#world.npcs==1 and Native.current(world)~=actor,'map entry duplicated the follower')
game.save.party[1]={species='PIDGEY',hp=10}
Native.update(game,world)
assert(not Native.current(world)and #world.entities==0,'party reorder leaked Celebi')
game.save.party[1]={species='CELEBI',hp=10};phase='encounter'
Native.update(game,world);assert(not Native.current(world),'uncaught event spawned follower')
phase='caught';state.kurtCongratulated=nil
Native.update(game,world);assert(not Native.current(world),'follower interrupted Kurt scene')
state.kurtCongratulated=true
Native.update(game,world);assert(Native.current(world),'mid-map party update did not spawn Celebi')
follower:suspend(true);Native.update(game,world);assert(not Native.current(world))
follower:suspend(false);Native.update(game,world);assert(Native.current(world))
events['save.loading']({});assert(#world.npcs==0,'save load leaked Celebi actor')
-- A peer's follower is borrowed only while Celebi leads; its appearance is
-- restored rather than removing a guest owned by another mod.
local peer=makeNpc('ILEX_FOREST',{index=250,sprite='SPRITE_PIKACHU',palette=1,x=8,y=23})
peer.pikachuFollower=true;peer.appearance='SPRITE_PEER'
world.npcs={peer};world.entities={peer}
local downstream=function()return true end
assert(hooks['world.follower.spawn'](downstream,game,world))
assert(peer.appearance=='SPRITE_CELEBI'and peer.def.palette==6)
game.save.party[1]={species='PIDGEY',hp=10}
assert(hooks['world.follower.spawn'](downstream,game,world))
assert(peer.appearance=='SPRITE_PEER'and peer.def.palette==1 and #world.npcs==1)
Runtime.reset()
print('CELEBI FOLLOWER PASS: native trail, map respawn, party eligibility, suspension, load cleanup and peer restoration')
