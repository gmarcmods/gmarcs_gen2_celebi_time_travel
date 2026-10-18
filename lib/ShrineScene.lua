-- Shared follower-gated history scene for ordinary shrine reads and isolated
-- previews. The scene scope owns actor, follower and cancellation cleanup.
return function(mod,follower,motion,travel,Text)
 local S={};local actors={};local active,serial
 serial=0
 function S:eligible(game)
  local w=mod.world:overworld()
  return w and w.map.id=='ILEX_FOREST'and w.player.cellX==8 and w.player.cellY==23
   and w.player.facing=='up'and follower:following(game,w)and not active or false
 end
 local function remove(id)
  local entry=actors[id];if not entry then return end
  local h=entry.handle
  if h and h.npc.def.sprite=='SPRITE_CELEBI'then motion:detach(h.npc)end
  mod.world:removeNpc(id);actors[id]=nil
 end
 local function clear()
  local ids={};for id in pairs(actors)do ids[#ids+1]=id end
  for _,id in ipairs(ids)do remove(id)end
 end
 local function cleanup()
  clear()
  follower:suspend(false);active=nil
 end
 local function spawn(map,name,sprite,x,y)
  local id=assert(mod.world:spawnNpc(map,{name=name,sprite=sprite,x=x,y=y,movement=6,
   hours={-1,-1},radius={x=0,y=0}}))
  local h=assert(mod.world:npc(map,id))
  actors[id]={map=map,handle=h}
  if sprite=='SPRITE_CELEBI'then h:setPassable(true);motion:attach(h.npc)end
  return id
 end
 function S:play(ctx,game,continuation)
  assert(self:eligible(game),'Celebi must be following at the shrine')
  serial=serial+1;local token=serial;active=ctx
  local function check()assert(serial==token and active==ctx,'shrine scene cancelled')end
  local scope={spawn=spawn,remove=remove,clear=clear,check=check,
   wait=function(n)ctx.vm:waitFrames(n);check()end}
  local ok,err=pcall(function()
   follower:suspend(true);ctx.vm:waitFrames(2);check()
   local w=assert(mod.world:overworld());local map=w.map.id
   local celebi=spawn(map,'CELEBI_TRAVELER','SPRITE_CELEBI',8,24)
   motion:orbit(assert(mod.world:npc(map,celebi)).npc,w.player.px,w.player.py)
   ctx.vm:waitFrames(72);check()
   -- Departure actors must disappear under the fully white travel frame,
   -- not visibly before the swirl begins. Map loading retires their live NPCs.
   travel:jump(ctx,'ROUTE_22',31,8,'up',function()
    check()
    clear()
    scope.celebi=spawn('ROUTE_22','CELEBI_TRAVELER','SPRITE_CELEBI',30,8)
    if continuation then continuation:arrive(ctx,scope)end
   end);check()
   if Text then Text.show(ctx,'timeRoute22')else ctx.vm:showText('CELEBI_MOD:timeRoute22')end;check()
   if continuation then continuation:play(ctx,scope);check()end
  end)
  if serial==token then cleanup()end
  if not ok then error(err,0)end
 end
 local function cancel()serial=serial+1;cleanup()end
 mod.events:on('save.loading',cancel)
 mod.events:on('save.created',cancel)
 mod.events:on('script.ended',function(ev)if active==ev.ctx then cancel()end end)
 return S
end
