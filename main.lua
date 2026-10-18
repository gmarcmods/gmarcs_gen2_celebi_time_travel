return function(mod)
 local Bag=require('src.inventory.Bag')
 local NPC=require('src.world.NPC')
 local function module(path)return assert(loadstring(assert(mod:read(path)),'@Celebi/'..path))()end
 local Item=module('lib/Item.lua')
 local item=Item.record(mod.content.items:get(Item.id))
 if item then mod.content.items:register(Item.id,item)end
 for id,body in pairs(module('lib/CrystalText.lua'))do mod.content.text:register('CELEBI_MOD:'..id,body)end
 for id,body in pairs(module('lib/HistoryText.lua'))do mod.content.text:register('CELEBI_MOD:'..id,body)end
 mod.content.sprites:register('SPRITE_CELEBI_GIOVANNI',{
  image=mod.assets:path('assets/giovanni.png'),frames=6,walker=true,
  spriteType='WALKING_SPRITE',palette='PAL_OW_BROWN',paletteId=3,
 })
 mod.content.sprites:register('SPRITE_CELEBI',{
  image=mod.assets:path('assets/celebi.png'),frames=6,walker=true,
  spriteType='WALKING_SPRITE',palette='PAL_OW_TREE',paletteId=6,
 })
 local pair=assert(mod.content.palettes:get('pokemon').CELEBI.normal)
 local motion=module('lib/CelebiMotion.lua')(mod,{{255,255,255},pair[1],pair[2],{0,0,0}})
 local quest=module('lib/Quest.lua')(mod,module('lib/Progress.lua'),Bag,
  module('lib/KurtScenes.lua'),module('lib/Path.lua'),motion)
 local follower=module('lib/CelebiFollower.lua')(mod,NPC.new,quest.progress,motion)
 local travel=module('lib/TimeTravel.lua')(mod,love.graphics)
 local shrineScene=module('lib/ShrineScene.lua')(mod,follower,motion,travel)
 local route22=module('lib/Route22Scene.lua')(mod,module('lib/Path.lua'),motion,travel)
 local game
 mod.events:on('game.ready',function(ev)game=ev.game end)
 -- Development milestone command. Ordinary shrine reads retain the finished
 -- Crystal flow until the full historical continuation has safe checkpoints.
 mod.commands:register('CELEBI_MOD:shrineJump',function(ctx)
  shrineScene:play(ctx,assert(game,'game is not ready'))
 end)
 mod.commands:register('CELEBI_MOD:historyOpening',function(ctx)
  shrineScene:play(ctx,assert(game,'game is not ready'),route22)
 end)
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
 mod.exports={room=Room,world=mod.world,quest=quest,follower=follower,travel=travel,shrineScene=shrineScene}
end
