-- Native-VM actions: the VM owns input locking and pauses until each finishes.
return function(mod)
 mod.commands:register('CELEBI_MOD:wait',function(ctx,ticks)
  assert(type(ticks)=='number'and ticks>=0 and ticks<=600 and ticks%1==0,'invalid wait ticks')
  ctx.vm:waitFrames(ticks)
 end)
 mod.commands:register('CELEBI_MOD:face',function(ctx,mapId,actorId,dir)
  assert(dir=='up'or dir=='down'or dir=='left'or dir=='right','invalid facing')
  local actor=assert(mod.world:npc(mapId,actorId))
  assert(actor:face(dir))
 end)
 mod.commands:register('CELEBI_MOD:move',function(ctx,mapId,actorId,dir,tiles)
  assert(type(tiles)=='number'and tiles>=1 and tiles<=16 and tiles%1==0,'invalid move distance')
  local actor=assert(mod.world:npc(mapId,actorId))
  local done=false
  assert(actor:scriptMove(dir,tiles,function()done=true end))
  for _=1,600 do
   if done then return end
   ctx.vm:waitFrames(1)
  end
  error('actor movement timed out')
 end)
end
