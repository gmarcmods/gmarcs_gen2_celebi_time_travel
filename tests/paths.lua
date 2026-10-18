package.path='gen1recomp/?.lua;'..package.path
local Path=assert(loadfile('mods/gen2/celebi_mod/lib/Path.lua'))()
local Map=require('src.world.gen2.Map')
local roots={
 gold='mods/gen2/useful-bag/dist/art-identity/love/bag-art/gold',
 silver='mods/gen2/moveset-plus/dist/variants/love/moveset-silver/silver',
 crystal='mods/gen2/moveset-plus/dist/variants/love/moveset-crystal/crystal',
}
for edition,root in pairs(roots)do
 local maps=dofile(root..'/data/generated/maps.lua')
 local sets=dofile(root..'/data/generated/tilesets.lua')
 local function check(id,x,y,goals,blocked)
  local def=maps[id];local map=Map.new(def,sets[def.tileset])
  local route=assert(Path.find(map,x,y,goals,function(cx,cy)
   return blocked and cx==blocked[1]and cy==blocked[2]
  end),edition..' '..id..' has no route')
  for _,step in ipairs(route)do
   local d=Map.DELTA[step];x,y=x+d[1],y+d[2]
   assert(map:isWalkable(x,y),'scene walked through map collision')
   assert(not blocked or x~=blocked[1]or y~=blocked[2],'scene walked through player')
  end
  local hit=false;for _,goal in ipairs(goals)do if x==goal[1]and y==goal[2]then hit=true end end
  assert(hit)
  return route
 end
 for _,player in ipairs({{3,3},{2,2},{4,2},{3,7}})do
  check('KURTS_HOUSE',3,2,{{3,7},{4,7}},player)
 end
 -- Kurt has a second, workbench object in every edition; an existing
 -- Apricorn quest can make that the live object receiving our dialogue.
 for _,player in ipairs({{14,4},{13,3},{15,3}})do
  check('KURTS_HOUSE',14,3,{{3,7},{4,7}},player)
 end
 assert(Path.find(Map.new(maps.ILEX_FOREST,sets[maps.ILEX_FOREST.tileset]),8,29,{{8,24}})==nil,
  'the original watcher position is separated by solid foliage')
 check('ILEX_FOREST',1,24,{{8,24}},{8,23})
 local route22=Map.new(maps.ROUTE_22,sets[maps.ROUTE_22.tileset])
 for _,cell in ipairs({{14,11},{13,11},{14,8},{12,8}})do
  assert(route22:isWalkable(cell[1],cell[2]),'time-travel arrival is blocked: '..edition)
  assert(not route22:warpAt(cell[1],cell[2]),'time-travel arrival lands on a warp')
 end
 print('CELEBI SCENE PATHS PASS',edition)
end
local map={isWalkable=function(_,x,y)return x>=0 and x<3 and y>=0 and y<3 end}
assert(Path.find(map,0,0,{{2,2}},function(x,y)return x==1 end)==nil,'unreachable goal should fail safely')
assert(#assert(Path.find(map,0,0,{{0,0}}))==0)
