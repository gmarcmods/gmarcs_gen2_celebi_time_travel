-- Animate only the attached actors. Both native draw and voxel pose() read
-- spriteYOffset and walkPhase; no renderer-specific overlay or global patch.
return function(mod,colors)
 local M={};local states=setmetatable({},{__mode='k'})
 local function apply(actor,s)
  local t=math.min(1,s.age/160);local ease=t*t*(3-2*t)
  actor.spriteYOffset=-(s.height+(4-s.height)*ease)+math.sin(s.age*math.pi/16)
  if s.orbit then
   local a=s.orbit.angle+(s.age-s.orbit.start)*math.pi/36
   actor.px=s.orbit.x+math.cos(a)*16
   actor.py=s.orbit.y+math.sin(a)*8
  end
 end
 function M:detach(actor)
  local s=states[actor];if not s then return end
  actor.update=s.update;actor.walkPhase=s.phase;actor.spriteYOffset=s.offset
  if s.orbit then actor.px,actor.py=s.orbit.originalX,s.orbit.originalY end
  if s.sprite then
   s.sprite.setObjPalette=s.paletteSetter
   s.sprite.objColors,s.sprite.objGroup=s.colors,s.group
  end
  states[actor]=nil
 end
 function M:attach(actor,height)
  if states[actor]then
   if not states[actor].sprite or states[actor].sprite==actor.sprite then return end
   self:detach(actor)
  end
  local s={age=0,height=height or 4,update=actor.update,phase=actor.walkPhase,offset=actor.spriteYOffset}
  states[actor]=s
  if colors and actor.sprite then
   s.sprite=actor.sprite;s.paletteSetter=actor.sprite.setObjPalette
   s.colors,s.group=actor.sprite.objColors,actor.sprite.objGroup
   actor.sprite.setObjPalette=function(sprite)
    s.paletteSetter(sprite,colors,'gmarcs_gen2_celebi_time_travel:field')
   end
   actor.sprite:setObjPalette(colors,'gmarcs_gen2_celebi_time_travel:field')
  end
  actor.update=function(self,...)
   s.update(self,...);apply(self,s)
  end
  actor.walkPhase=function()return math.floor(s.age/8)%2 end
  apply(actor,s)
 end
 function M:orbit(actor,x,y,angle)
  local s=assert(states[actor],'orbit requires an attached actor')
  assert(not s.orbit,'actor is already orbiting')
  s.orbit={x=x,y=y,angle=angle or 0,start=s.age,originalX=actor.px,originalY=actor.py}
  apply(actor,s)
 end
 local function cleanup()
  local actors={};for actor in pairs(states)do actors[#actors+1]=actor end
  for _,actor in ipairs(actors)do M:detach(actor)end
 end
 mod.events:on('save.loading',cleanup)
 mod.events:on('save.created',cleanup)
 mod.hooks:wrap('input.step',function(next_,game,dt)
  for actor,s in pairs(states)do s.age=s.age+1;apply(actor,s)end
  return next_(game,dt)
 end)
 return M
end
