return function(mod)
 local Bag=require('src.inventory.Bag')
 local function module(path)return assert(loadstring(assert(mod:read(path)),'@Celebi/'..path))()end
 local Item=module('lib/Item.lua')
 local item=Item.record(mod.content.items:get(Item.id))
 if item then mod.content.items:register(Item.id,item)end
 for id,body in pairs(module('lib/CrystalText.lua'))do mod.content.text:register('CELEBI_MOD:'..id,body)end
 local quest=module('lib/Quest.lua')(mod,module('lib/Progress.lua'),Bag)
 local Room=assert(loadstring(assert(mod:read('lib/Room.lua')),'@Celebi/Room'))()
 assert(loadstring(assert(mod:read('lib/Actions.lua')),'@Celebi/Actions'))()(mod)
 local cave=assert(mod.content.maps:get('TOHJO_FALLS'),'native Tohjo Falls missing')
 local room,patch=Room.build(cave)
 mod.content.sprites:register('SPRITE_CELEBI_RADIO',{
  image=mod.assets:path('assets/broken-radio.png'),frames=1,walker=false,
  spriteType='STILL_SPRITE',palette='PAL_OW_ROCK',paletteId=7,
 })
 mod.content.maps:register(Room.id,room)
 mod.content.maps:patch('TOHJO_FALLS',patch)
 mod.events:on('world.interacted',function(ev)
  local target=ev.target
  if ev.mapId~=Room.id or not target or not target.def
    or target.def.name~=Room.radioName then return end
  local complete=mod.save:get('eventComplete',false)
  local text=Room.radioText(complete)
  -- The normal text surface keeps native paging, input locking and palette.
  assert(mod.world:queueScript({{'text',text}}))
 end)
 mod.exports={room=Room,world=mod.world,quest=quest}
end
