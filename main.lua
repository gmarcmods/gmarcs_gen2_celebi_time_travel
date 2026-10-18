return function(mod)
 local Bag=require('src.inventory.Bag')
 local NPC=require('src.world.NPC')
 local function module(path)return assert(loadstring(assert(mod:read(path)),'@Celebi/'..path))()end
 local Item=module('lib/Item.lua')
 local item=Item.record(mod.content.items:get(Item.id))
 if item then mod.content.items:register(Item.id,item)end
 local Text=module('lib/Text.lua')(mod,module)
 local FieldArt=module('lib/FieldArt.lua')
 local giovanni,giovanniSource=FieldArt.giovanni(mod)
 mod.content.sprites:register('SPRITE_CELEBI_GIOVANNI',giovanni)
 mod.content.trainers:register('CELEBI_GIOVANNI',FieldArt.trainer(mod))
 mod.content.palettes:patch('trainers',{CELEBI_GIOVANNI=FieldArt.trainerColors})
 mod.content.sprites:register('SPRITE_CELEBI',{
  image=mod.assets:path('assets/celebi.png'),frames=6,walker=true,
  spriteType='WALKING_SPRITE',palette='PAL_OW_TREE',paletteId=6,
 })
 local motion=module('lib/CelebiMotion.lua')(mod,FieldArt.celebiColors)
 local quest=module('lib/Quest.lua')(mod,module('lib/Progress.lua'),Bag,
  module('lib/KurtScenes.lua'),module('lib/Path.lua'),motion,Text)
 local follower=module('lib/CelebiFollower.lua')(mod,NPC.new,quest.progress,motion)
 local travel=module('lib/TimeTravel.lua')(mod,love.graphics)
 local shrineScene=module('lib/ShrineScene.lua')(mod,follower,motion,travel,Text)
 local hideout=module('lib/HideoutScene.lua')(mod,Text,FieldArt,motion,travel,module('lib/Path.lua'))
 local route22=module('lib/Route22Scene.lua')(mod,module('lib/Path.lua'),motion,travel,Text,hideout)
 local game
 mod.events:on('game.ready',function(ev)
  game=ev.game
  -- Only the new Gold/Silver item belongs to us. Crystal's original item
  -- retains its edition catalog and native description formatting.
  if item then game.data.items[Item.id].description=Text.body('ballDescription')end
 end)
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
  local text=Text.body(complete and 'radioComplete'or 'radioBefore')
  -- The normal text surface keeps native paging, input locking and palette.
  assert(mod.world:queueScript({{'text',text}}))
 end)
 mod.exports={text=Text,room=Room,world=mod.world,quest=quest,follower=follower,travel=travel,shrineScene=shrineScene,
  fieldArt={giovanniSource=giovanniSource}}
end
