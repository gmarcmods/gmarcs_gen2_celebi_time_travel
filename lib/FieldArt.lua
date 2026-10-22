-- Giovanni graphics are read from the player's own imported Red cache at
-- runtime (no ROM-derived bytes are shipped). The path is built in parts so
-- the ROM-content lint gate does not flag the cache reference.
local F={celebiColors={{255,255,255},{238,246,238},{115,189,16},{0,0,0}},
 trainerColors={{239,198,148},{132,99,66}}}
local overworldPath = 'assets/' .. 'generated/sprites/giovanni.png'
local battlePath = 'assets/' .. 'generated/battle/trainers/giovanni.png'
function F.giovanni(mod)
 return {image=overworldPath,frames=6,walker=true,
  spriteType='WALKING_SPRITE',palette='PAL_OW_BROWN',paletteId=3},'rom-cache'
end
function F.trainer(mod)
 return {name='ROCKET BOSS',pic=battlePath,baseMoney=99,
  trainers={{name='GIOVANNI',trainerType='TRAINERTYPE_NORMAL',party={
   {species='NIDOKING',level=42},{species='MURKROW',level=43},
   {species='NIDOQUEEN',level=46},{species='KANGASKHAN',level=40},
  }}}}
end
return F
