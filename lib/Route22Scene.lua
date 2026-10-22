-- GSC adaptation of the historical argument. No partner/exposition actor.
-- The enclosing scene owns all actors and its VM/cancellation guard.
return function(mod,Path,motion,travel,Text,hideout)
 local R={}
 local mapId='ROUTE_22'
 local function world()return assert(mod.world:overworld())end
 local function actor(id)return assert(mod.world:npc(mapId,id))end
 local function waitUntil(ctx,scene,done,why)
  for _=1,600 do
   scene.check();if done()then return end
   ctx.vm:waitFrames(1)
  end
  error(why..' timed out')
 end
 local function walkTo(ctx,scene,id,x,y)
  local w=world();assert(w.map.id==mapId,'historical actor map changed')
  local a=actor(id).npc
  local route=assert(Path.find(w.map,a.cellX,a.cellY,{{x,y}},function(cx,cy)
   if cx==w.player.cellX and cy==w.player.cellY then return true end
   local other=w:npcAt(cx,cy)
   return other and other~=a and not other.passable
  end),'historical actor has no collision-valid path')
  for _,dir in ipairs(route)do
   local done=false
   assert(actor(id):scriptMove(dir,1,function()done=true end))
   waitUntil(ctx,scene,function()return done end,'historical actor movement')
  end
 end
 function R:arrive(ctx,scene)
  assert(world().map.id==mapId,'Route 22 arrival on wrong map')
  scene.rival=scene.spawn(mapId,'CELEBI_SILVER','SPRITE_RIVAL',31,4)
  scene.man=scene.spawn(mapId,'CELEBI_MAN','SPRITE_CELEBI_GIOVANNI',29,4)
  actor(scene.rival):face('left');actor(scene.man):face('right')
 end
 function R:play(ctx,scene)
  local w=world();assert(w.map.id==mapId and scene.rival and scene.man,'Route 22 is not staged')
  local function say(id)scene.check();if Text then Text.show(ctx,id)else ctx.vm:showText('gmarcs_gen2_celebi_time_travel:'..id)end;scene.check()end
  for _,id in ipairs({'routeRival1','routeMan1','routeRival2','routeMan2','routeRival3','routeMan3'})do say(id)end
  -- Follow the upper path west, beyond the visible scene. The GSC gate
  -- faces south, unlike HGSS; never path through its roof to mimic that map.
  walkTo(ctx,scene,scene.man,18,4);scene.remove(scene.man)
  actor(scene.rival):face('left');say('routeRival4')
  actor(scene.rival).npc.stepFrames=8
  walkTo(ctx,scene,scene.rival,31,7)
  actor(scene.rival):face('down');w.player:scriptFace('up');say('routeStare')
  -- Native scripted player movement ignores collision, so validate it first.
  assert(w.player.cellX==31 and w.player.cellY==8,'player left historical blocking')
  assert(w.map:isWalkable(32,8)and not w:npcAt(32,8),'player stagger is blocked')
  assert(w.player:scriptStep('right'),'player stagger refused')
  waitUntil(ctx,scene,function()return not w.player.moving end,'player stagger')
  w.player:scriptFace('left')
  walkTo(ctx,scene,scene.rival,39,16);scene.remove(scene.rival)
  -- Approach the orbit's starting point before animating; no visible snap.
  walkTo(ctx,scene,scene.celebi,33,8)
  motion:orbit(actor(scene.celebi).npc,w.player.px,w.player.py,0)
  scene.wait(72)
  travel:jump(ctx,'CELEBI_TOHJO_HIDEOUT',6,6,'up',function()
   scene.check();scene.clear()
   scene.celebi=scene.spawn('CELEBI_TOHJO_HIDEOUT','CELEBI_TRAVELER','SPRITE_CELEBI',7,6)
   if hideout then hideout:arrive(ctx,scene)end
  end)
  scene.check();say('timeHideout')
  if hideout then hideout:play(ctx,scene)end
 end
 return R
end
