-- An incoming-only invitation, separate from the cartridge's single special-
-- call slot. The original Oak interaction always completes before our gift.
return function(mod,quest,Text,Phone,Ring)
 local game
 local contact=assert(mod.content.phone_contacts:get('PHONE_OAK'),'unused Oak contact missing')
 assert(contact.index==2,'unexpected Oak phone slot')
 mod.content.phone_contacts:patch('PHONE_OAK',{name='OAK',callerTime=0,calleeTime=0})
 local function eligible()
  return game and quest.progress:phase()=='none'
   and(game.save.hallOfFame and game.save.hallOfFame.count or 0)>0
 end
 local function available(w)
  return w and not w:busy()and not w.queuedScript and not w.vm.deferred
   and not(w.player and w.player.moving)
 end
 local function phoneSite(w)
  local context={map=w and w.map.def}
  return w and Phone.isOutside(context)and Phone.mapHasService(context)
 end
 mod.commands:register('CELEBI_MOD:oakReady',function()
  -- A warp/coord scene can queue a native call after our landing listener
  -- ran. Recheck on actual VM entry, before any ring or caller box appears.
  if not eligible()or mod.save:get('oakCallHeard',false)
   or Phone.hasSpecialCall(game.save)or not phoneSite(mod.world:overworld())then return 'end'end
 end)
 mod.commands:register('CELEBI_MOD:oakCall',function(ctx)
  if not eligible()then return end
  Text.show(ctx,'oakCall')
  -- Set only after the entire conversation, not when ringing starts. An
  -- abandoned ring retries; regardless, the lab is already eligible.
  mod.save:set('oakCallHeard',true)
 end)
 mod.commands:register('CELEBI_MOD:oakGift',function(ctx)
  local w=mod.world:overworld()
  if not eligible()or not w or w.map.id~='OAKS_LAB'then return end
  Text.show(ctx,'oakGift')
  if not quest:deliver()then Text.show(ctx,'oakFull');return end
  mod.save:set('oakCallHeard',true)
  Text.show(ctx,'received');Text.show(ctx,'oakThanks')
 end)
 mod.events:on('game.ready',function(ev)game=ev.game end)
 -- No process-local progression guards: loading another save cannot inherit
 -- an invitation or suppress its call. All durable state is slot-local.
 mod.events:on('world.stepped',function()
  if not eligible()or mod.save:get('oakCallHeard',false)then return end
  local w=mod.world:overworld()
  if not available(w)or Phone.hasSpecialCall(game.save)then return end
  if not phoneSite(w)then return end
  -- Use the native ring, caller box and hang-up. Do not register a number,
  -- clear a native special call, or replace an already queued field script.
  local rows=Ring.script({contact=contact.index,scriptKey={
   {op='modcommand',verb='CELEBI_MOD:oakCall',args={}},{op='end'},
  }},'OAK')
  table.insert(rows,1,{op='modcommand',verb='CELEBI_MOD:oakReady',args={}})
  w.queuedScript=rows
 end)
 mod.events:on('script.ended',function(ev)
  local ctx=ev.ctx
  if not eligible()or not ev.completed or not ctx or ctx.kind~='script'then return end
  local w=mod.world:overworld()
  if not available(w)or w.map.id~='OAKS_LAB'then return end
  for _,actor in ipairs(w.map.def.objects or{})do
   if actor.sprite=='SPRITE_OAK'and actor.scriptKey==ctx.scriptKey then
    w.queuedScript={{op='modcommand',verb='CELEBI_MOD:oakGift',args={}},{op='end'}}
    return
   end
  end
 end)
end
