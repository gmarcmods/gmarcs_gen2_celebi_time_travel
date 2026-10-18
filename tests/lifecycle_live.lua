-- Ordinary exploration -> actual Kurt/catch quest -> actual shrine/history.
-- Disposable identities only. This driver never saves.
return function(game)
 io.stdout:setvbuf('no')
 local function frames(n)for _=1,n do coroutine.yield()end end
 local w=game.world
 local function until_(fn,why,n)
  for _=1,n or 1800 do if fn()then return end;frames(1)end
  error('lifecycle timeout: '..why..' map='..tostring(w.map.id)..' text='..tostring(w.lastText))
 end
 frames(60);game.stack:clear();game.keypressed=function()end;game.keyreleased=function()end;game.input.pollPads=function()end;game.input:reset()
 local ex=assert(game.mods.exports.CELEBI_MOD);local room=ex.room
 assert(ex.crystalReplacement==({gold=false,silver=false,crystal=true})[game.save.version],'edition-specific Crystal replacement was not selected')
 local function idle()return not w:busy()and not game.stack:top()end
 local function tap(key)
  game.input:sourcePress(key,'celebi-lifecycle');game.input:sourceRelease(key,'celebi-lifecycle');frames(3)
 end
 local function drain()
  for _=1,1000 do if idle()then return end;if w.textbox then tap('a')else frames(2)end end
  error('lifecycle text did not finish')
 end
 if ex.crystalReplacement then
  -- An imported save may already have the native Crystal quest armed.
  for _,flag in ipairs({190,191,192})do w.events:set(flag,true)end
  local center=w.maps.GOLDENROD_POKECENTER_1F
  for _,e in ipairs(center.coordEvents or{})do assert(e.y~=7 or(e.x~=3 and e.x~=4),'native Crystal delivery still present')end
  for _,e in ipairs(w.maps.AZALEA_TOWN.coordEvents)do assert(e.x~=9 or e.y~=6,'native Crystal street scene still present')end
 end
 local P=require('src.render.Pipelines');P.setLevel('voxel',0);P.syncOptions(game.save.options)
 assert(w:setMap('TOHJO_FALLS',room.entrance.x,room.entrance.y+1,'up'));frames(20)
 game.capturePath=assert(os.getenv('POKEPORT_SHOT_DIR'))..'/exploration-entrance-2d.png'
 until_(function()return not game.capturePath end,'entrance capture')
 game.input:sourcePress('up','celebi-explore')
 until_(function()return w.map.id==room.id end,'ordinary entrance warp')
 game.input:sourceRelease('up','celebi-explore');until_(idle,'enter room')
 assert(not(game.save.modData.CELEBI_MOD or{}).eventComplete,'exploration completed story')
 for _,npc in ipairs(w.npcs)do assert(npc.def.name==room.radioName,'ordinary visit spawned an event actor')end
 assert(ex.world:warpTo(room.id,6,4,'up'));until_(idle,'radio approach');tap('a')
 until_(function()return w.textbox end,'radio before event')
 assert(w.lastText==ex.text.body('radioBefore'),'wrong/untranslated radio before event');drain()
 assert(ex.world:warpTo(room.id,7,8,'down'));until_(idle,'exit approach')
 game.input:sourcePress('down','celebi-explore')
 until_(function()return w.map.id=='TOHJO_FALLS'end,'ordinary exit warp')
 game.input:sourceRelease('down','celebi-explore');until_(idle,'exit room')
 assert(w.player.cellX==room.entrance.x,'exit did not return to original alcove')
 P.setLevel('voxel',3);P.syncOptions(game.save.options);frames(90)
 game.capturePath=assert(os.getenv('POKEPORT_SHOT_DIR'))..'/exploration-entrance-voxel.png'
 until_(function()return not game.capturePath end,'voxel entrance capture')
 P.setLevel('voxel',0);P.syncOptions(game.save.options)
 print('CELEBI ORDINARY EXPLORATION PASS',game.save.version,ex.text.spanish()and 'Spanish'or 'English')
 local first=assert(loadfile('../mods/gen2/celebi_mod/tests/crystal_half.lua'))()
 return first(game)
end
