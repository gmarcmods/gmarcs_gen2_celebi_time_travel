-- Interactive review using a disposable identity. Real story battle, no save.
return function(game)
 io.stdout:setvbuf('no')
 local function frames(n)for _=1,n do love.timer.sleep(1/60);coroutine.yield()end end
 frames(60);game.stack:clear();love.window.setMode(1100,720)
 local ex=assert(game.mods.exports.CELEBI_MOD);local w=game.world
 local Mon=require('src.battle.gen2.Mon');local P=require('src.render.Pipelines')
 game.save.party={Mon.new(game.data,'CELEBI',60,{moves={
  {id='PSYCHIC',pp=10,maxPp=10},{id='SWIFT',pp=20,maxPp=20},
  {id='RECOVER',pp=20,maxPp=20},{id='ANCIENTPOWER',pp=5,maxPp=5},
 }})}
 ex.quest.progress:advance('caught',{kurtCongratulated=true})
 game.save.modData.CELEBI_MOD.eventComplete=nil
 game.save.options.textSpeed=1
 P.setLevel('voxel',3);P.syncOptions(game.save.options)
 assert(w:setMap('ILEX_FOREST',8,23,'up'));frames(20)
 local ready=false
 for _=1,600 do if ex.follower:following(game,w)then ready=true;break end;frames(1)end
 assert(ready,'review follower did not start')
 assert(w.vm:start({{op='modcommand',verb='CELEBI_MOD:historyOpening',args={}},{op='end'}}))
 print('CELEBI REVIEW READY: interactive upper-path scene, speaker labels, Giovanni/radio, actual boss battle and return. A advances text; no save is written.')
 local captured={}
 while true do
  local top=game.stack:top()
  if w.textbox and top and(top.waiting or top.done)then
   for _,id in ipairs({'routeRival1','hideoutWarning','radioCall','timePresent'})do
    if not captured[id]and w.lastText==ex.text.render(id)then
     game.capturePath=assert(os.getenv('POKEPORT_SHOT_DIR'))..'/review-'..id..'.png';captured[id]=true
    end
   end
  end
  frames(1)
 end
end
