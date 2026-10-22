local install=dofile('mods/gen2/celebi_mod/lib/Oak.lua')
local events,commands,bucket={},{},{}
local records={PHONE_OAK={index=2}}
local mod={save={get=function(_,k,d)if bucket[k]==nil then return d end;return bucket[k]end,set=function(_,k,v)bucket[k]=v end},
 content={phone_contacts={get=function(_,k)return records[k]end,patch=function(_,k,v)for a,b in pairs(v)do records[k][a]=b end end}},
 events={on=function(_,id,fn)events[id]=fn end},commands={register=function(_,id,fn)commands[id]=fn end}}
local phase='none';local canGive=false;local gifts=0
local quest={progress={phase=function()return phase end},deliver=function()if canGive then phase='delivered';gifts=gifts+1;return true end;return false end}
local spoken={};local T={show=function(_,id)spoken[#spoken+1]=id end}
local Phone={hasSpecialCall=function(save)return save.pending end,isOutside=function(ctx)return ctx.map.environment=='TOWN'end,mapHasService=function(ctx)return ctx.map.phoneService~=false end}
local Ring={script=function(call)return {phoneContact=call.contact,{op='modcommand',verb='gmarcs_gen2_celebi_time_travel:oakCall'}}end}
local w={map={id='PALLET_TOWN',def={environment='TOWN',objects={}}},player={},vm={}}
function w:busy()return self.busyNow end
mod.world={overworld=function()return w end}
local game={save={hallOfFame={count=0}}};install(mod,quest,T,Phone,Ring)
events['game.ready']({game=game})
assert(records.PHONE_OAK.name=='OAK'and records.PHONE_OAK.callerTime==0)
local function step()events['world.stepped']({mapId=w.map.id})end
step();assert(not w.queuedScript,'call before league')
game.save.hallOfFame.count=1;game.save.pending=true;step();assert(not w.queuedScript,'displaced native call')
game.save.pending=false;local other={};w.queuedScript=other;step();assert(w.queuedScript==other,'overwrote queued script')
w.queuedScript=nil;w.busyNow=true;step();assert(not w.queuedScript);w.busyNow=false
w.map.def.phoneService=false;step();assert(not w.queuedScript);w.map.def.phoneService=true
step();assert(w.queuedScript.phoneContact==2,'no incoming Oak call')
game.save.pending=true
assert(commands['gmarcs_gen2_celebi_time_travel:oakReady']({})=='end','native call queued after scheduling lost priority')
game.save.pending=false
assert(commands['gmarcs_gen2_celebi_time_travel:oakReady']({})==nil,'ready call was dropped')
w.map.def.environment='CAVE'
assert(commands['gmarcs_gen2_celebi_time_travel:oakReady']({})=='end','queued ring followed a warp indoors')
w.map.def.environment='TOWN'
-- Losing an uncompleted ring on load must leave invitation/gift available.
w.queuedScript=nil;step();assert(w.queuedScript,'interrupted ring never retried')
local show=T.show;T.show=function()error('interrupted phone')end
assert(not pcall(commands['gmarcs_gen2_celebi_time_travel:oakCall'],{})and not bucket.oakCallHeard,'interrupted dialogue acknowledged invitation')
T.show=show
commands['gmarcs_gen2_celebi_time_travel:oakCall']({});assert(spoken[#spoken]=='oakCall')
w.queuedScript=nil;step();assert(not w.queuedScript,'completed invitation rang repeatedly')
w.map={id='OAKS_LAB',def={objects={{sprite='SPRITE_OAK',scriptKey='oak'}}}}
local function ended(key,complete,kind)
 events['script.ended']({ctx={scriptKey=key,mapId='13:6',kind=kind or 'script'},completed=complete})
end
ended('pc',true);assert(not w.queuedScript,'gift after another actor/PC')
ended('oak',false);assert(not w.queuedScript,'gift after aborted native dialogue')
ended('oak',true,'callback');assert(not w.queuedScript,'gift inside map callback')
w.vm.deferred='native';ended('oak',true);assert(not w.queuedScript,'gift displaced deferred native event');w.vm.deferred=nil
ended('oak',true);assert(w.queuedScript,'native Oak did not finish before gift')
commands['gmarcs_gen2_celebi_time_travel:oakGift']({});assert(phase=='none'and spoken[#spoken]=='oakFull','full pocket consumed gift')
w.queuedScript=nil;ended('oak',true);assert(w.queuedScript,'cannot retry full pocket')
canGive=true;commands['gmarcs_gen2_celebi_time_travel:oakGift']({});assert(phase=='delivered'and gifts==1)
w.queuedScript=nil;ended('oak',true);step();assert(not w.queuedScript and gifts==1,'duplicate after delivery')
-- Lab remains usable without hearing any part of the invitation.
phase='none';bucket.oakCallHeard=nil;ended('oak',true);assert(w.queuedScript,'unheard invitation stranded gift')
print('CELEBI OAK PASS: native call priority, interrupted call, native lab completion, full pocket retry, once-only gift')
