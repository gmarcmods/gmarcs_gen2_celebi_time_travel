-- Reference imported Gen 1 assets in place; never copy ROM graphics to a mod.
local F={celebiColors={{255,255,255},{238,246,238},{115,189,16},{0,0,0}}}
function F.giovanni(mod)
 if mod.datasets then
  for _,version in ipairs({'red','blue','yellow'})do
   local view=mod.datasets:open(version)
   local sprite=view and view.content.sprites:get('SPRITE_GIOVANNI')
   if sprite and sprite.walker and sprite.frames==6 and sprite.image then
    local path=view.assets:path(sprite.image)
    if path then
     return {image=path,frames=6,walker=true,spriteType='WALKING_SPRITE',
      palette='PAL_OW_BROWN',paletteId=3},version
    end
   end
  end
 end
 return {image=mod.assets:path('assets/giovanni.png'),frames=6,walker=true,
  spriteType='WALKING_SPRITE',palette='PAL_OW_BROWN',paletteId=3},'authored'
end
return F
