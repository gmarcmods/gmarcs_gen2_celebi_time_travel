-- Starts during the actual native capture. Only A/B/menu actions are sent;
-- no movement, party reordering, warps or shrine rereads before the return.
return function(game,captureState,originalParty,caughtEvent)
 local w=game.world;local ex=game.mods.exports.gmarcs_gen2_celebi_time_travel
 local function frames(n)for _=1,n do coroutine.yield()end end
 local function tap(key)
  game.input:sourcePress(key or'a','celebi-continuous');game.input:sourceRelease(key or'a','celebi-continuous');frames(2)
 end
 local function shot(name)
  game.capturePath=assert(os.getenv('POKEPORT_SHOT_DIR'))..'/continuous-'..name..'.png'
  for _=1,120 do if not game.capturePath then return end;frames(1)end;error('continuous capture failed')
 end
 if game.options then game.options.battleStyle='SET'end
 local sawKurt,startedTravel,boss,returned=false,false,nil,false
 local captures={}
 for tick=1,30000 do
  local top=game.stack:top()
  for _,npc in ipairs(w.npcs)do if npc.def.name=='CELEBI_KURT_WATCHER'then sawKurt=true end end
  if w.map.id=='ROUTE_22'and not startedTravel then
   assert(sawKurt,'time travel skipped Kurt')
   assert(w.vm:running(),'capture VM ended before automatic time travel')
   startedTravel=true;print('CELEBI AUTO TRAVEL PASS',game.save.version)
  end
  if w.battleActive and top and type(top.battle)=='table'then
   local battle=top.battle
   if battle.trainer and battle.trainer.classId=='CELEBI_GIOVANNI'then
    if not boss then
     boss=top
     assert(#game.save.party==6 and caughtEvent().destination=='party','Celebi was not in the reserved party slot')
     for _,mon in ipairs(game.save.party)do
      assert(mon.hp==mon.maxHp and not mon.status,'party HP/status was not healed before Giovanni')
      for _,move in ipairs(mon.moves or{})do assert(move.pp==move.maxPp,'party PP was not restored')end
     end
     for i,mon in ipairs(originalParty)do assert(game.save.party[i]==mon,'automatic event reordered the team')end
     assert(game.save.party[6]==caughtEvent().mon,'event did not retain just-caught Celebi')
     print('CELEBI HEALED PARTY PASS',game.save.version,'six members; HP/status/PP; original lead/order')
    end
    if top.phase=='menu'then top:chooseMenu('fight');frames(1)
    elseif top.phase=='moves'then
     local found
     for i,move in ipairs(top:playerMoves())do if move.pp>0 and(game.data.moves[move.id].power or 0)>0 then found=i;break end end
     assert(found,'no damage move for continuous probe');top:chooseMove(found);frames(1)
    elseif top.phase=='ask-shift'then tap('b')else tap()end
   else tap(top.phase=='ask-nickname'and'b'or'a')end
  elseif w.textbox then
   local name
   for _,id in ipairs({'congratulations','timeRoute22','radioCall','timePresent'})do if w.lastText==ex.text.render(id)then name=id;break end end
   if name=='timePresent'then returned=true end
   if name and not captures[name]and top and(top.waiting or top.done)then shot(name);captures[name]=true end
   tap()
  else
   if not w:busy()and not top then
    assert(returned,'event stopped after capture/Kurt and required another interaction')
    break
   end
   frames(2)
  end
 end
 assert(startedTravel and boss and boss.battle.outcome=='win'and returned,'continuous event did not finish')
 assert(w.map.id=='ILEX_FOREST'and w.player.cellX==8 and w.player.cellY==23,'victory did not return to shrine')
 assert(ex.quest.progress:state().kurtCongratulated and game.save.modData.gmarcs_gen2_celebi_time_travel.eventComplete)
 assert(#game.save.party==6 and game.save.party[6]==caughtEvent().mon)
 for i,mon in ipairs(originalParty)do assert(game.save.party[i]==mon,'return changed party order')end
 local SaveData=require('src.core.SaveData')
 assert(SaveData.decode(SaveData.encode(game.save)).modData.gmarcs_gen2_celebi_time_travel.eventComplete)
 assert(ex.world:warpTo(ex.room.id,6,4,'up'))
 for _=1,600 do if not w:busy()then break end;frames(1)end
 tap()
 for _=1,600 do if w.textbox then break end;frames(1)end
 assert(w.lastText==ex.text.body('radioComplete'),'completed radio translation/state is wrong')
 print('CELEBI CONTINUOUS LIFECYCLE PASS',game.save.version,'actual party-slot refusal, catch, full heal, Kurt -> automatic travel, real boss, Ilex return, localized radio')
 love.event.quit()
end
