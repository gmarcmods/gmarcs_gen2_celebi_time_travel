-- Disposable identity only. No save writes; player/Celebi-only opening.
return function(game)
 io.stdout:setvbuf('no')
 local function frames(n)for _=1,n do love.timer.sleep(1/120);coroutine.yield()end end
 local function until_(fn,why)
  for _=1,1800 do if fn()then return end;frames(1)end
  error('solo shrine probe timeout: '..why..' text='..tostring(game.world.lastText))
 end
 frames(60);game.stack:clear();love.window.setMode(960,540);frames(5)
 game.save.options.textSpeed=1
 local ex=assert(game.mods.exports.gmarcs_gen2_celebi_time_travel);local w=game.world
 local P=require('src.render.Pipelines');local Mon=require('src.battle.gen2.Mon')
 game.save.party={Mon.new(game.data,'CELEBI',30,{rng=function(a)return a end,otName='PROBE',otId=123})}
 ex.quest.progress:advance('caught',{kurtCongratulated=true})
 local function capture(name)
  if w.textbox then until_(function()local top=game.stack:top();return top and(top.waiting or top.done)end,'caption typing')end
  game.capturePath=assert(os.getenv('POKEPORT_SHOT_DIR'))..'/'..name..'.png'
  until_(function()return not game.capturePath end,'capture')
 end
 local function tap()
  game.input:sourcePress('a','celebi-shrine-probe');game.input:sourceRelease('a','celebi-shrine-probe');frames(4)
 end
 local function noCompanion()
  for _,npc in ipairs(w.npcs)do
   assert(npc.def.name~='CELEBI_PARTNER','unexpected companion')
   assert(npc.def.sprite~='SPRITE_CELEBI_LYRA'and npc.def.sprite~='SPRITE_CELEBI_ETHAN','unexpected counterpart')
  end
 end
 for _,level in ipairs({0,3})do
  P.setLevel('voxel',level);P.syncOptions(game.save.options)
  assert(w:setMap('ILEX_FOREST',8,23,'up'));frames(20)
  until_(function()return ex.follower:following(game,w)end,'Celebi follower')
  assert(ex.shrineScene:eligible(game))
  assert(w.vm:start({{op='modcommand',verb='gmarcs_gen2_celebi_time_travel:shrineJump',args={}},{op='end'}}))
  until_(function()
   for _,npc in ipairs(w.npcs)do if npc.def.name=='CELEBI_TRAVELER'then return true end end
  end,'Celebi circling')
  frames(12);noCompanion();capture('mode-'..level..'-solo-orbit')
  until_(function()return w.map.id=='ROUTE_22'and w.textbox end,'arrival caption')
  noCompanion()
  assert(w.lastText=='THREE YEARS EARLIER...\fKANTO - ROUTE 22.','partner exposition replaced time caption')
  capture('mode-'..level..'-solo-caption')
  for _=1,200 do if not w:busy()then break end;tap()end
  assert(not w:busy()and not ex.travel:sample(),'scene leaked VM/effect')
  for _,npc in ipairs(w.npcs)do assert(npc.def.name~='CELEBI_TRAVELER','temporary Celebi leaked')end
  until_(function()return ex.follower:following(game,w)end,'follower restored')
 end
 game.save.modData.gmarcs_gen2_celebi_time_travel.travelPending={mapId='ILEX_FOREST',x=8,y=23,facing='up'}
 until_(function()return w:busy()end,'checkpoint recovery begins')
 until_(function()return not w:busy()and w.map.id=='ILEX_FOREST'end,'checkpoint recovery finishes')
 assert(not game.save.modData.gmarcs_gen2_celebi_time_travel.travelPending and not ex.travel:sample())
 print('CELEBI SOLO SHRINE LIVE PASS',game.save.version,'orbit, caption, no partner, native + voxel, recovery')
 love.event.quit()
end
