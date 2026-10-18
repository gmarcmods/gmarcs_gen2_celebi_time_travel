local F=assert(loadfile('mods/gen2/celebi_mod/lib/FieldArt.lua'))()
local mod={assets={path=function(_,p)return 'mod/'..p end},
 datasets={open=function()error('Giovanni must not depend on an imported game at runtime')end}}
local record,source=F.giovanni(mod)
assert(source=='bundled-gen1'and record.image=='mod/assets/giovanni.png'and record.frames==6)
assert(record.walker and record.paletteId==3)
local trainer=F.trainer(mod)
assert(trainer.pic=='mod/assets/giovanni-battle.png','battle portrait is not in mod files')
assert(trainer.name=='ROCKET BOSS'and trainer.trainers[1].name=='GIOVANNI')
local expected={{'NIDOKING',42},{'MURKROW',43},{'NIDOQUEEN',46},{'KANGASKHAN',40}}
for i,entry in ipairs(expected)do local mon=trainer.trainers[1].party[i];assert(mon.species==entry[1]and mon.level==entry[2])end
assert(F.celebiColors[2][1]==238 and F.celebiColors[3][1]==115)
print('CELEBI FIELD ART PASS: bundled overworld and battle art, no dataset access and correct trainer record')
