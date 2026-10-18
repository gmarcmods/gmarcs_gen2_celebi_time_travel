-- Crystal-half progression. Native VM owns text, choices, battle and input lock.
return function(mod,Progress,Bag)
 local progress=Progress.new(mod.save)
 local game,activeRun,encounterBattle,encounterOpen,streetActor,deliveryTried
 local transient={}
 local function world()return assert(mod.world:overworld(),'world is not ready')end
 local function text(ctx,id)ctx.vm:showText('CELEBI_MOD:'..id)end
 local function hasBall()return game and(game.save.inventory.GS_BALL or 0)>0 end
 local function giveBall()
  if hasBall()then return true end
  return Bag.add(game.save,'GS_BALL',1,game.data)
 end
 local function takeBall()
  if not hasBall()then return false end
  Bag.remove(game.save,'GS_BALL',1,game.data);return true
 end
 local function date()return os.date('%Y-%m-%d')end
 local function remove(id)
  if id then mod.world:removeNpc(id);transient[id]=nil end
 end
 local function cleanup()
  local ids={};for id in pairs(transient)do ids[#ids+1]=id end
  for _,id in ipairs(ids)do remove(id)end
  encounterBattle=nil;encounterOpen=nil
 end
 local function spawn(map,name,sprite,x,y)
  local id=assert(mod.world:spawnNpc(map,{name=name,sprite=sprite,x=x,y=y,
   movement=6,hours={-1,-1},radius={x=0,y=0}}))
  transient[id]=true;return id
 end
 local function move(ctx,map,id,dir,tiles)
  local actor=assert(mod.world:npc(map,id));local done
  assert(actor:scriptMove(dir,tiles,function()done=true end))
  for _=1,600 do if done then return end;ctx.vm:waitFrames(1)end
  error('Celebi scene movement timed out')
 end
 local function run(ctx,fn)
  if activeRun then return 'end'end
  activeRun=ctx
  local ok,err=pcall(fn,ctx)
  activeRun=nil;cleanup()
  if not ok then error(err,0)end
  return 'end'
 end
 local function delivery(ctx)
  if progress:phase()~='none'then return end
  local w=world();local px=w.player.cellX
  local actor=spawn('GOLDENROD_POKECENTER_1F','CELEBI_DELIVERY','SPRITE_LINK_RECEPTIONIST',0,7)
  move(ctx,'GOLDENROD_POKECENTER_1F',actor,'up',1)
  move(ctx,'GOLDENROD_POKECENTER_1F',actor,'right',px)
  assert(mod.world:npc('GOLDENROD_POKECENTER_1F',actor)):face('down')
  w.player:scriptFace('up')
  text(ctx,'delivery')
  if not progress:deliver(giveBall)then text(ctx,'full');return end
  text(ctx,'received');text(ctx,'deliveryBye')
  move(ctx,'GOLDENROD_POKECENTER_1F',actor,'left',px)
  move(ctx,'GOLDENROD_POKECENTER_1F',actor,'down',1)
 end
 local function kurt(ctx)
  if progress:phase()=='none'and hasBall()then progress:deliver(function()return true end)end
  local phase=progress:phase()
  if phase=='delivered'then
   text(ctx,'handOver')
   progress:handOver(world():weekday(),date(),takeBall)
  elseif phase=='inspecting'then
   if progress:ready(world():weekday(),date())then
    text(ctx,'shook');progress:leaveWorkshop(world():weekday(),date())
   else text(ctx,'inspecting')end
  elseif phase=='street'or phase=='restless'or phase=='encounter'then text(ctx,'goForest')end
 end
 local function ensureStreet()
  if progress:phase()~='street'then return end
  local w=mod.world:overworld()
  if not w or w.map.id~='AZALEA_TOWN'then return end
  if streetActor and mod.world:npc('AZALEA_TOWN',streetActor)then return end
  -- Do not duplicate Crystal's original outside Kurt when already visible.
  for _,npc in ipairs(w.npcs)do
   if npc.def.sprite=='SPRITE_KURT_OUTSIDE'then streetActor=npc.id;return end
  end
  streetActor=assert(mod.world:spawnNpc('AZALEA_TOWN',{name='CELEBI_KURT_OUTSIDE',
   sprite='SPRITE_KURT',x=6,y=5,movement=8,hours={-1,-1},radius={x=0,y=0}}))
 end
 local function street(ctx)
  if progress:phase()~='street'then return end
  text(ctx,'restless')
  if not progress:returnBall(giveBall)then text(ctx,'full');return end
  text(ctx,'received');text(ctx,'goForest')
  if streetActor then remove(streetActor);streetActor=nil end
 end
 local function shrine(ctx)
  local w=world();local phase=progress:phase()
  if phase=='caught'then text(ctx,'idle');return end
  local healthy=false
  for _,mon in ipairs(game.save.party or{})do if not mon.egg and(mon.hp or 0)>0 then healthy=true;break end end
  if not healthy then text(ctx,'noParty');return end
  text(ctx,phase=='encounter'and'retry'or'shrine')
  local yes=coroutine.yield({kind='yesorno'})
  if not yes then return end
  if phase=='restless'then
   if not progress:placeBall(takeBall)then return end
   text(ctx,'inserted')
  end
  -- VAR_BATTLETYPE is 0x03 in the native Gen 2 VM. The engine consumes it
  -- once at battle start; type 11 is Celebi's no-escape encounter.
  assert(ctx.vm.writeVarFn,'native battle variable writer missing')(0x03,11)
  encounterOpen=true
  local outcome=coroutine.yield({kind='battle',wild={species=251,level=30}})
  encounterBattle=nil;encounterOpen=nil
  if outcome and progress:phase()=='caught'then text(ctx,'congratulations')end
 end
 local function start(verb)
  local w=mod.world:overworld()
  if not w or w:busy()or activeRun then return false end
  return w.vm:start({{op='modcommand',verb='CELEBI_MOD:'..verb,args={}},{op='end'}})
 end
 mod.commands:register('CELEBI_MOD:delivery',function(ctx)return run(ctx,delivery)end)
 mod.commands:register('CELEBI_MOD:street',function(ctx)return run(ctx,street)end)
 mod.events:on('game.ready',function(ev)game=ev.game end)
 local function resetSession()
  activeRun=nil;cleanup();deliveryTried=nil
  if streetActor then remove(streetActor);streetActor=nil end
 end
 -- CONTINUE/NEW GAME can abandon a VM without completing its coroutine.
 -- Retire process-local actors and guards; mod.save itself follows the slot.
 mod.events:on('save.loading',resetSession)
 mod.events:on('save.created',resetSession)
 mod.events:on('map.entered',function(ev)
  if ev.mapId=='GOLDENROD_POKECENTER_1F'then deliveryTried=false end
  if ev.mapId=='AZALEA_TOWN'then ensureStreet()end
 end)
 mod.events:on('map.exited',function(ev)
  if ev.mapId=='AZALEA_TOWN'and streetActor then remove(streetActor);streetActor=nil end
 end)
 mod.events:on('world.stepped',function(ev)
  if ev.mapId=='AZALEA_TOWN'and ev.x==9 and ev.y==6 and progress:phase()=='street'then
   ensureStreet();start('street')
  end
 end)
 mod.events:on('world.interacted',function(ev)
  if ev.mapId=='AZALEA_TOWN'and ev.target and ev.target.def
    and ev.target.def.name=='CELEBI_KURT_OUTSIDE'then start('street')end
 end)
 mod.hooks:wrap('warp.destination',function(next_,mapId,x,y,ctx)
  local w=mod.world:overworld()
  -- A carpet may be checked again in the same overworld tick after the first
  -- veto. Keep every exit attempt blocked while the delivery VM is active.
  if w and w.map.id=='GOLDENROD_POKECENTER_1F'and mapId=='GOLDENROD_CITY'and activeRun then return nil end
  if game and w and w.map.id=='GOLDENROD_POKECENTER_1F'and mapId=='GOLDENROD_CITY'
    and progress:phase()=='none'and not deliveryTried
    and(game.save.hallOfFame and game.save.hallOfFame.count or 0)>0 then
   deliveryTried=true
   if start('delivery')then return nil end
  end
  return next_(mapId,x,y,ctx)
 end)
 mod.hooks:wrap('script.command',function(next_,ctx,name,args,cmd)
  local w=mod.world:overworld()
  if not game or not w or activeRun then return next_(ctx,name,args,cmd)end
  local phase=progress:phase()
  if w.map.id=='KURTS_HOUSE'and(phase=='delivered'or phase=='inspecting'or phase=='street'
    or phase=='restless'or phase=='encounter'or(phase=='none'and hasBall()))then
   for _,obj in ipairs(w.map.def.objects)do
    if obj.sprite=='SPRITE_KURT'and obj.scriptKey==ctx.scriptKey then return run(ctx,kurt)end
   end
  elseif w.map.id=='AZALEA_TOWN'and phase=='street'then
   for _,obj in ipairs(w.map.def.objects)do
    if obj.sprite=='SPRITE_KURT_OUTSIDE'and obj.scriptKey==ctx.scriptKey then return run(ctx,street)end
   end
  elseif w.map.id=='ILEX_FOREST'and(phase=='restless'or phase=='encounter'or phase=='caught')then
   for _,ev in ipairs(w.map.def.bgEvents)do
    if ev.x==8 and ev.y==22 and ev.scriptKey==ctx.scriptKey then return run(ctx,shrine)end
   end
  end
  return next_(ctx,name,args,cmd)
 end,100)
 mod.events:on('battle.started',function(ev)
  if encounterOpen and activeRun and progress:phase()=='encounter'and ev.kind=='wild'and ev.species=='CELEBI'then
   encounterBattle=ev.battle.battle or ev.battle
  end
 end)
 mod.events:on('pokemon.caught',function(ev)
  if encounterOpen and activeRun and ev.game==game and ev.battle==encounterBattle and ev.species=='CELEBI'then
   progress:caught()
  end
 end)
 mod.events:on('script.ended',function(ev)
  if activeRun==ev.ctx then activeRun=nil;cleanup()end
 end)
 return {progress=progress}
end
