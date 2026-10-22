-- Disposable identity only. Native VM crosses maps under a masked transition.
return function(game)
 io.stdout:setvbuf('no')
 local function frames(n)for _=1,n do love.timer.sleep(1/120);coroutine.yield()end end
 local function until_(fn,why)
  for _=1,1500 do if fn()then return end;frames(1)end
  error('travel probe timed out: '..why)
 end
 frames(60);game.stack:clear();love.window.setMode(960,540);frames(5)
 local ex=assert(game.mods.exports.gmarcs_gen2_celebi_time_travel);local w=game.world
 local P=require('src.render.Pipelines')
 local function capture(name)
  game.capturePath=assert(os.getenv('POKEPORT_SHOT_DIR'))..'/'..name..'.png'
  until_(function()return not game.capturePath end,'capture')
 end
 local function jump(map,x,y,facing,label)
  assert(w.vm:start({{op='modcommand',verb='gmarcs_gen2_celebi_time_travel:travel',args={map,x,y,facing}},{op='end'}}))
  assert(w:busy(),'transition does not lock input')
  until_(function()local s=ex.travel:sample();return s and s.tick>=30 end,'swirl')
  capture(label..'-swirl')
  until_(function()local s=ex.travel:sample();return s and s.white==1 end,'white hold')
  capture(label..'-white')
  until_(function()return not w:busy()end,'arrival')
  assert(not ex.travel:sample(),'arrival leaked effect')
  assert(w.map.id==map and w.player.cellX==x and w.player.cellY==y,'wrong destination')
  assert(not game.save.modData.gmarcs_gen2_celebi_time_travel.travelPending,'checkpoint not cleared')
  capture(label..'-arrival')
 end
 for _,level in ipairs({0,3})do
  P.setLevel('voxel',level);P.syncOptions(game.save.options)
  assert(w:setMap('ILEX_FOREST',8,23,'up'));frames(15)
  jump('ROUTE_22',12,8,'left','mode-'..level..'-route22')
  jump('CELEBI_TOHJO_HIDEOUT',6,6,'up','mode-'..level..'-hideout')
  jump('ILEX_FOREST',8,23,'up','mode-'..level..'-return')
 end
 print('CELEBI TRAVEL LIVE PASS',game.save.version,'native + voxel; all three jumps; clean VM and overlay')
 love.event.quit()
end
