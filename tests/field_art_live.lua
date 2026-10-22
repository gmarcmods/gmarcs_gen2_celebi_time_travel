-- Disposable Gen 2 identity: both Giovanni images come from the mod itself.
return function(game)
 io.stdout:setvbuf('no')
 local function frames(n)for _=1,n do love.timer.sleep(1/120);coroutine.yield()end end
 local function until_(fn,why)
  for _=1,1200 do if fn()then return end;frames(1)end;error('field art timeout: '..why)
 end
 frames(60);game.stack:clear();love.window.setMode(960,540);frames(5)
 local ex=assert(game.mods.exports.gmarcs_gen2_celebi_time_travel);local w=game.world
 local expectedSource='rom-cache'
 assert(ex.fieldArt.giovanniSource==expectedSource,'live Gen 1 sprite selection failed: '..ex.fieldArt.giovanniSource)
 local record=assert(w.sprites.SPRITE_CELEBI_GIOVANNI)
 assert(record.image:find('assets/generated/sprites/giovanni.png',1,true),'overworld graphic path is wrong')
 local State=require('src.ui.gen2.BattleState')
 local pic=assert(State.trainerArt(game.data,'CELEBI_GIOVANNI'))
 assert(pic:find('assets/generated/battle/trainers/giovanni.png',1,true),'trainer registry did not resolve portrait path')
 local image=love.graphics.newImage(pic);assert(image:getWidth()==56 and image:getHeight()==56)
 image:release()
 local Mon=require('src.battle.gen2.Mon');local P=require('src.render.Pipelines')
 game.save.party={Mon.new(game.data,'CELEBI',30,{})}
 ex.quest.progress:advance('caught',{kurtCongratulated=true})
 assert(w:setMap('ROUTE_22',14,11,'up'));frames(20)
 local id=assert(ex.world:spawnNpc('ROUTE_22',{name='CELEBI_ART_PROBE',sprite='SPRITE_CELEBI_GIOVANNI',x=12,y=8,movement=6,hours={-1,-1},radius={x=0,y=0}}))
 local actor=assert(ex.world:npc('ROUTE_22',id));actor:face('right')
 P.setLevel('voxel',0);P.syncOptions(game.save.options)
 game.input:sourcePress('up','field-art-probe')
 until_(function()return w.player.moving end,'player step')
 game.input:sourceRelease('up','field-art-probe')
 until_(function()return not w.player.moving end,'step completes')
 frames(24)

 for _,level in ipairs({0,3})do
  P.setLevel('voxel',level);P.syncOptions(game.save.options);frames(12)
  assert(ex.follower:following(game,w),'GSC Celebi is not following')
  local follower=w.follower
  assert(follower.sprite.objColors[2][1]==238 and follower.sprite.objColors[3][1]==115,'wrong Celebi palette')
  assert(actor.npc.spriteDef.image==record.image,'Gen 1 Giovanni did not instantiate')
  game.capturePath=assert(os.getenv('POKEPORT_SHOT_DIR'))..'/gen1-giovanni-gsc-celebi-mode-'..level..'.png'
  until_(function()return not game.capturePath end,'capture')
 end
 assert(ex.world:removeNpc(id))
 print('CELEBI BUNDLED FIELD ART LIVE PASS',game.save.version,ex.fieldArt.giovanniSource,'native + voxel, GSC Celebi colors and gate clearing')
 love.event.quit()
end
