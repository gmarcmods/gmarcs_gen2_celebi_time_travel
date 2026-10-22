local commands={}
local moved,face,finish
local actor={
 scriptMove=function(_,dir,tiles,onDone)moved={dir,tiles};finish=onDone;return true end,
 face=function(_,dir)face=dir;return true end,
}
assert(loadfile('mods/gen2/celebi_mod/lib/Actions.lua'))()({
 commands={register=function(_,id,fn)commands[id]=fn end},
 world={npc=function(_,map,id)assert(map=='ROOM'and id=='KURT');return actor end},
})
local ctx={vm={waitFrames=function(_,ticks)coroutine.yield(ticks)end}}
local function run(id,...)local args={...};return coroutine.create(function()commands[id](ctx,unpack(args))end)end
local co=run('gmarcs_gen2_celebi_time_travel:wait',12)
local ok,n=coroutine.resume(co);assert(ok and n==12)
assert(coroutine.resume(co));assert(coroutine.status(co)=='dead')
assert(not coroutine.resume(run('gmarcs_gen2_celebi_time_travel:wait',-1)))
assert(not coroutine.resume(run('gmarcs_gen2_celebi_time_travel:wait',601)))
assert(not coroutine.resume(run('gmarcs_gen2_celebi_time_travel:wait',1.5)))
co=run('gmarcs_gen2_celebi_time_travel:move','ROOM','KURT','right',2)
ok,n=coroutine.resume(co);assert(ok and n==1 and moved[1]=='right'and moved[2]==2)
assert(coroutine.status(co)=='suspended','movement must wait for real completion')
assert(coroutine.resume(co));assert(coroutine.status(co)=='suspended')
finish();assert(coroutine.resume(co));assert(coroutine.status(co)=='dead')
assert(coroutine.resume(run('gmarcs_gen2_celebi_time_travel:face','ROOM','KURT','up')));assert(face=='up')
assert(not coroutine.resume(run('gmarcs_gen2_celebi_time_travel:face','ROOM','KURT','diagonal')))
assert(not coroutine.resume(run('gmarcs_gen2_celebi_time_travel:move','ROOM','KURT','up',99)))
print('CELEBI ACTIONS PASS: real completion gates, bounded waits and validated arguments')
