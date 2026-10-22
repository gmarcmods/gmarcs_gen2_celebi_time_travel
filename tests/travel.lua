-- Fixed-tick transitions, masked warps, interruption cleanup and peer rendering.
local install=assert(loadfile('mods/gen2/celebi_mod/lib/TimeTravel.lua'))()
local events,hooks,commands,store={},{},{},{}
local world={map={id='ILEX_FOREST'},player={cellX=8,cellY=23,facing='up'}}
local warps,frames,draws=0,0,0
local travel
local g={push=function()end,pop=function()end,origin=function()end,setShader=function()end,
 setScissor=function()end,setBlendMode=function()end,setLineWidth=function()end,
 setColor=function()end,rectangle=function()draws=draws+1 end,line=function()draws=draws+1 end}
local mod={save={get=function(_,k,d)local v=store[k];if v==nil then return d end;return v end,
 set=function(_,k,v)store[k]=v end},world={overworld=function()return world end,
 warpTo=function(_,map,x,y,facing)
  assert(travel:sample().white==1,'map change must be completely masked')
  warps=warps+1;world.map={id=map};world.player={cellX=x,cellY=y,facing=facing};return true
 end},events={on=function(_,id,fn)events[id]=fn end},
 hooks={wrap=function(_,id,fn)hooks[id]=fn end},
 commands={register=function(_,id,fn)commands[id]=fn end}}
travel=install(mod,g)
local function tick()frames=frames+1;hooks['input.step'](function()end,{},1/60)end
local ctx={vm={waitFrames=function(_,n)for _=1,n do tick()end end}}
assert(travel:sample()==nil)
local peer=0
hooks['render.hud'](function()peer=peer+1 end,{}, {width=960,height=540})
assert(peer==1 and draws==0,'idle effect should not draw or suppress peer HUD')
commands['gmarcs_gen2_celebi_time_travel:travel'](ctx,'ROUTE_22',12,8,'left')
assert(warps==1 and frames==travel.duration and not travel:sample())
assert(world.map.id=='ROUTE_22'and not store.travelPending)
-- A warp failure must clear the overlay and keep an explicit recovery target.
mod.world.warpTo=function()return nil,'test refusal'end
local ok,why=pcall(commands['gmarcs_gen2_celebi_time_travel:travel'],ctx,'ILEX_FOREST',8,23,'up')
assert(not ok and tostring(why):find('test refusal',1,true))
assert(not travel:sample()and store.travelPending.mapId=='ILEX_FOREST')
-- Check the real animation while suspended, not just its final state.
mod.world.warpTo=function(_,map,x,y,facing)world.map={id=map};return true end
ctx.vm.waitFrames=function()coroutine.yield()end
local co=coroutine.create(function()commands['gmarcs_gen2_celebi_time_travel:travel'](ctx,'ILEX_FOREST',8,23,'up')end)
assert(coroutine.resume(co));local sample=travel:sample();assert(sample and sample.white==0)
hooks['render.hud'](function()peer=peer+1 end,{}, {width=960,height=540})
assert(draws>0 and peer==2,'active swirl not drawn over peer HUD')
events['save.loading']({});assert(not travel:sample(),'save loading leaked effect')
local ok2=coroutine.resume(co)
assert(not ok2,'abandoned coroutine continued after cancellation')
assert(store.travelPending,'loading must not erase saved recovery checkpoint')
-- Ordinary script completion must not cancel an unrelated VM context.
co=coroutine.create(function()commands['gmarcs_gen2_celebi_time_travel:travel'](ctx,'ILEX_FOREST',8,23,'up')end)
assert(coroutine.resume(co));events['script.ended']({ctx={}});assert(travel:sample())
events['script.ended']({ctx=ctx});assert(not travel:sample())
for _,bad in ipairs({{'MISSING',1,2,'up'},{'ROUTE_22',1.5,2,'up'},{'ILEX_FOREST',8,23,'bad'}})do
 assert(not pcall(commands['gmarcs_gen2_celebi_time_travel:travel'],ctx,unpack(bad)))
end
print('CELEBI TRAVEL PASS: masked warp, fixed timing, idle cost, recovery checkpoint and cancellation')
