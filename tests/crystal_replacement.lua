package.path='gen1recomp/?.lua;'..package.path
local Merge=require('src.mods.Merge')
local install=dofile('mods/gen2/celebi_mod/lib/CrystalReplacement.lua')
local roots={gold='mods/gen2/useful-bag/dist/art-identity/love/bag-art/gold',silver='mods/gen2/moveset-plus/dist/variants/love/moveset-silver/silver',crystal='mods/gen2/moveset-plus/dist/variants/love/moveset-crystal/crystal'}
for edition,root in pairs(roots)do
 local maps=dofile(root..'/data/generated/maps.lua');local patches,hooks,events={},{},{}
 local mod={DELETE=Merge.DELETE,events={on=function(_,id,fn)events[id]=fn end},content={maps={get=function(_,id)return maps[id]end,patch=function(_,id,p)patches[id]=Merge.deepMerge(Merge.deepCopy(maps[id]),p,'record')end}},hooks={wrap=function(_,id,fn)hooks[id]=fn end}}
 install(mod,edition)
 if not({crystal=true})[edition]then assert(not next(patches)and not next(hooks),'GS editions were patched as Crystal')
 else
  local center=assert(patches.GOLDENROD_POKECENTER_1F).coordEvents or{}
  assert(#center==#maps.GOLDENROD_POKECENTER_1F.coordEvents-2,'native Crystal delivery still armed')
  local town=assert(patches.AZALEA_TOWN).coordEvents
  assert(#town==#maps.AZALEA_TOWN.coordEvents-1,'original Kurt street scene still armed')
  assert(#town==2 and town[1].x==5 and town[2].x==5,'Slowpoke Well story was removed')
  local called=false;local function native()called=true end
  local ctx={mapId='KURTS_HOUSE',vm={scriptVar=1}}
  hooks['script.command'](native,ctx,'checkevent',{}, {event=190})
  assert(ctx.vm.scriptVar==0 and not called,'native GS Ball branch was not suppressed')
  hooks['script.command'](native,ctx,'checkevent',{}, {event=43})
  assert(called,'ordinary Kurt/Apricorn flags must retain native behavior')
  local d={sprite='SPRITE_KURT_OUTSIDE',x=6,y=5,eventFlag=1956}
  local npc={id='NATIVE',def=d,cellX=6,cellY=5}
  local world={map={id='AZALEA_TOWN'},npcs={npc}}
  mod.world={overworld=function()return world end,npc=function()return {placeAt=function(_,x,y)npc.cellX,npc.cellY=x,y end}end}
  events['map.entered']()
  assert(npc.cellX==-32 and d.x==6 and d.y==5 and d.eventFlag==1956,'native outside Kurt duplicated or saved masks were changed')
 end
end
print('CELEBI CRYSTAL REPLACEMENT PASS: one delivery/street/shrine flow, normal Kurt and GS editions preserved')
