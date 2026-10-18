local F=assert(loadfile('mods/gen2/celebi_mod/lib/FieldArt.lua'))()
local requests={}
local RED,BLUE='red','blue'
local original={id='SPRITE_GIOVANNI',image='assets/generated/sprites/giovanni.png',frames=6,walker=true}
local imported={}
local mod={assets={path=function(_,p)return 'mod/'..p end},datasets={open=function(_,version)
 requests[#requests+1]=version;return imported[version],'not_imported'
end}}
local view={content={sprites={get=function(_,id)assert(id=='SPRITE_GIOVANNI');return original end}},
 assets={path=function(_,p)return 'red/'..p end}}
imported.red=view
local record,source=F.giovanni(mod)
assert(source==RED and record.image=='red/assets/generated/sprites/giovanni.png'and record.frames==6)
assert(record.paletteId==3 and record.id==nil and record.source==nil,'Gen 1 record metadata leaked into Gen 2 registry')
assert(original.id=='SPRITE_GIOVANNI'and original.image=='assets/generated/sprites/giovanni.png','dataset record was mutated')
imported.red=nil;imported.blue=view
record,source=F.giovanni(mod);assert(source==BLUE)
imported.blue=nil
record,source=F.giovanni(mod);assert(source=='authored'and record.image=='mod/assets/giovanni.png','Gen 2-only installation broke')
imported.red={content={sprites={get=function()return nil end}}}
record,source=F.giovanni(mod);assert(source=='authored','invalid Gen 1 view bypassed fallback')
mod.datasets=nil
record,source=F.giovanni(mod);assert(source=='authored','older facade without datasets crashed')
assert(F.celebiColors[2][1]==238 and F.celebiColors[3][1]==115,'GSC Celebi colors were not retained')
print('CELEBI FIELD ART PASS: optional imported Gen 1 Giovanni, detached registry record, Gen 2-only fallback and GSC colors')
