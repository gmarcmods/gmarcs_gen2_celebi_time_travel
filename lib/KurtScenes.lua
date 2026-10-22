return function(mod,Path,progress,move,spawn,remove)
 local Scenes={}
 local function blocked(w,actor,x,y)
  if w.player.cellX==x and w.player.cellY==y then return true end
  local other=w:npcAt(x,y)
  return other and other~=actor and not other.passable
 end
 local function path(w,actor,goals,allowGoal)
  return Path.find(w.map,actor.cellX,actor.cellY,goals,function(x,y)return blocked(w,actor,x,y)end,allowGoal)
 end
 local function walk(ctx,map,id,route)
  for _,dir in ipairs(route)do move(ctx,map,id,dir,1)end
 end
 local function hide(w)
  for _,npc in ipairs(w.npcs)do
   if npc.def.sprite=='SPRITE_KURT'then
    -- Only move the live actor. Never change its definition, native event flag
    -- or saved object mask; disabling the mod restores vanilla on map load.
    assert(mod.world:npc(w.map.id,npc.id)):placeAt(-32,-32,'down')
   end
  end
 end
 function Scenes.reconcile()
  local w=mod.world:overworld();local phase=progress:phase()
  if w and w.map.id=='KURTS_HOUSE'and(phase=='street'or phase=='restless'or phase=='encounter')then hide(w)end
 end
 function Scenes.leave(ctx)
  local w=assert(mod.world:overworld());local actor
  for _,npc in ipairs(w.npcs)do
   if npc.def.sprite=='SPRITE_KURT'and npc.def.scriptKey==ctx.scriptKey then actor=npc;break end
  end
  assert(actor,'Kurt scene actor missing')
  local route=assert(path(w,actor,{{3,7},{4,7}}),'Kurt cannot reach either workshop exit')
  -- The semantic checkpoint is committed before movement. Reloading during
  -- the walk reconstructs Kurt outside rather than repeating item transfers.
  assert(progress:leaveWorkshop(w:weekday(),os.date('%Y-%m-%d')))
  walk(ctx,w.map.id,actor.id,route);hide(w)
 end
 -- Street gifts happen face-to-face, then Kurt walks toward the forest gate.
 function Scenes.streetApproach(ctx,id)
  local w=assert(mod.world:overworld());local actor=assert(mod.world:npc(w.map.id,id)).npc
  local px,py=w.player.cellX,w.player.cellY
  local route=assert(path(w,actor,{{px,py+1},{px-1,py},{px+1,py},{px,py-1}}),'Kurt cannot approach outside his workshop')
  walk(ctx,w.map.id,id,route)
  local handle=assert(mod.world:npc(w.map.id,id));local x,y=handle:position()
  local dir=px>x and'right'or px<x and'left'or py>y and'down'or'up'
  handle:face(dir)
  w.player:scriptFace(({up='down',down='up',left='right',right='left'})[dir])
 end
 function Scenes.streetLeave(ctx,id)
  local w=assert(mod.world:overworld());local actor=assert(mod.world:npc(w.map.id,id)).npc
  local route=assert(path(w,actor,{{2,10},{2,11}},function(x,y)
   local door=w.map:warpAt(x,y)
   return door and(door.def or door).destMap=='ILEX_FOREST_AZALEA_GATE'
  end),'Kurt cannot reach the forest gate')
  walk(ctx,w.map.id,id,route)
  assert(mod.world:npc(w.map.id,id)):face('left')
  ctx.vm:waitFrames(12)
 end
 function Scenes.congratulate(ctx,speak)
  local w=assert(mod.world:overworld());local px,py=w.player.cellX,w.player.cellY
  -- (8,29), the original watcher position, has no collision-valid route.
  -- Enter via the west end of the shrine clearing in this adaptation.
  local id=spawn(w.map.id,'CELEBI_KURT_WATCHER','SPRITE_KURT',1,24)
  local actor=assert(mod.world:npc(w.map.id,id)).npc
  local route=assert(path(w,actor,{{px,py+1},{px-1,py},{px+1,py},{px,py-1}}),
   'Kurt cannot approach the shrine')
  walk(ctx,w.map.id,id,route)
  local handle=assert(mod.world:npc(w.map.id,id));local x,y=handle:position()
  local dir=px>x and'right'or px<x and'left'or py>y and'down'or'up'
  handle:face(dir)
  local opposite={up='down',down='up',left='right',right='left'}
  w.player:scriptFace(opposite[dir]);speak(ctx,'congratulations')
  local back={};for i=#route,1,-1 do back[#back+1]=opposite[route[i]]end
  walk(ctx,w.map.id,id,back);remove(id)
 end
 return Scenes
end
