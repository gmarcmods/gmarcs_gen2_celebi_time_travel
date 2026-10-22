-- Supplemental English publishing views: ordinary room/radio, plus transition.
return function(game)
 io.stdout:setvbuf('no')
 local function frames(n)for _=1,n do coroutine.yield()end end
 local w=game.world;local ex=assert(game.mods.exports.gmarcs_gen2_celebi_time_travel)
 local function until_(fn,label)
  for _=1,1800 do if fn()then return end;frames(1)end;error('extras timeout '..label)
 end
 local function tap()
  game.input:sourcePress('a','celebi-publication-extras');game.input:sourceRelease('a','celebi-publication-extras');frames(3)
 end
 local function shot(name)
  game.capturePath=assert(os.getenv('POKEPORT_SHOT_DIR'))..'/'..name..'.png'
  until_(function()return not game.capturePath end,'capture')
 end
 frames(60);game.stack:clear();game.input:reset();game.input.pollPads=function()end
 game.keypressed=function()end;game.keyreleased=function()end
 love.window.setMode(960,864);game.save.options.textSpeed=1
 game.save.player.name='ETHAN';game.save.rival.name='SILVER'
 assert(not game.mods.exports.GEN2_ES,'English publication only')
 local P=require('src.render.Pipelines');P.setLevel('voxel',0);P.syncOptions(game.save.options)
 for _,complete in ipairs({false,true})do
  game.save.modData.gmarcs_gen2_celebi_time_travel=game.save.modData.gmarcs_gen2_celebi_time_travel or{}
  game.save.modData.gmarcs_gen2_celebi_time_travel.eventComplete=complete
  assert(ex.world:warpTo(ex.room.id,6,4,'up'))
  until_(function()return not w:busy()end,'room');frames(20)
  shot(complete and 'room-after-event'or 'room-before-event')
  tap();until_(function()return w.textbox~=nil end,'radio')
  local key=complete and 'radioComplete'or 'radioBefore'
  assert(w.lastText==ex.text.body(key))
  until_(function()local t=game.stack:top();return t and(t.waiting or t.done)end,'radio page')
  shot(key)
  for _=1,1000 do if not w:busy()then break end;tap()end
 end
 -- Photograph the actual gift command independently of the legacy native
 -- Pokedex/16-badge test, which can leave a blank map bake in its fixture.
 game.save.hallOfFame={count=1,teams={}}
 local oak
 for _,obj in ipairs(w.maps.OAKS_LAB.objects)do if obj.sprite=='SPRITE_OAK'then oak=obj end end
 assert(oak);assert(w:setMap('OAKS_LAB',oak.x,oak.y+1,'up'));frames(30)
 w:refreshMapImages();frames(2)
 assert(w.vm:start({{op='modcommand',verb='gmarcs_gen2_celebi_time_travel:oakGift',args={}},{op='end'}}))
 until_(function()local t=game.stack:top();return w.textbox and w.lastText==ex.text.render('oakGift')and t and(t.waiting or t.done)end,'Oak gift')
 shot('oak-gs-ball-gift')
 for _=1,1200 do if not w:busy()then break end;tap()end
 assert(game.save.inventory.GS_BALL==1)
 assert(w:setMap('ILEX_FOREST',8,23,'up'));frames(20)
 assert(w.vm:start({{op='modcommand',verb='gmarcs_gen2_celebi_time_travel:travel',args={'ROUTE_22',31,8,'up'}},{op='end'}}))
 until_(function()local s=ex.travel:sample();return s and s.tick>=30 end,'swirl')
 shot('time-travel-swirl')
 until_(function()return not w:busy()end,'arrival')
 print('CELEBI PUBLICATION EXTRAS PASS: English radio before/after, permanent room, transition')
 love.event.quit()
end
