-- Disposable identities only: real native delivery/choices/battle/catch. No save.
return function(game)
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
 local modes={gold={voxel=true},silver={},crystal={fullParty=true}}
 local mode=assert(modes[game.save.version],'probe requires a Gen 2 edition')
 local Mon=require('src.battle.gen2.Mon');local Bag=require('src.inventory.Bag')
 local Pipelines=require('src.render.Pipelines');Pipelines.setLevel('voxel',0);Pipelines.syncOptions(game.save.options)
 assert(progress:phase()=='none','probe needs an untouched isolated save')
 assert(game.data.items.GS_BALL and game.data.items.GS_BALL.pocket=='KEY_ITEM')
 -- Native HoF gating and a real attempted doorway warp.
 game.save.hallOfFame={count=0,teams={}}
 assert(w:setMap('GOLDENROD_POKECENTER_1F',3,6,'down'));frames(10);exitCenter()
 until_(function()return w.map.id=='GOLDENROD_CITY'and idle()end,'pre-HoF exit')
 assert(progress:phase()=='none'and not game.save.inventory.GS_BALL)
 game.save.hallOfFame.count=1
 assert(w:setMap('GOLDENROD_POKECENTER_1F',3,6,'down'));frames(10);exitCenter()
 until_(function()return w.vm:running()end,'delivery started')
 until_(function()return w.textbox end,'delivery dialogue');capture('gs-ball-delivery')
 drain('delivery')
 assert(w.map.id=='GOLDENROD_POKECENTER_1F','delivery failed to hold the exit warp')
 assert(progress:phase()=='delivered'and game.save.inventory.GS_BALL==1)
 for _,obj in ipairs(w.map.def.objects)do assert(obj.name~='CELEBI_DELIVERY','delivery actor leaked')end
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
 game.save.party={Mon.new(game.data,'TYPHLOSION',50,{})}
 local fullParty=mode.fullParty
 if fullParty then for _=2,6 do game.save.party[#game.save.party+1]=Mon.new(game.data,'PIDGEY',10,{})end end
 local caught
 game.mods.events:on('pokemon.caught',function(ev)if ev.species=='CELEBI'then caught=ev end end,0,'CELEBI_QUEST_PROBE')
 local function shrinePrompt()
  assert(w:setMap('ILEX_FOREST',8,23,'up'));frames(10);tap('a')
  for _=1,1000 do if w.choicebox then return end;if w.textbox then tap('a')else frames(2)end end
  error('shrine Yes/No prompt did not open')
 end
 shrinePrompt();tap('b');drain('shrine NO')
 assert(progress:phase()=='restless'and game.save.inventory.GS_BALL==1)
 shrinePrompt();capture('shrine-choice')
 if mode.voxel then
  game.mods.exports.NEW_MOD_EX.lib.require('GoldBattle').setting:setValue('flatB',game)
  Pipelines.setLevel('voxel',3);Pipelines.syncOptions(game.save.options)
 end
 tap('a')
 for _=1,1000 do
  local top=game.stack:top();if top and top.battle then break end
  if w.textbox then tap('a')else frames(3)end
 end
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
 assert(Bag.add(game.save,'MASTER_BALL',1,game.data));state:useItem('MASTER_BALL')
 for _=1,3000 do
  if idle()then break end
  local top=game.stack:top()
  if top==state and state.phase=='ask-nickname'then tap('b')
  elseif top==state and state.phase=='pokedex'then tap('b')
  else
   local watcher
   for _,npc in ipairs(w.npcs)do if npc.def.name=='CELEBI_KURT_WATCHER'then watcher=npc end end
   if watcher and w.textbox and not game.celebiWatcherCaptured then
    game.celebiWatcherCaptured=true;capture('kurt-forest-congratulations')
   end
   tap('a')
  end
 end
 assert(idle(),'capture/congratulations did not finish')
 assert(progress:phase()=='caught','native catch event did not settle quest state')
 assert(game.save.pokedex.caught.CELEBI and #game.save.party==(fullParty and 6 or 2))
 assert(caught and caught.destination==(fullParty and 'box'or'party'))
 if fullParty then
  local Boxes=require('src.core.gen2.Boxes')
  local found=false
  for _,mon in ipairs(Boxes.box(game.save))do if mon==caught.mon then found=true end end
  assert(found,'boxed Celebi was not present in native storage')
 else assert(game.save.party[2].species=='CELEBI'and game.save.party[2].level==30)end
 assert(game.celebiWatcherCaptured,'Kurt did not visibly approach for congratulations')
 for _,npc in ipairs(w.npcs)do assert(npc.def.name~='CELEBI_KURT_WATCHER','Kurt watcher leaked')end
 assert(w:setMap('KURTS_HOUSE',3,3,'up'));frames(10)
 local kurtReturned=false
 for _,npc in ipairs(w.npcs)do if npc.def.sprite=='SPRITE_KURT'and npc.cellX>=0 then kurtReturned=true end end
 assert(kurtReturned,'Kurt did not return to his ordinary workshop after the catch')
 assert(not game.save.inventory.GS_BALL,'consumed GS Ball reappeared')
 assert(w:setMap('ILEX_FOREST',8,23,'up'));frames(10);tap('a');drain('post-catch shrine')
 assert(not w.battleActive and progress:phase()=='caught','post-catch shrine repeated encounter')
 print('CELEBI CRYSTAL HALF PASS',game.save.version,'HoF delivery; real GS Ball; Kurt next day + save roundtrip; street; shrine NO/YES; Celebi30 no-run; native catch/nickname; no duplicate encounter',fullParty and 'PC storage' or 'party storage')
 love.event.quit()
end
