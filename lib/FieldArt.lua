-- Giovanni graphics are local mod assets, copied from the user's Red import.
-- No imported dataset is needed to run the mod on Gold/Silver/Crystal.
local F={celebiColors={{255,255,255},{238,246,238},{115,189,16},{0,0,0}}}
function F.giovanni(mod)
 return {image=mod.assets:path('assets/giovanni.png'),frames=6,walker=true,
  spriteType='WALKING_SPRITE',palette='PAL_OW_BROWN',paletteId=3},'bundled-gen1'
end
function F.trainer(mod)
 return {name='ROCKET BOSS',pic=mod.assets:path('assets/giovanni-battle.png'),baseMoney=99,
  trainers={{name='GIOVANNI',trainerType='TRAINERTYPE_NORMAL',party={
   {species='NIDOKING',level=42},{species='MURKROW',level=43},
   {species='NIDOQUEEN',level=46},{species='KANGASKHAN',level=40},
  }}}}
end
return F
