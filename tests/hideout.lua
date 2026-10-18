package.path='gen1recomp/?.lua;'..package.path
local Map=require('src.world.gen2.Map')
local root='mods/gen2/useful-bag/dist/art-identity/love/bag-art/gold/data/generated/'
local native=dofile(root..'maps.lua').TOHJO_FALLS
local room=dofile('mods/gen2/celebi_mod/lib/Room.lua').build(native)
local sets=dofile(root..'tilesets.lua')
local Path=dofile('mods/gen2/celebi_mod/lib/Path.lua')
local install=dofile('mods/gen2/celebi_mod/lib/HideoutScene.lua')
for _,outcome in ipairs({'win','lose'})do
 local actors,texts,saved={}, {},{}
 local w={map=Map.new(room,sets[room.tileset]),player={cellX=6,cellY=6,px=96,py=96}}
 function w:npcAt(x,y)for _,a in pairs(actors)do if a.cellX==x and a.cellY==y then return a end end end
 local mod={save={set=function(_,k,v)saved[k]=v end},world={overworld=function()return w end,npc=function(_,map,id)return {npc=actors[id],face=function()end,scriptMove=function(_,d,n,done)local a=actors[id];local delta=Map.DELTA[d];local x,y=a.cellX+delta[1]*n,a.cellY+delta[2]*n;assert(w.map:isWalkable(x,y));assert(x~=6 or y~=6);a.cellX,a.cellY=x,y;done();return true end}end}}
 local scene={spawn=function(map,id,sprite,x,y)actors[id]={cellX=x,cellY=y};return id end,remove=function(id)actors[id]=nil end,clear=function()actors={}end,check=function()end,wait=function()end,celebi='CEL'}
 actors.CEL={cellX=7,cellY=6,passable=true}
 local traveled=false
 local hide=install(mod,{show=function(ctx,id)ctx.vm:showText(id)end,spanish=function()return false end},{trainer=function()return {name='ROCKET BOSS',trainers={{name='GIOVANNI',trainerType='TRAINERTYPE_NORMAL',party={{species='MURKROW',level=43}}}}}end},{orbit=function()end},{jump=function(_,ctx,map,x,y,face,land)assert(map=='ILEX_FOREST');traveled=true;land()end},Path)
 local ctx={vm={showText=function(_,id)texts[#texts+1]=id end}}
 local co=coroutine.create(function()hide:arrive(ctx,scene);hide:play(ctx,scene)end)
 local ok,request=coroutine.resume(co);assert(ok,request)
 assert(request.kind=='battle'and request.trainer.classId=='CELEBI_GIOVANNI','missing real Giovanni battle')
 assert(texts[3]=='radioCall'and texts[4]=='hideoutChallenge','radio reveal/challenge missing')
 ok,request=coroutine.resume(co,outcome);assert(ok,request)
 assert(coroutine.status(co)=='dead')
 assert((saved.eventComplete==true)==(outcome=='win'),'completion was not gated on actual victory')
 assert(traveled==(outcome=='win'),'loss must keep native whiteout')
 if outcome=='win'then assert(texts[5]=='hideoutDefeat'and texts[6]=='radioAfter'and texts[7]=='timePresent')else assert(#texts==4,'victory dialogue played after a loss')end
end
print('CELEBI HIDEOUT PASS: reveal, native trainer battle, victory dialogue/return, loss safety')
