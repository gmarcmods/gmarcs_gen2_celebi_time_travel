-- An incoming-only invitation, separate from the cartridge's single special-
-- call slot. The original Oak interaction always completes before our gift.
return function(mod,quest,Text,Phone,Ring)
 local game
 -- Contact 2 is named PHONE_OAK in the decomp, but every cartridge uses it for
 -- the bike shop: the row is the shop's caller script and StepEvents queues
 -- SPECIALCALL_BIKESHOP on it. It is a shared row, not a free one, so the
 -- invitation borrows the name only for the length of its own call.
 local contact=mod.content.phone_contacts:get('PHONE_OAK')
 if not contact or contact.index~=2 then return end
 -- The caller-ID box prints Phone.CONTACTS[contact].name, not the name handed
 -- to Ring.script: that one only feeds the ring page. So the live row is what
 -- has to wear ours, and it is put back the moment the call is over.
 --
 -- The row must be looked up when the call starts, never held from install
 -- time: Phone.useRegistry (src/core/Game2.lua:1226) REPLACES Phone.CONTACTS
 -- with a fresh deep copy after the mods load, so a table captured here at load
 -- would be an orphan and the caller box would keep printing the shop's name.
 local borrowed
 local function liveRow()
  local book=Phone.CONTACTS
  return book and book[contact.index] or nil
 end
 local function borrowName()
  local row=liveRow()
  if row and borrowed==nil then
   borrowed=row.name
   row.name='OAK'
  end
 end
 local function returnName()
  local row=liveRow()
  if row and borrowed~=nil then
   row.name=borrowed
   borrowed=nil
  end
 end
 -- Only ever write our own contact's name back: a language mod may have
 -- replaced it (the Spanish cart calls it TIENDA BICIS), and that value is
 -- what must survive, not an English default.
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
 mod.commands:register('gmarcs_gen2_celebi_time_travel:oakReady',function()
  -- A warp/coord scene can queue a native call after our landing listener
  -- ran. Recheck on actual VM entry, before any ring or caller box appears.
  if not eligible()or mod.save:get('oakCallHeard',false)
   or Phone.hasSpecialCall(game.save)or not phoneSite(mod.world:overworld())then return 'end'end
 end)
 mod.commands:register('gmarcs_gen2_celebi_time_travel:oakCall',function(ctx)
  if not eligible()then return end
  Text.show(ctx,'oakCall')
  -- Set only after the entire conversation, not when ringing starts. An
  -- abandoned ring retries; regardless, the lab is already eligible.
  mod.save:set('oakCallHeard',true)
 end)
 mod.commands:register('gmarcs_gen2_celebi_time_travel:oakGift',function(ctx)
  local w=mod.world:overworld()
  if not eligible()or not w or w.map.id~='OAKS_LAB'then return end
  Text.show(ctx,'oakGift')
  if not quest:deliver()then Text.show(ctx,'oakFull');return end
  mod.save:set('oakCallHeard',true)
  Text.show(ctx,'received');Text.show(ctx,'oakThanks')
 end)
 mod.events:on('game.ready',function(ev)game=ev.game;returnName()end)
 -- No process-local progression guards: loading another save cannot inherit
 -- an invitation or suppress its call. All durable state is slot-local.
 mod.events:on('world.stepped',function()
  if not eligible()or mod.save:get('oakCallHeard',false)then
   -- A call lost to a warp or a reload must not leave the shared row renamed.
   local w=mod.world:overworld()
   if not(w and(w.queuedScript or(w.vm and w.vm:running())or w:busy()))then returnName()end
   return
  end
  local w=mod.world:overworld()
  if not available(w)or Phone.hasSpecialCall(game.save)then return end
  if not phoneSite(w)then return end
  -- Use the native ring, caller box and hang-up. Do not register a number,
  -- clear a native special call, or replace an already queued field script.
  local rows=Ring.script({contact=contact.index,scriptKey={
   {op='modcommand',verb='gmarcs_gen2_celebi_time_travel:oakCall',args={}},{op='end'},
  }},'OAK')
  table.insert(rows,1,{op='modcommand',verb='gmarcs_gen2_celebi_time_travel:oakReady',args={}})
  borrowName()
  w.queuedScript=rows
 end)
 mod.events:on('script.ended',function(ev)
  -- Any completed script may be the tail of our call (or of a warp that cut
  -- it short), so the shared row goes back before anything else is decided.
  local ctx=ev.ctx
  if ctx and (ctx.vm and not ctx.vm:running())then returnName()end
  if not eligible()or not ev.completed or not ctx or ctx.kind~='script'then return end
  local w=mod.world:overworld()
  if not available(w)or w.map.id~='OAKS_LAB'then return end
  for _,actor in ipairs(w.map.def.objects or{})do
   if actor.sprite=='SPRITE_OAK'and actor.scriptKey==ctx.scriptKey then
    w.queuedScript={{op='modcommand',verb='gmarcs_gen2_celebi_time_travel:oakGift',args={}},{op='end'}}
    return
   end
  end
 end)
end
