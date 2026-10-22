-- Disposable English Silver identity only; no writes to a player's save.
return function(game)
 io.stdout:setvbuf('no')
 local ex=assert(game.mods.exports.CELEBI_MOD)
 local output=assert(os.getenv('POKEPORT_SHOT_DIR'))
 assert(ex.text.body('restless'):find('ILEX FOREST is restless',1,true),'publication run must be English')
 assert(not game.mods.exports.GEN2_ES,'disable Spanish translation for publication')
 game.save.player.name='ETHAN';game.save.rival.name='SILVER'
 local quit=love.event.quit;local finished=false
 love.event.quit=function()finished=true end
 local probe=assert(loadfile('../mods/gen2/celebi_mod/tests/crystal_half.lua'))()
 local co=coroutine.create(function()probe(game,false,true)end)
 local camera=game.world.camera;local follow=camera.follow
 camera.follow=function(self,px,py,vw,vh)
  follow(self,px,py,vw,vh)
  if game.world.map.id=='ROUTE_22'and game.world:busy()then self.y=self.y-32 end
 end
 local seen,departure,lastPosition,adjacent={},false,nil,false
 local keys={'oakCall','oakGift','handOver','shook','restless','received','goForest','inserted','congratulations',
  'timeRoute22','routeRival1','routeStare','routeMan1','timeHideout','hideoutWarning','radioCall',
  'hideoutDefeat','radioAfter','timePresent','radioComplete'}
 local function shot(name)
  if game.capturePath or seen[name]then return end
  seen[name]=true;game.capturePath=output..'/publish-'..name..'.png'
 end
 for tick=1,150000 do
  if coroutine.status(co)~='dead'then local ok,err=coroutine.resume(co);assert(ok,err)end
  if tick==80 then love.window.setMode(960,864)end
  local w=game.world;local top=game.stack:top()
  if w.camera~=camera then
   camera=w.camera;follow=camera.follow
   camera.follow=function(self,px,py,vw,vh)
    follow(self,px,py,vw,vh)
    if game.world.map.id=='ROUTE_22'and game.world:busy()then self.y=self.y-32 end
   end
  end
  for _,npc in ipairs(w.npcs or{})do
   if w.map.id=='AZALEA_TOWN'and(npc.def.name=='CELEBI_KURT_OUTSIDE'or npc.def.sprite=='SPRITE_KURT_OUTSIDE')and npc.cellX>=0 then
    lastPosition={npc.cellX,npc.cellY}
    if w.textbox and w.lastText==ex.text.render('restless')then
     assert(math.abs(npc.cellX-w.player.cellX)+math.abs(npc.cellY-w.player.cellY)==1,'Kurt gives ball from a distance')
     adjacent=true
    end
    if ex.quest.progress:phase()=='restless'and not w.textbox and npc.moving then departure=true;shot('kurt-walking-to-forest')end
   end
  end
  if adjacent and w.map.id=='AZALEA_TOWN'and ex.quest.progress:phase()=='restless'then
   local present=false;for _,n in ipairs(w.npcs)do if n.def.name=='CELEBI_KURT_OUTSIDE'or n.def.sprite=='SPRITE_KURT_OUTSIDE'then present=true end end
   if not present then
    assert(lastPosition and lastPosition[1]==2 and(lastPosition[2]==10 or lastPosition[2]==11),'Kurt disappears away from the forest gate')
    assert(departure,'Kurt did not visibly walk to the forest')
   end
  end
  if w.textbox and top and(top.waiting or top.done)then
   for _,key in ipairs(keys)do if w.lastText==ex.text.render(key)then shot(key);break end end
  end
  local travel=ex.travel:sample()
  if travel and travel.tick>=30 and(travel.white or 0)<.5 then shot('time-travel-'..w.map.id)end
  if top and type(top.battle)=='table'and top.battle.trainer and top.battle.trainer.classId=='CELEBI_GIOVANNI'and top.phase=='menu'then shot('giovanni-battle')end
  if finished and coroutine.status(co)=='dead'then
   shot('radioComplete')
   for _=1,3 do coroutine.yield()end
   assert(adjacent and departure,'Kurt street scene was not exercised')
   print('CELEBI PUBLICATION PASS: English, Kurt adjacency/departure, full native catch and Giovanni victory/return')
   love.event.quit=quit;quit();return
  end
  coroutine.yield()
 end
 error('publication run timed out')
end
