-- Run from workspace root; checks real collision data, not just our blueprint.
package.path='gen1recomp/?.lua;'..package.path
local Room=assert(loadfile('mods/gen2/celebi_mod/lib/Room.lua'))()
local Map=require('src.world.gen2.Map')
local P=require('src.world.gen2.Permissions')
local paths={
 gold='mods/gen2/useful-bag/dist/art-identity/love/bag-art/gold',
 silver='mods/gen2/moveset-plus/dist/variants/love/moveset-silver/silver',
 crystal='mods/gen2/moveset-plus/dist/variants/love/moveset-crystal/crystal',
}
for edition,path in pairs(paths)do
 local maps=dofile(path..'/data/generated/maps.lua')
 local sets=dofile(path..'/data/generated/tilesets.lua')
 local old=maps.TOHJO_FALLS
 local room,patch=Room.build(old)
 assert(#room.blocks==room.width*room.height)
 assert(#patch.warps==#old.warps+1 and #patch.blocks==#old.blocks)
 for i,b in ipairs(old.blocks)do
  if i~=Room.entrance.block then assert(patch.blocks[i]==b,'unrelated cave block changed')end
 end
 for i,w in ipairs(old.warps)do assert(patch.warps[i]==w,'native warp replaced')end
 local map=Map.new(room,sets[room.tileset])
 local entrance=Map.new(setmetatable(patch,{__index=old}),sets[old.tileset])
 assert(P.isImmediateWarp(entrance:cellCollision(Room.entrance.x,Room.entrance.y)))
 assert(entrance:isWalkable(Room.entrance.x,Room.entrance.y+1))
 for x=0,map.widthCells-1 do assert(not map:isWalkable(x,0),'room has an open north wall')end
 local Path=dofile('mods/gen2/celebi_mod/lib/Path.lua')
 local explore={isWalkable=function(_,x,y)
  return x>=0 and y>=0 and x<entrance.widthCells and y<entrance.heightCells
   and(entrance:isWalkable(x,y)or entrance:isWaterCell(x,y)or P.isWaterfall(entrance:cellCollision(x,y)))
 end}
 for _,warp in ipairs(old.warps)do
  assert(Path.find(explore,warp.x,warp.y,{{Room.entrance.x,Room.entrance.y+1}}),
   'hideout is disconnected from ordinary Tohjo exploration')
 end
 local exit=room.warps[1]
 assert(P.isImmediateWarp(map:cellCollision(exit.x,exit.y)))
 assert(exit.destMap=='TOHJO_FALLS'and exit.destWarp==#patch.warps)
 assert(patch.warps[#patch.warps].destMap==room.id)
 -- The radio has a reachable examine square from the entrance.
 local seen,queue={},{{exit.x,exit.y}};seen[exit.y*100+exit.x]=true
 local n=1
 while queue[n]do
  local at=queue[n];n=n+1
  for _,d in pairs(Map.DELTA)do
   local x,y=at[1]+d[1],at[2]+d[2];local k=y*100+x
   if not seen[k]and map:isWalkable(x,y)then seen[k]=true;queue[#queue+1]={x,y}end
  end
 end
 local radio=room.objects[1]
 assert(map:isWalkable(radio.x,radio.y))
 assert(seen[(radio.y+1)*100+radio.x],'cannot approach the radio')
 assert(Room.radioText(false)=='There is a radio that no longer works...')
 assert(Room.radioText(true)=='You cannot turn on the radio.\nGiovanni must have left it here...')
 print('CELEBI ROOM DATA PASS',edition)
end
