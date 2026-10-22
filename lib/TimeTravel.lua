-- A bounded local screen effect; independent of native/voxel camera geometry.
-- The native VM owns the lock. Only a fully white frame may change maps.
return function(mod,G)
 local T={duration=144};local active,epoch,ready=nil,0,false
 local recoveryAttempted=false
 local destinations={ILEX_FOREST=true,ROUTE_22=true,CELEBI_TOHJO_HIDEOUT=true}
 local function cancel()epoch=epoch+1;active=nil end
 local function target(mapId,x,y,facing)
  assert(destinations[mapId],'unsupported Celebi travel destination')
  assert(type(x)=='number'and x%1==0 and x>=0 and type(y)=='number'and y%1==0 and y>=0,
   'invalid travel coordinates')
  assert(facing=='up'or facing=='down'or facing=='left'or facing=='right','invalid travel facing')
  return {mapId=mapId,x=x,y=y,facing=facing}
 end
 function T:sample()
  if not active then return end
  local t=active.age
  local white=t<60 and 0 or t<84 and(t-60)/24 or t<=96 and 1 or math.max(0,1-(t-96)/48)
  return {tick=t,white=white,swirl=math.min(1,t/24)*(1-white)}
 end
 local function travel(ctx,mapId,x,y,facing,onLand)
  local dest=target(mapId,x,y,facing)
  assert(not active,'time travel already active')
  local w=assert(mod.world:overworld(),'travel requires a live world')
  local token=epoch
  active={age=0,ctx=ctx}
  -- Semantic destination only: no coroutine, actor or effect is serialized.
  mod.save:set('travelPending',dest)
  local function wait(n)
   for _=1,n do
    ctx.vm:waitFrames(1)
    assert(epoch==token and active,'time travel cancelled')
   end
  end
  local ok,err=pcall(function()
   wait(84)
   local warped,why=mod.world:warpTo(dest.mapId,dest.x,dest.y,dest.facing)
   assert(warped,why or'time travel warp failed')
   if onLand then onLand()end
   -- Keep white over destination callbacks before revealing the new map.
   wait(12);wait(48)
   mod.save:set('travelPending',nil)
  end)
  if epoch==token then active=nil end
  if not ok then error(err,0)end
 end
 mod.commands:register('gmarcs_gen2_celebi_time_travel:travel',travel)
 T.jump=function(_,...)return travel(...)end
 mod.events:on('save.loading',function()ready=false;recoveryAttempted=false;cancel()end)
 mod.events:on('save.created',function()ready=true;recoveryAttempted=false;cancel()end)
 mod.events:on('save.loaded',function()ready=true end)
 mod.events:on('game.ready',function()ready=true end)
 mod.events:on('script.ended',function(ev)if active and active.ctx==ev.ctx then cancel()end end)
 mod.hooks:wrap('input.step',function(next_,game,dt)
  if active then active.age=math.min(T.duration,active.age+1)
  elseif ready then
   local pending=mod.save:get('travelPending')
   local w=mod.world:overworld()
   if pending and not recoveryAttempted and w and not w:busy()then
    -- A load interrupted between departure and reveal. Rebuild the transition
    -- through the native VM, which reacquires the input lock immediately.
    local dest=target(pending.mapId,pending.x,pending.y,pending.facing)
    recoveryAttempted=true
    w.vm:start({{op='modcommand',verb='gmarcs_gen2_celebi_time_travel:travel',
     args={dest.mapId,dest.x,dest.y,dest.facing}},{op='end'}})
   end
  end
  return next_(game,dt)
 end)
 mod.hooks:wrap('render.hud',function(next_,game,v)
  next_(game,v)
  local s=T:sample();if not s then return end
  G.push('all');G.origin();G.setShader();G.setScissor();G.setBlendMode('alpha')
  local scale=math.max(1,math.floor(math.min(v.width/160,v.height/144)))
  local cx,cy=v.width/2,v.height/2
  -- Twelve pixel-stepped spirals, eight segments each. No textures, shaders,
  -- offscreen canvases or particle allocation; zero draw work when inactive.
  G.setLineWidth(scale*2)
  for arm=1,12 do
   G.setColor(.68,.94,.78,s.swirl*.7)
   for segment=1,8 do
    local function point(k)
     local radius=k*8*scale
     local a=arm*math.pi/6+k*.22-s.tick*.055
     return cx+math.floor(math.cos(a)*radius/scale)*scale,
      cy+math.floor(math.sin(a)*radius/scale)*scale
    end
    local x1,y1=point(segment-1);local x2,y2=point(segment)
    G.line(x1,y1,x2,y2)
   end
  end
  G.setColor(1,1,1,s.white);G.rectangle('fill',0,0,v.width,v.height)
  G.pop()
 end,1000)
 T.cancel=cancel
 return T
end
