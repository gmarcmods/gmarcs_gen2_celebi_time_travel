-- Disposable identities only: real native delivery/choices/battle/catch. No save.
return function(game,oakOnly,publication)
 io.stdout:setvbuf('no')
 -- Keep desktop keyboard/controller activity out of the disposable probe;
 -- all test actions still pass through the real sourcePress/Release queue.
 game.keypressed=function()end;game.keyreleased=function()end
 game.input.pollPads=function()end;game.input:reset()
 local function frames(n)for _=1,n do love.timer.sleep(1/120);coroutine.yield()end end
 local w=game.world
 local function until_(fn,why,n)
  for _=1,n or 1800 do if fn()then return end;frames(1)end
  local top=game.stack:top();if top then print('TOP DEBUG',require('src.core.SaveData').encode(top.pages or{}))end;local keys={};for k in pairs(top or{})do keys[#keys+1]=tostring(k)end
  error('timeout '..why..' map='..tostring(w.map.id)..' phase='..tostring(w.vm.ctxKey)..' player='..w.player.cellX..','..w.player.cellY..','..w.player.facing..' busy='..tostring(w:busy())..' top='..table.concat(keys,',')..' text='..tostring(w.lastText))
 end
 local function tap(key)
  game.input:sourcePress(key,'celebi-quest-probe');game.input:sourceRelease(key,'celebi-quest-probe')
  until_(function()return #game.input.pressQueue==0 end,'tap',120);frames(3)
 end
 local function walk(dir)
  local p=w.player;local x,y=p.cellX,p.cellY
  game.input:sourcePress(dir,'celebi-quest-walk')
  until_(function()return p.moving or p.cellX~=x or p.cellY~=y end,'walk',240)
  game.input:sourceRelease(dir,'celebi-quest-walk')
  until_(function()return not p.moving end,'walk landing',240)
 end
 local function idle()return not w:busy()and game.stack:top()==nil end
 local function exitCenter()
  game.input:sourcePress('down','celebi-quest-exit')
  until_(function()return w.map.id~='GOLDENROD_POKECENTER_1F'or w.vm:running()end,'center exit',600)
  game.input:sourceRelease('down','celebi-quest-exit')
 end
 local function drain(why)
  for _=1,1200 do
   if idle()then return end
   if w.textbox or w.choicebox then tap('a')else frames(3)end
  end
  error('scene did not finish: '..why)
 end
 local function capture(name)
  if w.textbox then until_(function()local t=game.stack:top();return t and(t.done or t.waiting)end,'typing')end
  frames(5);game.capturePath=assert(os.getenv('POKEPORT_SHOT_DIR'))..'/'..name..'.png'
  until_(function()return not game.capturePath end,'capture',120)
 end
 frames(60);game.stack:clear();love.window.setMode(960,540);frames(5)
 game.save.options.textSpeed=1
 local ex=assert(game.mods.exports.CELEBI_MOD);local progress=ex.quest.progress
 local modes={gold={voxel=true},silver={},crystal={}}
 local mode=assert(modes[game.save.version],'probe requires a Gen 2 edition')
 local Mon=require('src.battle.gen2.Mon');local Bag=require('src.inventory.Bag')
 local Pipelines=require('src.render.Pipelines');Pipelines.setLevel('voxel',0);Pipelines.syncOptions(game.save.options)
 assert(progress:phase()=='none','probe needs an untouched isolated save')
 assert(game.data.items.GS_BALL and game.data.items.GS_BALL.pocket=='KEY_ITEM')
 -- No Goldenrod interception, before or after League. Native calls retain
 -- their single pending slot; the invitation never consumes Elm's ticket call.
 game.save.hallOfFame={count=0,teams={}}
 assert(w:setMap('GOLDENROD_POKECENTER_1F',3,6,'down'));frames(10)
 if publication then
  -- Capture fixtures do not test the engine's directional carpet transition.
  assert(w:setMap('GOLDENROD_CITY',20,20,'down'))
 else exitCenter()end
 until_(function()return w.map.id=='GOLDENROD_CITY'and idle()end,'pre-HoF exit')
 assert(progress:phase()=='none'and not game.save.inventory.GS_BALL)
 game.save.hallOfFame.count=1
 local Phone=require('src.core.gen2.Phone')
 for _,id in ipairs(Phone.contacts(game.save))do assert(id~=2,'Oak already in phonebook fixture')end
 Phone.queueSpecialCall(game.save,1)
 assert(w:setMap('OAKS_LAB',4,3,'up'));frames(10)
 -- Walk only indoors so the native pending call cannot fire in this fixture.
 walk('down');assert(Phone.hasSpecialCall(game.save)and not w.queuedScript,'Oak displaced native special call')
 Phone.clearSpecialCall(game.save)
 assert(w:setMap('PALLET_TOWN',8,8,'right'));frames(10);walk('right')
 until_(function()return w.vm:running()end,'Oak ring started')
 until_(function()return w.textbox end,'Oak caller box');capture('oak-invitation-ring')
 drain('Oak invitation')
 assert(game.save.modData.CELEBI_MOD.oakCallHeard,'invitation not persisted')
 for _,id in ipairs(Phone.contacts(game.save))do assert(id~=2,'incoming invitation registered an unwanted number')end
 assert(progress:phase()=='none'and not game.save.inventory.GS_BALL)
 -- Fill the real key pocket, using fixture-only items; the native Oak
 -- interaction must finish normally and the failed gift must remain retryable.
 local fillers={}
 for i=1,Bag.capacity(game.data,'KEY_ITEM')do
  local id='CELEBI_TEST_KEY_'..i;game.data.items[id]={name='TEST',pocket='KEY_ITEM'}
  game.save.inventory[id]=1;fillers[#fillers+1]=id
 end
 local function talkOak()
  local oak
  for _,obj in ipairs(w.maps.OAKS_LAB.objects)do if obj.sprite=='SPRITE_OAK'then oak=obj end end
  assert(oak,'native Oak absent')
  assert(w:setMap('OAKS_LAB',oak.x,oak.y+1,'up'));frames(10)
  assert(w:facingObject()and w:facingObject().def.sprite=='SPRITE_OAK')
  tap('a');until_(function()return w.textbox end,'native Oak text')
 end
 -- Eight badges takes Oak's native Kanto encouragement and Pokédex branch.
 game.save.player.badges={}
 for _,id in ipairs({'ZEPHYR','HIVE','PLAIN','FOG','STORM','MINERAL','GLACIER','RISING'})do game.save.player.badges[id]=true end
 assert(w:readVar(7)==8,'invalid native eight-badge fixture')
 local function oakDrain()
  for _=1,2000 do
   if idle()and not w.queuedScript then return end
   if w.textbox or w.choicebox then tap('a')else frames(3)end
  end
  error('Oak scene did not finish')
 end
 talkOak()
 for _=1,1200 do
  if w.lastText==ex.text.render('oakFull')and w.textbox then break end
  if w.textbox then tap('a')else frames(3)end
 end
 assert(progress:phase()=='none'and not game.save.inventory.GS_BALL,'full key pocket committed gift')
 assert(w.lastText==ex.text.render('oakFull'),'full pocket did not show retry message: '..tostring(w.lastText))
 capture('oak-full-pocket');oakDrain()
 for _,id in ipairs(fillers)do game.save.inventory[id]=nil;game.data.items[id]=nil end
 -- Retry with all badges: Mt. Silver must unlock before the eligible gift.
 local oakScript
 for _,obj in ipairs(w.maps.OAKS_LAB.objects)do if obj.sprite=='SPRITE_OAK'then oakScript=obj.scriptKey end end
 local unlock
 local visited={}
 local function findUnlock(key)
  if visited[key]then return end;visited[key]=true
  for _,row in ipairs(w.vm.scripts[key]or{})do
   if row.op=='ifequal'and row.value==16 then
    for _,branch in ipairs(w.vm.scripts[row.script]or{})do if branch.op=='setevent'then unlock=branch.event end end
   end
   if row.script then findUnlock(row.script)end
  end
 end
 findUnlock(oakScript);assert(unlock,'native Mt. Silver unlock not found')
 game.save.player.kantoBadges={}
 for _,id in ipairs({'BOULDER','CASCADE','THUNDER','RAINBOW','SOUL','MARSH','VOLCANO','EARTH'})do game.save.player.kantoBadges[id]=true end
 assert(w:readVar(7)==16,'invalid native sixteen-badge fixture')
 talkOak()
 -- Capture the appended gift, after the native dialogue has run.
 for _=1,1200 do
  if w.lastText==ex.text.render('oakGift')then break end
  if w.textbox then tap('a')else frames(3)end
 end
 assert(w.lastText==ex.text.render('oakGift'),'Oak gift did not follow native dialogue')
 capture('oak-gs-ball-gift');oakDrain()
 assert(w.events:get(unlock),'native 16-badge Mt. Silver unlock was shadowed by the gift')
 assert(progress:phase()=='delivered'and game.save.inventory.GS_BALL==1)
 talkOak();oakDrain()
 assert(w.events:get(unlock),'native 16-badge Mt. Silver unlock was shadowed')
 assert(progress:phase()=='delivered'and game.save.inventory.GS_BALL==1 and not w.queuedScript,'duplicate lab gift')
 print('CELEBI OAK LIVE PASS',game.save.version,'native pending call, incoming invitation, full pocket/retry, Mt. Silver unlock and no duplicate')
 if oakOnly then love.event.quit();return end
 local Screens=require('src.ui.Screens')
 Screens.push(game,'Gen2PackMenu',{pocket='KEY_ITEM',onClose=function()game.stack:pop()end})
 local pack=game.stack:top();local found
 for _,row in ipairs(pack.rows)do if row.id=='GS_BALL'then found=row end end
 assert(found and found.name==game.data.items.GS_BALL.name,'GS Ball not displayed in native key-item pocket')
 for _,id in ipairs(pack:submenuRows('GS_BALL'))do assert(id~='toss'and id~='give','GS Ball is disposable')end
 capture('gs-ball-pack');tap('b');until_(idle,'pack closed')
 -- Native Kurt A-press, retaining his ordinary event flags.
 local function talkKurt()
  assert(w:setMap('KURTS_HOUSE',3,3,'up'));frames(10)
  assert(w:facingObject()and w:facingObject().def.sprite=='SPRITE_KURT','probe did not face native Kurt')
  tap('a');until_(function()return w.textbox end,'Kurt text')
 end
 talkKurt();capture('kurt-handover');drain('handover')
 assert(progress:phase()=='inspecting'and not game.save.inventory.GS_BALL)
 local SaveData=require('src.core.SaveData')
 local restored=assert(SaveData.decode(SaveData.encode(game.save)))
 require('src.core.gen2.Save').normalize(restored)
 game.save=restored;game:adoptSave(restored)
 assert(progress:phase()=='inspecting'and not game.save.inventory.GS_BALL,'quest state failed native save serialization/rebind')
 assert(game.save.modData.CELEBI_MOD.oakCallHeard,'Oak invitation state failed save serialization/rebind')
 talkKurt();drain('same-day inspection');assert(progress:phase()=='inspecting')
 w.clockDay=(w:weekday()+1)%7
 talkKurt();capture('kurt-next-day')
 local flagsBefore=SaveData.encode(w.events:serialize())
 local masksBefore=SaveData.encode(w.objectMasks or{})
 drain('next-day callback')
 for _,npc in ipairs(w.npcs)do
  if npc.def.sprite=='SPRITE_KURT'then
   assert(npc.cellX==-32 and npc.def.x>=0,'Kurt did not leave, or his native definition was moved')
  end
 end
 assert(SaveData.encode(w.events:serialize())==flagsBefore,'Kurt scene changed vanilla event flags')
 assert(SaveData.encode(w.objectMasks or{})==masksBefore,'Kurt hiding persisted an object mask')
 capture('kurt-workshop-empty')
 assert(w:setMap('KURTS_HOUSE',3,3,'up'));frames(10)
 for _,npc in ipairs(w.npcs)do if npc.def.sprite=='SPRITE_KURT'then assert(npc.cellX==-32,'Kurt reappeared during the street checkpoint')end end
 assert(progress:phase()=='street')
 assert(w:setMap('AZALEA_TOWN',9,5,'down'));frames(10);walk('down')
 until_(function()return w.textbox end,'street callback');capture('kurt-street');drain('street')
 assert(progress:phase()=='restless'and game.save.inventory.GS_BALL==1)
 -- A real shrine NO must preserve the item and armed state.
 game.save.party={Mon.new(game.data,'TYPHLOSION',100,{moves={{id='SWIFT',pp=20,maxPp=20}}})}
 for _=2,5 do game.save.party[#game.save.party+1]=Mon.new(game.data,'PIDGEY',10,{})end
 local originalParty={unpack(game.save.party)}
 local caught
 game.mods.events:on('pokemon.caught',function(ev)if ev.species=='CELEBI'then caught=ev end end,0,'CELEBI_QUEST_PROBE')
 local function shrinePrompt()
  assert(w:setMap('ILEX_FOREST',8,23,'up'));frames(10);tap('a')
  for _=1,1000 do if w.choicebox then return end;if w.textbox then tap('a')else frames(2)end end
  error('shrine Yes/No prompt did not open')
 end
 game.save.party[6]=Mon.new(game.data,'PIDGEY',10,{})
 assert(w:setMap('ILEX_FOREST',8,23,'up'));frames(10);tap('a')
 until_(function()return w.textbox end,'full party refusal')
 assert(w.lastText==ex.text.render('partyFull'),'full party did not block GS Ball placement')
 drain('full party refusal')
 assert(progress:phase()=='restless'and game.save.inventory.GS_BALL==1,'full party consumed GS Ball')
 table.remove(game.save.party)
 shrinePrompt();tap('b');drain('shrine NO')
 assert(progress:phase()=='restless'and game.save.inventory.GS_BALL==1)
 shrinePrompt();capture('shrine-choice')
 if mode.voxel then
  game.mods.exports.NEW_MOD_EX.lib.require('GoldBattle').setting:setValue('flatB',game)
  Pipelines.setLevel('voxel',3);Pipelines.syncOptions(game.save.options)
 end
 tap('a')
 local arrivalHigh,arrivalLow
 for _=1,1000 do
  local top=game.stack:top();if top and top.battle then break end
  for _,npc in ipairs(w.npcs)do
   if npc.def.name=='CELEBI_APPEARANCE'then
    assert(npc.def.sprite=='SPRITE_CELEBI'and npc.passable)
    if not arrivalHigh then arrivalHigh=npc.spriteYOffset;capture('celebi-arrival-high')end
    if npc.spriteYOffset>-10 and not arrivalLow then arrivalLow=npc.spriteYOffset;capture('celebi-arrival-low')end
   end
  end
  if w.textbox then tap('a')else frames(3)end
 end
 assert(arrivalHigh and arrivalLow and arrivalHigh<arrivalLow-8,'Celebi did not visibly descend into the shrine')
 for _,npc in ipairs(w.npcs)do assert(npc.def.name~='CELEBI_APPEARANCE','appearance actor leaked into battle')end
 local state=assert(game.stack:top());assert(state.battle,'Celebi battle did not open')
 assert(state.battle.enemy.species=='CELEBI'and state.battle.enemy.level==30)
 assert(state.battle.battleType==11 and state.battle:noEscapeBattleType())
 assert(progress:phase()=='encounter'and not game.save.inventory.GS_BALL)
 for _=1,900 do if state.phase=='menu'then break end;tap('a')end
 assert(state.phase=='menu');capture('celebi-encounter')
 state:chooseMenu('run')
 for _=1,900 do if state.phase=='menu'then break end;tap('a')end
 assert(state.phase=='menu'and not state.battle.over,'Celebi encounter allowed escape')
 -- Use the real catch path, including animation, storage and nickname prompt.
 for _,mon in ipairs(game.save.party)do
  mon.hp=1;mon.status='PSN';for _,move in ipairs(mon.moves or{})do move.pp=0 end
 end
 state.battle.enemy.hp=1;state.battle.enemy.status='PAR'
 assert(Bag.add(game.save,'MASTER_BALL',1,game.data));state:useItem('MASTER_BALL')
 local finish=assert(loadfile('../mods/gen2/celebi_mod/tests/continuous_history_live.lua'))()
 return finish(game,state,originalParty,function()return caught end)
end
