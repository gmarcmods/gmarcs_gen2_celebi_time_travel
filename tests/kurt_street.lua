local install=dofile('mods/gen2/celebi_mod/lib/KurtScenes.lua')
local Path=dofile('mods/gen2/celebi_mod/lib/Path.lua')
local actor={id='kurt',cellX=6,cellY=8};local player={cellX=9,cellY=6}
local faced,playerFace,moves=nil,nil,{}
player.scriptFace=function(_,dir)playerFace=dir end
local w={map={id='AZALEA_TOWN',isWalkable=function(_,x,y)return x>=2 and x<=10 and y>=5 and y<=11 end},player=player,
 npcAt=function(_,x,y)if actor.cellX==x and actor.cellY==y then return actor end end}
local handle={npc=actor,position=function()return actor.cellX,actor.cellY end,face=function(_,dir)faced=dir end}
local mod={world={overworld=function()return w end,npc=function()return handle end}}
local scenes=install(mod,Path,{},function(ctx,map,id,dir,n)
 assert(map=='AZALEA_TOWN'and id=='kurt'and n==1)
 local d=({up={0,-1},down={0,1},left={-1,0},right={1,0}})[dir]
 actor.cellX,actor.cellY=actor.cellX+d[1],actor.cellY+d[2]
 assert(actor.cellX~=player.cellX or actor.cellY~=player.cellY,'Kurt walked through player')
 moves[#moves+1]=dir
end,function()end,function()error('movement must not remove Kurt before reaching door')end)
scenes.streetApproach({},'kurt')
assert(math.abs(actor.cellX-9)+math.abs(actor.cellY-6)==1,'Kurt speaks from too far away')
assert(#moves>0 and faced and playerFace,'Kurt did not walk up and face player')
local n=#moves;scenes.streetApproach({},'kurt');assert(#moves==n,'retry moved an already adjacent Kurt')
scenes.streetLeave({vm={waitFrames=function(_,n)assert(n==12)end}},'kurt')
assert(#moves>n and actor.cellX==2 and(actor.cellY==10 or actor.cellY==11),'Kurt vanished instead of reaching the forest gate')
print('Kurt street: approach, face-to-face gift, inventory retry and walk to forest gate PASS')
