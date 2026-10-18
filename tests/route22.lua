-- Exercise the historical blocking against all three real decoded maps.
package.path='gen1recomp/?.lua;'..package.path
local install=assert(loadfile('mods/gen2/celebi_mod/lib/Route22Scene.lua'))()
local Path=dofile('mods/gen2/celebi_mod/lib/Path.lua')
local Map=require('src.world.gen2.Map')
local Room=dofile('mods/gen2/celebi_mod/lib/Room.lua')
local roots={gold='mods/gen2/useful-bag/dist/art-identity/love/bag-art/gold',
 silver='mods/gen2/moveset-plus/dist/variants/love/moveset-silver/silver',
 crystal='mods/gen2/moveset-plus/dist/variants/love/moveset-crystal/crystal'}
for edition,root in pairs(roots)do
 local maps=dofile(root..'/data/generated/maps.lua');local sets=dofile(root..'/data/generated/tilesets.lua')
 local actors,events,texts,jumps,exits={},{},{},0,{}
 local p={cellX=31,cellY=8,px=496,py=128,scriptFace=function(self,d)self.facing=d end}
 local w={map=Map.new(maps.ROUTE_22,sets[maps.ROUTE_22.tileset]),player=p}
 function w:npcAt(x,y)for _,a in pairs(actors)do if a.cellX==x and a.cellY==y then return a end end end
 function p:scriptStep(dir)
  assert(dir=='right'and self.cellX==31 and self.cellY==8,'unexpected stagger')
  assert(w.map:isWalkable(32,8)and not w:npcAt(32,8),'push went through collision')
  self.cellX,self.px=32,512;return true
 end
 local function spawn(map,name,sprite,x,y)
  assert(map==w.map.id and w.map:isWalkable(x,y),'spawned on blocked cell')
  assert(sprite=='SPRITE_CELEBI'or sprite=='SPRITE_RIVAL'or sprite=='SPRITE_CELEBI_GIOVANNI','unexpected companion')
  actors[name]={id=name,def={name=name,sprite=sprite},cellX=x,cellY=y,px=x*16,py=y*16,passable=sprite=='SPRITE_CELEBI'}
  return name
 end
 local function remove(id)
  local a=assert(actors[id]);exits[id]={a.cellX,a.cellY};actors[id]=nil
 end
 local api={overworld=function()return w end,npc=function(_,map,id)
  local a=assert(actors[id]);return {npc=a,face=function(_,d)a.facing=d end,
   scriptMove=function(_,dir,n,done)
    local d=Map.DELTA[dir]
    for _=1,n do
     local x,y=a.cellX+d[1],a.cellY+d[2]
     assert(w.map:isWalkable(x,y),'walked into tile collision')
     assert(x~=p.cellX or y~=p.cellY,'walked through player')
     local other=w:npcAt(x,y);assert(not other or other==a or other.passable,'walked through scene actor')
     a.cellX,a.cellY,a.px,a.py=x,y,x*16,y*16
    end
    done();return true
   end}
 end}
 local scene={spawn=spawn,remove=remove,check=function()end,wait=function()end,
 clear=function()local ids={};for id in pairs(actors)do ids[#ids+1]=id end;for _,id in ipairs(ids)do remove(id)end end}
 local motion={orbit=function(_,a,x,y)assert(a.cellX==33 and a.cellY==8,'Celebi snapped into orbit');assert(x==p.px and y==p.py)end}
 local travel={jump=function(_,ctx,map,x,y,dir,onLand)
  assert(exits.CELEBI_SILVER,'second travel began before Silver departed')
  assert(map==Room.id and p.cellX==32,'historical jump or player stagger missing')
  w.map=Map.new(Room.build(maps.TOHJO_FALLS),sets[maps.TOHJO_FALLS.tileset]);p.cellX,p.cellY=x,y
  onLand()
 end}
 local ctx={vm={showText=function(_,id)texts[#texts+1]=id end,waitFrames=function()end}}
 local route=install({world=api},Path,motion,travel)
 scene.celebi=spawn('ROUTE_22','CELEBI_TRAVELER','SPRITE_CELEBI',30,8)
 route:arrive(ctx,scene)
 assert(actors.CELEBI_SILVER.cellY==4 and actors.CELEBI_MAN.cellY==4,'argument is not on upper path')
 route:play(ctx,scene)
 assert(w.map.id==Room.id and #texts==9,'dialogue skipped or scene did not advance three years')
 assert(texts[1]=='CELEBI_MOD:routeRival1'and texts[8]=='CELEBI_MOD:routeStare'
  and texts[9]=='CELEBI_MOD:timeHideout','wrong argument order')
 assert(exits.CELEBI_MAN[1]==18 and exits.CELEBI_MAN[2]==4,'Giovanni did not leave along upper path')
 assert(exits.CELEBI_SILVER[1]==39 and exits.CELEBI_SILVER[2]==16,'Silver did not leave toward Viridian')
 assert(actors.CELEBI_TRAVELER and not actors.CELEBI_MAN and not actors.CELEBI_SILVER,'departure actors leaked')
 print('CELEBI ROUTE 22 PASS',edition,'upper path, collision-safe departures, stagger and three-years-forward jump')
end
