package.path='gen1recomp/?.lua;'..package.path
local make=dofile('mods/gen2/celebi_mod/lib/Text.lua')
local entries,events={},{}
local mod={content={text={register=function(_,id,body)entries[id]=body end}},events={on=function(_,id,fn)events[id]=fn end}}
local function load_(path)return dofile('mods/gen2/celebi_mod/'..path)end
local T=make(mod,load_)
local english={};for k,v in pairs(entries)do english[k]=v end
local game={data={gen2Text=entries},mods={exports={}},save={generation=2,player={name='GOLD'},rival={name='RUBEN'}}}
events['game.ready']({game=game})
assert(T.key('routeRival1')=='gmarcs_gen2_celebi_time_travel:routeRival1')
local Box=require('src.render.TextBox')
assert(Box.substitute(game,entries[T.key('routeRival1')]):find('RUBEN:',1,true),'lost chosen rival name')
-- Emulate any language mod overriding the official text registry after content registration.
local spanish=dofile('mods/gen2/spanish-all/companions/celebi.lua')
for id,body in pairs(spanish)do entries['gmarcs_gen2_celebi_time_travel:'..id]=body end
for _,path in ipairs({'lib/CrystalText.lua','lib/HistoryText.lua'})do
 for id in pairs(load_(path))do
  assert(T.key(id)=='gmarcs_gen2_celebi_time_travel:'..id,'translation changed stable dialogue ID')
  assert(T.body(id)==spanish[id],'missing translated dialogue '..id)
 end
end
assert(T.key('unknown')=='gmarcs_gen2_celebi_time_travel:unknown')
for page in (T.render('routeRival1')..'\f'):gmatch('(.-)\f')do
 assert(page:find('RUBEN:',1,true)==1,'speaker scrolled out of page')
 assert(#Box.paginate(page)[1]<=2,'speech page exceeds native box')
end
local previous={original='untouched'};local ctx={vm={text=previous,showText=function(self,id)assert(self.text[id]==T.render('routeRival1'));error('cancelled')end}}
assert(not pcall(T.show,ctx,'routeRival1')and ctx.vm.text==previous,'cancelled speech leaked VM overlay')
ctx.vm.showText=function(self,id)events['save.loading']();assert(self.text==previous)end
T.show(ctx,'routeRival1');assert(ctx.vm.text==previous,'load leaked dialogue overlay')
entries[T.key('timePresent')]=nil;entries[T.key('timeHideout')]=''
assert(T.body('timePresent')==load_('lib/CrystalText.lua').timePresent,'missing translation lost English body')
assert(T.body('timeHideout')==load_('lib/CrystalText.lua').timeHideout,'empty translation lost English body')
game.data.gen2Text=english
assert(T.body('radioBefore')=='There is a radio that no longer works...')
print('CELEBI LOCALIZATION PASS: official text overrides, stable IDs, rival name, paging and English fallback')
