local Motion=assert(loadfile('mods/gen2/celebi_mod/lib/CelebiMotion.lua'))()
local hooks,events={},{}
local colors={{255,255,255},{82,255,0},{25,107,230},{0,0,0}}
local motion=Motion({hooks={wrap=function(_,id,fn)hooks[id]=fn end},
 events={on=function(_,id,fn)events[id]=fn end}},colors)
local updates=0
local sprite={objColors='original',objGroup='peer',setObjPalette=function(self,c,g)self.objColors,self.objGroup=c,g end}
local setter=sprite.setObjPalette
local actor={sprite=sprite,spriteYOffset=2,update=function(self)updates=updates+1;self.spriteYOffset=0 end,
 walkPhase=function()return 0 end}
local originalUpdate,originalPhase=actor.update,actor.walkPhase
motion:attach(actor,30)
assert(actor.spriteYOffset==-30,'appearance should begin above the shrine')
sprite:setObjPalette('night-override','world')
assert(sprite.objColors==colors and sprite.objGroup=='CELEBI_MOD:field',
 'human/tree overworld palette must not recolor Celebi orange or blue')
for tick=1,160 do
 hooks['input.step'](function()end,{},1/60)
 actor:update()
 assert(actor.spriteYOffset<0,'native movement update erased Celebi hover')
end
assert(updates==160 and actor.spriteYOffset>=-5 and actor.spriteYOffset<=-3)
local before=actor:walkPhase()
for _=1,8 do hooks['input.step'](function()end,{},1/60)end
assert(actor:walkPhase()~=before,'idle wings are frozen')
motion:detach(actor)
assert(actor.update==originalUpdate and actor.walkPhase==originalPhase and actor.spriteYOffset==2,
 'detach must restore borrowed actor methods and offset')
assert(sprite.setObjPalette==setter and sprite.objColors=='original'and sprite.objGroup=='peer',
 'detach must restore borrowed sprite palette')
motion:attach(actor)
events['save.loading']({})
assert(actor.update==originalUpdate and actor.walkPhase==originalPhase,'load leaked animation wrapper')
print('CELEBI MOTION PASS: fixed ticks, float-in, hover after native updates, wing cycle and restoration')
actor.px,actor.py,actor.cellX,actor.cellY=128,368,8,23
motion:attach(actor);motion:orbit(actor,128,368)
local start=actor.px
for _=1,18 do hooks['input.step'](function()end,{},1/60);actor:update()end
assert(actor.px~=start and actor.py~=368,'orbit is static')
assert(actor.cellX==8 and actor.cellY==23,'visual orbit changed collision coordinates')
motion:detach(actor);assert(actor.px==128 and actor.py==368,'orbit cleanup failed to restore visual position')
print('CELEBI ORBIT PASS: native/voxel pixel motion, fixed ticks and position restoration')

actor.px,actor.py=112,368
motion:attach(actor);motion:orbit(actor,128,368,math.pi)
assert(math.abs(actor.px-112)<0.00001 and math.abs(actor.py-368)<0.00001,'left-side orbit snapped through the player')
motion:detach(actor);assert(actor.px==112 and actor.py==368)
print('CELEBI ORBIT PHASE PASS: left-side start preserves scene blocking')
