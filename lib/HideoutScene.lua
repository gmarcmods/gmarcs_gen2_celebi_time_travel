-- Solo adaptation: radio identifies Giovanni; no partner exposition.
return function(mod,Text,FieldArt,motion,travel,Path)
 local H={};local map='CELEBI_TOHJO_HIDEOUT'
 function H:arrive(ctx,scene)
  scene.giovanni=scene.spawn(map,'CELEBI_GIOVANNI','SPRITE_CELEBI_GIOVANNI',6,4)
  assert(mod.world:npc(map,scene.giovanni)):face('down')
 end
 function H:play(ctx,scene)
  local function say(id)scene.check();Text.show(ctx,id);scene.check()end
  say('hideoutWarning');say('hideoutMemory');say('radioCall');say('hideoutChallenge')
  local class=FieldArt.trainer(mod);local member=class.trainers[1]
  local outcome=coroutine.yield({kind='battle',trainer={
   class='CELEBI_GIOVANNI',classId='CELEBI_GIOVANNI',className=Text.label(class.name),
   id=1,member=1,name=member.name,trainerType=member.trainerType,roster=member.party,baseMoney=class.baseMoney,items={},
  }})
  scene.check()
  -- Native loss handling owns healing, money and whiteout. Never run the
  -- victory sequence over that destination or mark a lost event complete.
  if outcome~='win'then return end
  say('hideoutDefeat')
  local w=assert(mod.world:overworld())
  local a=assert(mod.world:npc(map,scene.giovanni)).npc
  local route=assert(Path.find(w.map,a.cellX,a.cellY,{{7,9}},function(x,y)
   if x==w.player.cellX and y==w.player.cellY then return true end
   local other=w:npcAt(x,y);return other and other~=a and not other.passable
  end),'Giovanni has no safe exit path')
  for _,dir in ipairs(route)do
   local done=false
   assert(mod.world:npc(map,scene.giovanni)):scriptMove(dir,1,function()done=true end)
   for _=1,600 do if done then break end;scene.wait(1)end
   assert(done,'Giovanni departure timed out')
  end
  scene.remove(scene.giovanni)
  say('radioAfter')
  motion:orbit(assert(mod.world:npc(map,scene.celebi)).npc,w.player.px,w.player.py)
  scene.wait(72)
  travel:jump(ctx,'ILEX_FOREST',8,23,'up',function()
   scene.check();scene.clear()
   scene.celebi=scene.spawn('ILEX_FOREST','CELEBI_TRAVELER','SPRITE_CELEBI',8,24)
   mod.save:set('eventComplete',true)
  end)
  say('timePresent')
 end
 return H
end
