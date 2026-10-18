-- Development historical opening; disposable imported identities only. No save.
return function(game)
 io.stdout:setvbuf('no')
 local function frames(n)for _=1,n do love.timer.sleep(1/120);coroutine.yield()end end
 local w=game.world
 local function until_(fn,why,n)
  for _=1,n or 2400 do if fn()then return end;frames(1)end
  error('history probe timeout: '..why..' map='..tostring(w.map.id)..' text='..tostring(w.lastText))
 end
 frames(60);game.stack:clear();love.window.setMode(960,540);frames(5)
 game.keypressed=function()end;game.keyreleased=function()end;game.input.pollPads=function()end
 game.input:reset();game.save.options.textSpeed=1
 local ex=assert(game.mods.exports.CELEBI_MOD);print('CELEBI GIOVANNI SOURCE',ex.fieldArt.giovanniSource);local P=require('src.render.Pipelines')
 local Mon=require('src.battle.gen2.Mon')
 game.save.party={Mon.new(game.data,'CELEBI',30,{})}
 ex.quest.progress:advance('caught',{kurtCongratulated=true})
 local function capture(name)
  if w.textbox then until_(function()local t=game.stack:top();return t and(t.waiting or t.done)end,'typing')end
  game.capturePath=assert(os.getenv('POKEPORT_SHOT_DIR'))..'/'..name..'.png'
  until_(function()return not game.capturePath end,'capture',120)
 end
 local function tap()
  game.input:sourcePress('a','celebi-history-probe');game.input:sourceRelease('a','celebi-history-probe');frames(3)
 end
 local levels=assert(({gold={0,3},silver={0},crystal={0}})[game.save.version])
 for _,level in ipairs(levels)do
  P.setLevel('voxel',level);P.syncOptions(game.save.options)
  assert(w:setMap('ILEX_FOREST',8,23,'up'));frames(20)
  until_(function()return ex.follower:following(game,w)end,'follower ready')
  assert(w.vm:start({{op='modcommand',verb='CELEBI_MOD:historyOpening',args={}},{op='end'}}))
  local captures={};local pushed,jumped,sawMan=false,false,false
  for _=1,6000 do
   if not w:busy()then break end
   for _,npc in ipairs(w.npcs)do
    assert(npc.def.name~='CELEBI_PARTNER','forbidden companion')
    if npc.def.name=='CELEBI_MAN'then
     sawMan=true;assert(npc.def.sprite=='SPRITE_CELEBI_GIOVANNI','unexpected Giovanni sprite')
    end
    if npc.def.name=='CELEBI_SILVER'and npc.jumping then
     jumped=true
     if not captures['ledge-hop']then capture('mode-'..level..'-ledge-hop');captures['ledge-hop']=true end
    end
   end
   if w.map.id=='ROUTE_22'and w.player.cellX==15 and w.player.cellY==11 then pushed=true end
   if w.textbox then
    local text=w.lastText or'';local name
    if text:find('THREE YEARS EARLIER',1,true)then name='route22-caption'
    elseif text:find('You told me...',1,true)then name='argument'
    elseif text=='...What are you staring at?'then name='silver-stare'
    elseif text:find('THREE YEARS LATER',1,true)then name='three-years-later'end
    if name and not captures[name]then capture('mode-'..level..'-'..name);captures[name]=true end
    tap()
   else frames(2)end
  end
  assert(not w:busy()and w.map.id==ex.room.id,'historical opening did not finish')
  assert(sawMan and pushed and jumped,'actor blocking did not execute')
  for _,name in ipairs({'route22-caption','argument','silver-stare','three-years-later'})do assert(captures[name],'missing stage '..name)end
  assert(not ex.travel:sample()and not game.save.modData.CELEBI_MOD.travelPending,'effect/checkpoint leaked')
  for _,npc in ipairs(w.npcs)do
   assert(npc.def.name~='CELEBI_MAN'and npc.def.name~='CELEBI_SILVER'and npc.def.name~='CELEBI_TRAVELER','temporary historical actor leaked')
  end
  assert(ex.quest.progress:phase()=='caught'and not game.save.modData.CELEBI_MOD.eventComplete,'unfinished story was marked complete')
  until_(function()return ex.follower:following(game,w)end,'follower resumed')
  -- Ordinary hidden-room interaction remains the broken radio, not history.
  assert(ex.world:warpTo(ex.room.id,6,4,'up'));until_(function()return not w:busy()end,'ordinary room visit')
  tap();until_(function()return w.textbox end,'ordinary radio')
  assert(w.lastText==ex.room.radioText(false),'historical scene replaced normal radio behavior')
  for _=1,200 do if not w:busy()then break end;tap()end
  print('CELEBI HISTORY MODE PASS',game.save.version,level)
 end
 print('CELEBI HISTORY LIVE PASS',game.save.version,'solo scene, argument, stagger, jump, second travel and cleanup')
 love.event.quit()
end
