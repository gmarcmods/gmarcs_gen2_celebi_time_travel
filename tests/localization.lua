package.path='gen1recomp/?.lua;'..package.path
local make=dofile('mods/gen2/celebi_mod/lib/Text.lua')
local entries,events={},{}
local mod={content={text={register=function(_,id,body)entries[id]=body end}},events={on=function(_,id,fn)events[id]=fn end}}
local function load_(path)return dofile('mods/gen2/celebi_mod/'..path)end
local T=make(mod,load_)
local game={mods={exports={}},save={generation=2,player={name='GOLD'},rival={name='RUBEN'}}}
events['game.ready']({game=game})
assert(T.key('routeRival1')=='CELEBI_MOD:routeRival1')
local Box=require('src.render.TextBox')
assert(Box.substitute(game,entries[T.key('routeRival1')]):find('RUBEN:',1,true),'lost chosen rival name')
game.mods.exports.GEN2_ES={edition='gold'}
assert(T.key('routeRival1')=='CELEBI_MOD:es:routeRival1')
for id in pairs(load_('lib/CrystalText.lua'))do assert(T.key(id)=='CELEBI_MOD:es:'..id,'missing Spanish '..id)end
for id in pairs(load_('lib/HistoryText.lua'))do assert(T.key(id)=='CELEBI_MOD:es:'..id,'missing Spanish '..id)end
assert(T.key('unknown')=='CELEBI_MOD:unknown','missing translation must fall back to English key')
for page in (T.render('routeRival1')..'\f'):gmatch('(.-)\f')do
 assert(page:find('RUBEN:',1,true)==1,'speaker scrolled out of page')
 assert(#Box.paginate(page)[1]<=2,'speech page exceeds native box')
end
local previous={original='untouched'};local ctx={vm={text=previous,showText=function(self,id)assert(self.text[id]==T.render('routeRival1'));error('cancelled')end}}
assert(not pcall(T.show,ctx,'routeRival1')and ctx.vm.text==previous,'cancelled speech leaked VM overlay')
assert(T.body('radioBefore'):find('radio',1,true))
ctx.vm.showText=function(self,id)events['save.loading']();assert(self.text==previous)end
T.show(ctx,'routeRival1');assert(ctx.vm.text==previous,'load leaked dialogue overlay')
local partial=load_('lib/SpanishText.lua');partial.timePresent=nil;partial.timeHideout=''
local fallback=make(mod,function(path)if path=='lib/SpanishText.lua'then return partial end;return load_(path)end)
events['game.ready']({game=game})
assert(fallback.key('timePresent')=='CELEBI_MOD:timePresent'and fallback.body('timePresent')==load_('lib/CrystalText.lua').timePresent,'missing Spanish entry lost English body')
assert(fallback.key('timeHideout')=='CELEBI_MOD:timeHideout','empty Spanish entry did not fall back')
game.mods.exports.GEN2_ES=nil
assert(T.body('radioBefore')=='There is a radio that no longer works...')
print('CELEBI LOCALIZATION PASS: full catalogs, selected rival name, Spanish opt-in, English fallback')
