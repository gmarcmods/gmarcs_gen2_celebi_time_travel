-- Fast visual regression for the registered map in native/angled/FP/TP views.
return function(game)
 io.stdout:setvbuf('no')
 local function frames(n)for _=1,n do coroutine.yield()end end
 frames(60);game.stack:clear();love.window.setMode(960,540)
 local w=game.world;local ex=assert(game.mods.exports.CELEBI_MOD)
 local V=assert(game.mods.exports.NEW_MOD_EX).lib
 local ball=game.data.items.GS_BALL
 if ball and not ball.index then assert(ball.description==ex.text.body('ballDescription'),'new item description is not localized')end
 local P=require('src.render.Pipelines');local T=V.require('TileShape')
 game.keypressed=function()end;game.keyreleased=function()end;game.input.pollPads=function()end
 assert(ex.world:warpTo(ex.room.id,6,6,'up'));frames(90)
 local shapes=T.forMap(w.map)
 assert(T.at(w.map,shapes,w.map:tileAt(12,12),12,12).h==0,'room floor is raised')
 assert(T.at(w.map,shapes,w.map:tileAt(8,0),8,0).h==24,'north wall missing')
 assert(T.at(w.map,shapes,16,0,0).class=='void','black border became a wall')
 assert(#V.require('Structures').forMap(w.map).assetStamps==0,'wall tiles matched cave boulder assets')
 local cave=V.require('CaveInterior').layout(w.map)
 assert(#cave.walls==0 and #cave.hangings==0,'procedural detail overlaps room-owned walls')
 for _,level in ipairs({0,3,6,7})do
  P.setLevel('voxel',level);P.syncOptions(game.save.options);frames(90)
  game.capturePath=assert(os.getenv('POKEPORT_SHOT_DIR'))..'/room-final-mode-'..level..'.png'
  for _=1,120 do if not game.capturePath then break end;frames(1)end
  assert(not game.capturePath,'room capture failed')
 end
 print('CELEBI ROOM VISUAL PASS',game.save.version,'native, angled, first person, third person; no overlapping rock detail')
 love.event.quit()
end
