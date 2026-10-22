-- A guest actor handed to the native Gen 2 trail loop. No engine methods or
-- map object definitions are patched; the engine owns walking and map resets.
return function(mod,makeNpc,progress,motion)
 local F={};local owned,borrowed,suspended
 local previous=setmetatable({},{__mode='k'})
 local function current(w)
  for _,npc in ipairs(w.npcs or{})do if npc.pikachuFollower then return npc end end
 end
 local function remove(w,npc)
  motion:detach(npc)
  for _,list in ipairs({w.npcs,w.entities})do
   for i=#list,1,-1 do if list[i]==npc then table.remove(list,i)end end
  end
  if w.follower==npc then w.follower=nil end
 end
 local function restore(w,npc)
  local saved=previous[npc]
  if saved then
   motion:detach(npc)
   npc.def.palette=saved.palette
   local handle=mod.world:npc(w.map.id,npc.id)
   if handle then handle:setAppearance(saved.appearance)end
   previous[npc]=nil
  end
 end
 local function eligible(game)
  local lead=game and game.save and game.save.party and game.save.party[1]
  return not suspended and progress:phase()=='caught'and progress:state().kurtCongratulated
   and lead and lead.species=='CELEBI'and not lead.egg and(lead.hp or 0)>0
 end
 function F:following(game,w)
  local npc=current(w)
  return eligible(game)and npc and(npc==owned or npc==borrowed)and true or false
 end
 function F:suspend(value)suspended=value and true or false end
 local function cleanup()
  local w=mod.world:overworld()
  if w then
   if owned then remove(w,owned)end
   if borrowed then restore(w,borrowed)end
  end
  owned,borrowed=nil,nil;suspended=false
 end
 mod.events:on('save.loading',cleanup)
 mod.events:on('save.created',cleanup)
 mod.hooks:wrap('world.follower.spawn',function(next_,game,w)
  local allowed=next_(game,w)
  local npc=current(w)
  if owned and owned~=npc then motion:detach(owned);owned=nil end
  if not eligible(game)then
   if npc==owned and owned then remove(w,owned)end
   if borrowed then restore(w,borrowed)end
   owned,borrowed=nil,nil
   return allowed
  end
  if npc then
   if npc~=owned then
    if borrowed and borrowed~=npc then restore(w,borrowed)end
    borrowed=npc
    if not previous[npc]then previous[npc]={appearance=npc.appearance or npc.def.sprite,palette=npc.def.palette}end
    npc.def.palette=6
    assert(mod.world:npc(w.map.id,npc.id)):setAppearance('SPRITE_CELEBI')
    motion:attach(npc)
   end
   return true
  end
  owned=makeNpc(w.map.id,{index=251,name='CELEBI_FOLLOWER',sprite='SPRITE_CELEBI',
   x=w.player.cellX,y=w.player.cellY,movement=6},assert(w.sprites.SPRITE_CELEBI))
  owned.passable=true;owned.follower=true;owned.pikachuFollower=true
  owned.id='gmarcs_gen2_celebi_time_travel:follower'
  owned.facing=w.player.facing
  w:applySpritePalette(owned)
  motion:attach(owned)
  table.insert(w.npcs,owned);table.insert(w.entities,owned);w.follower=owned
  w.followerTrail={x=w.player.cellX,y=w.player.cellY};w.pikachuTrail=w.followerTrail
  -- The correct guest now exists. Decline the stock constructor for this
  -- call only; subsequent calls return true and its native trail updates it.
  return false
 end,100)
 return F
end
