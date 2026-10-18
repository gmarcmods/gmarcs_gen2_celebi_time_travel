-- Suppress only Crystal's original GS Ball entry points while this mod is
-- enabled. Never rewrite saved event flags or remove Kurt's Apricorn work.
return function(mod,edition)
 local supported={crystal=true}
 if not supported[edition]then return false end
 local filters={
  GOLDENROD_POKECENTER_1F=function(e)return e.y==7 and(e.x==3 or e.x==4)and e.sceneId==0 end,
  AZALEA_TOWN=function(e)return e.x==9 and e.y==6 and e.sceneId==2 end,
 }
 for id,drop in pairs(filters)do
  local map=assert(mod.content.maps:get(id));local keep={}
  for _,event in ipairs(map.coordEvents or{})do if not drop(event)then keep[#keep+1]=event end end
  -- An empty table is a merge no-op, not an empty list. DELETE is
  -- required when both native delivery triggers were the entire list.
  mod.content.maps:patch(id,{coordEvents=next(keep)and keep or mod.DELETE})
 end
 -- Verified Crystal wEventFlags: CAN_GIVE_GS_BALL_TO_KURT (190),
 -- GAVE_GS_BALL_TO_KURT (191), FOREST_IS_RESTLESS (192).
 -- Force only these *reads* in native Kurt scripts false. The mod keeps
 -- its own progression; normal Apricorn checks and saved flags are intact.
 mod.hooks:wrap('script.command',function(next_,ctx,name,args,cmd)
  if ctx.mapId=='KURTS_HOUSE'and name=='checkevent'and cmd
    and(cmd.event==190 or cmd.event==191 or cmd.event==192)then
   ctx.vm.scriptVar=0;return
  end
  return next_(ctx,name,args,cmd)
 end,80)
 local function hideNativeActors()
  local w=mod.world:overworld();if not w then return end
  for _,npc in ipairs(w.npcs or{})do
   local d=npc.def
   if(w.map.id=='AZALEA_TOWN'and d.sprite=='SPRITE_KURT_OUTSIDE')
     or(w.map.id=='ILEX_FOREST'and d.sprite=='SPRITE_KURT'and d.x==8 and d.y==29)then
    if npc.cellX>=0 then assert(mod.world:npc(w.map.id,npc.id)):placeAt(-32,-32,'down')end
   end
  end
 end
 mod.events:on('map.entered',hideNativeActors)
 mod.events:on('world.live_maps_updated',hideNativeActors)
 return true
end
