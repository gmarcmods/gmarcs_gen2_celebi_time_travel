-- Local catalogs: no global translation hooks and no dependency on another mod.
return function(mod,load_)
 local english={}
 for _,path in ipairs({'lib/CrystalText.lua','lib/HistoryText.lua'})do
  for id,body in pairs(load_(path))do english[id]=body end
 end
 local spanish=load_('lib/SpanishText.lua')
 for id,body in pairs(english)do mod.content.text:register('CELEBI_MOD:'..id,body)end
 for id,body in pairs(spanish)do
  assert(english[id],'Spanish key without English fallback: '..id)
  mod.content.text:register('CELEBI_MOD:es:'..id,body)
 end
 local game
 mod.events:on('game.ready',function(ev)game=ev.game end)
 local function translated(id)
  return game and game.mods and game.mods.exports.GEN2_ES and type(spanish[id])=='string'and #spanish[id]>0
 end
 local T={key=function(id)return 'CELEBI_MOD:'..(translated(id)and 'es:'or '')..id end,
 body=function(id)return translated(id)and spanish[id]or english[id]end,
 spanish=function()return translated('timeRoute22')and true or false end}
 local active=setmetatable({},{__mode='k'})
 local function cleanup()
  for vm,previous in pairs(active)do vm.text=previous;active[vm]=nil end
 end
 mod.events:on('save.loading',cleanup)
 mod.events:on('save.created',cleanup)
 mod.events:on('script.ended',function(ev)
  local vm=ev.ctx and ev.ctx.vm
  if vm and active[vm]then vm.text=active[vm];active[vm]=nil end
 end)
 local Box=require('src.render.TextBox')
 function T.render(id)
  local body=T.body(id)
  if not game or not body then return body end
  local out={}
  body=Box.substitute(game,body)
  for page in (body..'\f'):gmatch('(.-)\f')do
   local speaker,words=page:match('^([^:\n]+):%s*(.*)$')
   if not speaker then out[#out+1]=page
   else
    local prefix=speaker..': ';local line=''
    for word in words:gmatch('%S+')do
     local candidate=line==''and word or line..' '..word
     local wrapped=Box.paginate(prefix..candidate)
     if #wrapped[1]>2 and line~=''then
      out[#out+1]=prefix..line;line=word
     else line=candidate end
    end
    out[#out+1]=prefix..line
   end
  end
  return table.concat(out,'\f')
 end
 function T.show(ctx,id)
  local key=T.key(id);local previous=ctx.vm.text
  assert(not active[ctx.vm],'nested Celebi dialogue on the same VM')
  active[ctx.vm]=previous
  -- A scoped overlay keeps the speaker visible on every native two-line
  -- page without changing global text data or other mods' translations.
  ctx.vm.text=setmetatable({[key]=T.render(id)},{__index=previous})
  local ok,err=pcall(function()ctx.vm:showText(key)end)
  ctx.vm.text=previous;active[ctx.vm]=nil
  if not ok then error(err,0)end
 end
 return T
end
