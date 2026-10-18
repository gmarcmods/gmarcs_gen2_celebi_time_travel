-- Real native interactions in isolated identities. Never writes a game save.
return function(game)
 io.stdout:setvbuf('no')
 local function frames(n)for _=1,n do love.timer.sleep(1/120);coroutine.yield()end end
 local function until_(fn,why,n)
  for _=1,n or 600 do if fn()then return end;frames(1)end
  local w=game.world;local p=w and w.player
  error('timed out: '..why..' map='..tostring(w and w.map.id)..' player='..tostring(p and p.cellX)..','..tostring(p and p.cellY)..','..tostring(p and p.facing)..' busy='..tostring(w and w:busy())..' top='..tostring(game.stack:top())..' text='..tostring(w and w.lastText))
 end
 local function tap(key)
  game.input:sourcePress(key,'celebi-probe');game.input:sourceRelease(key,'celebi-probe')
  until_(function()return #game.input.pressQueue==0 end,'input',120);frames(3)
 end
 local function capture(name)
  if game.world.textbox then
   until_(function()local top=game.stack:top();return top and(top.waiting or top.done)end,'text typing')
  end
  frames(5);game.capturePath=assert(os.getenv('POKEPORT_SHOT_DIR'))..'/'..name..'.png'
  until_(function()return not game.capturePath end,'capture',120)
 end
 local function walk(key)
  local p=game.world.player
  local x,y=p.cellX,p.cellY
  game.input:sourcePress(key,'celebi-probe-walk')
  until_(function()return p.moving or p.cellX~=x or p.cellY~=y end,'walk '..key,120)
  game.input:sourceRelease(key,'celebi-probe-walk')
 end
 local function dismiss()
  for _=1,200 do if not game.world.textbox then return end;tap('a');frames(3)end
  error('text did not close')
 end
 frames(60)
 love.window.setMode(960,540);frames(5)
 local ex=assert(game.mods.exports.CELEBI_MOD,'Celebi mod is not loaded')
 local room,api=ex.room,ex.world
 local world=game.world
 local function idle()return not world:busy()and game.stack:top()==nil end
 -- Discard unrelated first-boot mod notices in this disposable test session.
 -- They otherwise consume the first A press instead of the overworld.
 game.stack:clear()
 local P=require('src.render.Pipelines');P.setLevel('voxel',0);P.syncOptions(game.save.options)
 -- Observe the actual shrine read, then intercept the same script command.
 local observed,intercepted,shrineScript
 game.mods.hooks:wrap('script.command',function(next_,ctx,name,args,cmd)
  if world.map.id=='ILEX_FOREST'and ctx.scriptKey==shrineScript and intercepted==false then
   intercepted=true;return 'end'
  end
  return next_(ctx,name,args,cmd)
 end,0,'CELEBI_PROBE')
 game.mods.events:on('script.started',function(ev)
  print('CELEBI SCRIPT OBSERVE',ev.ctx.mapId,ev.ctx.kind,ev.ctx.scriptKey)
  if ev.ctx.scriptKey==shrineScript and ev.ctx.kind=='script'then observed=ev.ctx.scriptKey end
 end,0,'CELEBI_PROBE')
 assert(world:setMap('ILEX_FOREST',8,23,'up'));frames(10)
 shrineScript=assert(world:bgEventAt(8,22),'native shrine missing').scriptKey
 tap('a');until_(function()return world.textbox end,'native shrine text')
 assert(observed,'no script.started for shrine: '..tostring(world.lastText));capture('shrine-native');dismiss()
 until_(function()return not world:busy()end,'shrine finish')
 intercepted=false;tap('a');frames(10)
 assert(intercepted and not world.textbox,'shrine interception did not suppress vanilla text')
 print('CELEBI SHRINE SEAM PASS',game.save.version,observed)
 -- Real walking onto the new entrance, not direct warping to the room.
 assert(world:setMap('TOHJO_FALLS',room.entrance.x,room.entrance.y+1,'up'));frames(10)
 capture('hidden-room-entrance');walk('up')
 until_(function()return world.map.id==room.id and idle()end,'room entrance warp')
 assert(#world.npcs==1,'ordinary room visit spawned cutscene actors')
 capture('hidden-room-2d')
 assert(api:warpTo(room.id,6,4,'up'));until_(idle,'radio approach');tap('a')
 until_(function()return world.textbox end,'radio before')
 assert(world.lastText==ex.text.body('radioBefore'));capture('radio-before');dismiss()
 game.save.modData.CELEBI_MOD={eventComplete=true}
 assert(api:warpTo(room.id,6,4,'up'));until_(idle,'radio revisit');tap('a')
 until_(function()return world.textbox end,'radio after')
 assert(world.lastText==ex.text.body('radioComplete'));capture('radio-after');dismiss()
 -- Actor movement uses the normal engine movement slot and blocks input.
 local id=assert(api:spawnNpc(room.id,{name='PROBE_KURT',sprite='SPRITE_KURT',
  x=4,y=5,movement=6,hours={-1,-1},radius={x=0,y=0}}))
 local actor=assert(api:npc(room.id,id));local done
 assert(actor:scriptMove('right',2,function()done=true end))
 assert(world:busy(),'scripted movement does not lock input')
 until_(function()return done end,'actor movement')
 local x,y=actor:position();assert(x==6 and y==5,'actor path ended at wrong tile')
 -- Yielding mod commands run inside the native VM with a blocking wait.
 assert(world.vm:start({
  {op='modcommand',verb='CELEBI_MOD:move',args={room.id,id,'left',2}},
  {op='modcommand',verb='CELEBI_MOD:face',args={room.id,id,'up'}},
  {op='modcommand',verb='CELEBI_MOD:wait',args={12}},
  {op='end'},
 }))
 assert(world:busy(),'custom command did not block')
 until_(function()return not world:busy()end,'custom command wait')
 x,y=actor:position();assert(x==4 and y==5 and actor.npc.facing=='up','script move/face did not finish correctly')
 assert(api:removeNpc(id));frames(3);assert(#world.npcs==1,'temporary actor leaked')
 local V=assert(game.mods.exports.NEW_MOD_EX).lib
 P.setLevel('voxel',3);P.syncOptions(game.save.options);frames(20)
 assert(api:warpTo(room.id,6,6,'up'));until_(idle,'voxel approach');capture('hidden-room-voxel')
 P.setLevel('voxel',0);P.syncOptions(game.save.options)
 assert(api:warpTo(room.id,7,8,'down'));until_(idle,'exit approach');walk('down')
 until_(function()return world.map.id=='TOHJO_FALLS'and idle()end,'return warp')
 assert(world.player.cellX==room.entrance.x,'exit landed away from cave entrance')
 print('CELEBI CAPABILITIES PASS',game.save.version,'shrine intercept; room entrance/exit; radio states; actor movement; blocking mod command; 2D/voxel room')
 love.event.quit()
end
