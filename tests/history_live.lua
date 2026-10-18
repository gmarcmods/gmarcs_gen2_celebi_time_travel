-- End-to-end native VM, real trainer combat and both presentation paths.
-- Disposable imported identities only; no save is written.
return function(game)
 io.stdout:setvbuf('no')
 local function frames(n)for _=1,n do love.timer.sleep(1/1000);coroutine.yield()end end
 local w=game.world
 local function until_(fn,why,n)
  for _=1,n or 2400 do if fn()then return end;frames(1)end
  error('history probe timeout: '..why..' map='..tostring(w.map.id)..' text='..tostring(w.lastText))
 end
 frames(60);game.stack:clear();love.window.setMode(960,540);frames(5)
 game.keypressed=function()end;game.keyreleased=function()end;game.input.pollPads=function()end
 game.input:reset();game.save.options.textSpeed=1;game.save.options.battleStyle='SET'
 if game.save.options.gold then game.save.options.gold.battleStyle='SET'end
 if game.options then game.options.battleStyle='SET'end
 local ex=assert(game.mods.exports.CELEBI_MOD);local P=require('src.render.Pipelines')
 local Mon=require('src.battle.gen2.Mon');local TextBox=require('src.render.TextBox')
 game.save.rival.name='RUBEN'
 local function capture(name)
  game.capturePath=assert(os.getenv('POKEPORT_SHOT_DIR'))..'/'..name..'.png'
  until_(function()return not game.capturePath end,'capture',120)
 end
 local function tap()
  game.input:sourcePress('a','celebi-history-probe');game.input:sourceRelease('a','celebi-history-probe');frames(2)
 end
 local levels=os.getenv('POKEPORT_HISTORY_NATIVE')=='1'and {0,3}or {3}
 for _,level in ipairs(levels)do
  game.save.party={Mon.new(game.data,'CELEBI',100,{moves={{id='SWIFT',pp=20,maxPp=20}}}),Mon.new(game.data,'TYPHLOSION',70,{}),Mon.new(game.data,'AMPHAROS',70,{})}
  local originalParty={unpack(game.save.party)}
  ex.quest.progress:advance('caught',{kurtCongratulated=true})
  game.save.modData.CELEBI_MOD.eventComplete=nil
  P.setLevel('voxel',level);P.syncOptions(game.save.options)
  assert(w:setMap('ILEX_FOREST',8,23,'up'));frames(20)
  until_(function()return ex.follower:following(game,w)end,'follower ready')
  tap()
  until_(function()return w.vm:running()end,'ordinary shrine starts history')
  local captures={};local pushed,sawMan,battle,sawRival=false,false,nil,false
  for tick=1,30000 do
   if not w:busy()then break end
   for _,npc in ipairs(w.npcs)do
    assert(npc.def.name~='CELEBI_PARTNER','forbidden companion')
    if npc.def.name=='CELEBI_MAN'then sawMan=true;assert(npc.def.sprite=='SPRITE_CELEBI_GIOVANNI')end
   end
   if w.map.id=='ROUTE_22'and w.player.cellX==32 and w.player.cellY==8 then pushed=true end
   local top=game.stack:top()
   if tick%600==0 then print('CELEBI PROBE TICK',tick,w.map.id,top and top.phase,w.battleActive,top and type(top.battle)=='table'and top.battle.enemy and top.battle.enemy.hp)end
   if w.battleActive and top and type(top.battle)=='table'then
    battle=top
    assert(top.battle.trainer.classId=='CELEBI_GIOVANNI')
    if not captures.battle then
     assert(top.enemyTrainerPath:find('assets/giovanni-battle.png',1,true))
     frames(45);capture('mode-'..level..'-battle');captures.battle=true
     print('CELEBI HISTORY REAL BATTLE',game.save.version,level)
    end
    if top.phase=='menu'then top:chooseMenu('fight');frames(1)
    elseif top.phase=='moves'then assert(top:chooseMove(1));frames(1)
    elseif top.phase=='ask-shift'then game.input:sourcePress('b','celebi-history-probe');game.input:sourceRelease('b','celebi-history-probe');frames(2)
    else tap()end
   elseif w.textbox then
    local text=w.lastText or'';local name
    for _,id in ipairs({'timeRoute22','routeRival1','routeStare','timeHideout','hideoutWarning','radioCall','hideoutDefeat','radioAfter','timePresent'})do
     if text==ex.text.render(id)then name=id;break end
    end
    if name=='routeRival1'then
     assert(TextBox.substitute(game,text):find('RUBEN:',1,true),'chosen rival name missing');sawRival=true
    end
    if name and not captures[name]then
     -- Wait for the actual native text page, without bypassing its animation.
     if top and(top.waiting or top.done)then
      capture('mode-'..level..'-'..name);captures[name]=true;print('CELEBI HISTORY TEXT',name)
     end
    end
    tap()
   else frames(2)end
  end
  assert(not w:busy()and w.map.id=='ILEX_FOREST','history did not return to the shrine')
  assert(sawMan and sawRival and pushed and battle and battle.battle.outcome=='win','real story/combat did not finish')
  assert(game.save.modData.CELEBI_MOD.eventComplete==true,'victory not persisted')
  assert(w.player.cellX==8 and w.player.cellY==23,'victory returned away from Ilex shrine')
  assert(#game.save.party==#originalParty,'history replaced the player team')
  for i,mon in ipairs(originalParty)do assert(game.save.party[i]==mon,'history replaced a party member')end
  local SaveData=require('src.core.SaveData')
  local saved=assert(SaveData.decode(SaveData.encode(game.save)))
  assert(saved.modData.CELEBI_MOD.eventComplete,'completion did not survive native save serialization')
  tap();until_(function()return w.textbox end,'completed shrine text')
  assert(w.lastText==ex.text.render('idle'),'completed event replayed instead of normal shrine text')
  for _=1,200 do if not w:busy()then break end;tap()end
  assert(not ex.travel:sample()and not game.save.modData.CELEBI_MOD.travelPending,'effect/checkpoint leaked')
  until_(function()return ex.follower:following(game,w)end,'follower resumed')
  assert(ex.world:warpTo(ex.room.id,6,4,'up'));until_(function()return not w:busy()end,'ordinary room visit')
  frames(60);capture('mode-'..level..'-room')
  tap();until_(function()return w.textbox end,'ordinary radio')
  assert(w.lastText==ex.text.body('radioComplete'),'radio not localized/completed')
  for _=1,200 do if not w:busy()then break end;tap()end
  print('CELEBI HISTORY MODE PASS',game.save.version,level,'Spanish',ex.text.spanish())
 end
 print('CELEBI HISTORY LIVE PASS',game.save.version,'upper path, rival name, radio, real battle, return, localized room')
 love.event.quit()
end
