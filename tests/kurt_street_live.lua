return function(game)
 io.stdout:setvbuf('no')
 local function frames(n)for _=1,n do coroutine.yield()end end
 frames(60);game.stack:clear();game.input:reset();game.input.pollPads=function()end
 game.keypressed=function()end;game.keyreleased=function()end
 local ex=assert(game.mods.exports.gmarcs_gen2_celebi_time_travel);local w=game.world
 local P=require('src.render.Pipelines');P.setLevel('voxel',0);P.syncOptions(game.save.options)
 love.window.setMode(960,864);game.save.options.textSpeed=1
 game.save.player.name='ETHAN';game.save.rival.name='SILVER'
 ex.quest.progress:advance('street')
 assert(w:setMap('AZALEA_TOWN',9,6,'down'));frames(30)
 local out=assert(os.getenv('POKEPORT_SHOT_DIR'))
 print('KURT MAP',w.map.id,w.mapImage:getDimensions(),w.camera.x,w.camera.y,w.map:tileAt(18,12),w.map.tileset.id)
 local data=w.mapImage:newImageData();local file=assert(io.open(out..'/azalea-map-debug.png','wb'));file:write(data:encode('png'):getString());file:close();data:release()
 assert(w.vm:start({{op='modcommand',verb='gmarcs_gen2_celebi_time_travel:street',args={}},{op='end'}}))
 local seen,walked,last={}
 for _=1,4000 do
  local actor
  for _,n in ipairs(w.npcs)do if n.def.name=='CELEBI_KURT_OUTSIDE'then actor=n end end
  if actor then last={actor.cellX,actor.cellY}end
  local top=game.stack:top();local name
  if w.textbox and top and(top.waiting or top.done)then
   for _,key in ipairs({'restless','received','goForest'})do if w.lastText==ex.text.render(key)then name=key;break end end
   if name=='restless'then assert(actor and math.abs(actor.cellX-9)+math.abs(actor.cellY-6)==1)end
  elseif actor and actor.moving and ex.quest.progress:phase()=='restless'then name='walking-to-forest';walked=true end
  if name and not seen[name]then
   seen[name]=true;game.capturePath=out..'/kurt-'..name..'.png'
   for _=1,5 do frames(1);if not game.capturePath then break end end
  end
  if w.textbox then game.input:sourcePress('a','kurt-street-live');game.input:sourceRelease('a','kurt-street-live')end
  if not w:busy()then
   assert(ex.quest.progress:phase()=='restless'and game.save.inventory.GS_BALL==1)
   assert(not actor and walked and last[1]==2 and(last[2]==10 or last[2]==11))
   print('KURT STREET LIVE PASS',game.save.version);love.event.quit();return
  end
  frames(3)
 end
 error('Kurt street live timeout')
end
