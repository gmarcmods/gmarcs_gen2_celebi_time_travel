-- User review: disposable identity, paced playback, then leave the game open.
return function(game)
 io.stdout:setvbuf('no')
 local function frames(n)for _=1,n do love.timer.sleep(1/60);coroutine.yield()end end
 local function until_(fn,why)
  for _=1,1800 do if fn()then return end;frames(1)end;error('review timeout: '..why)
 end
 frames(60);game.stack:clear();love.window.setMode(1100,720);frames(5)
 local ex=assert(game.mods.exports.CELEBI_MOD);local w=game.world
 assert(ex.fieldArt.giovanniSource=='bundled-gen1')
 local Mon=require('src.battle.gen2.Mon');local P=require('src.render.Pipelines')
 game.save.party={Mon.new(game.data,'CELEBI',50,{})}
 ex.quest.progress:advance('caught',{kurtCongratulated=true})
 game.save.options.textSpeed=1
 P.setLevel('voxel',3);P.syncOptions(game.save.options)
 assert(w:setMap('ILEX_FOREST',8,23,'up'));frames(20)
 until_(function()return ex.follower:following(game,w)end,'follower')
 assert(w.vm:start({{op='modcommand',verb='CELEBI_MOD:historyOpening',args={}},{op='end'}}))
 print('CELEBI REVIEW PLAYING: paved gate, bundled original Giovanni, automatic text; A also works')
 local lastAdvance=0;local ticks=0;local captured=false
 while w:busy()do
  ticks=ticks+1
  local top=game.stack:top()
  if w.textbox and top and(top.waiting or top.done)and ticks-lastAdvance>100 then
   game.input:sourcePress('a','celebi-review');game.input:sourceRelease('a','celebi-review');lastAdvance=ticks
  end
  if not captured and w.map.id=='ROUTE_22'and w.lastText and w.lastText:find('You told me',1,true)then
   game.capturePath=assert(os.getenv('POKEPORT_SHOT_DIR'))..'/review-bundled-giovanni-gate.png';captured=true
  end
  frames(1)
 end
 print('CELEBI REVIEW OPENING FINISHED: showing original battle portrait in native battle intro preview')
 local Battle=require('src.battle.gen2.Battle');local State=require('src.ui.gen2.BattleState')
 local def=game.data.gen2Trainers.classes.CELEBI_GIOVANNI
 local team={};for _,row in ipairs(def.trainers[1].party)do team[#team+1]=Mon.new(game.data,row.species,row.level,{})end
 local battle=Battle.new({data=game.data,save=game.save,party=game.save.party,
  trainer={class='CELEBI_GIOVANNI',classId='CELEBI_GIOVANNI',name='ROCKET BOSS GIOVANNI',party=team,baseMoney=0}})
 local state=State.new(game,{battle=battle,save=game.save})
 assert(state.enemyTrainerPath:find('assets/giovanni-battle.png',1,true))
 game.stack:push(state)
 frames(18);game.capturePath=assert(os.getenv('POKEPORT_SHOT_DIR'))..'/review-giovanni-battle.png'
 print('CELEBI REVIEW READY: battle portrait preview; disposable session remains open for inspection, no save written')
 while true do frames(1)end
end
