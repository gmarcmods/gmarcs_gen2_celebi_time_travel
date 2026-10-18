-- Read-only audit of the user's decoded editions; no ROM or save writes.
package.path='gen1recomp/?.lua;'..package.path
local Phone=require('src.core.gen2.Phone')
local roots={gold='mods/gen2/useful-bag/dist/art-identity/love/bag-art/gold',silver='mods/gen2/moveset-plus/dist/variants/love/moveset-silver/silver',crystal='mods/gen2/moveset-plus/dist/variants/love/moveset-crystal/crystal'}
local function walk(scripts,key,seen,rows)
 if not key or seen[key]then return end;seen[key]=true
 for _,cmd in ipairs(scripts[key]or{})do rows[#rows+1]=cmd;if cmd.script then walk(scripts,cmd.script,seen,rows)end end
end
for edition,root in pairs(roots)do
 local base=root..'/data/generated/'
 local maps,scripts,text,constants=dofile(base..'maps.lua'),dofile(base..'scripts.lua'),dofile(base..'text.lua'),dofile(base..'constants.lua')
 local function actor(map,sprite)for _,o in ipairs(maps[map].objects)do if o.sprite==sprite then return o end end;error('actor missing')end
 local lab=actor('OAKS_LAB','SPRITE_OAK');local rows={};walk(scripts,lab.scriptKey,{},rows)
 local b8,b16,rating=false,false,false
 for _,c in ipairs(rows)do b8=b8 or c.op=='ifequal'and c.value==8;b16=b16 or c.op=='ifequal'and c.value==16
  rating=rating or c.op=='special'and constants.specialOrder[c.id+1]=='ProfOaksPCBoot'
 end
 assert(b8 and b16 and rating,'lab badge/rating logic differs')
 local lance=actor('LANCES_ROOM','SPRITE_LANCE');rows={};walk(scripts,lance.scriptKey,{},rows)
 local congratulations=false
 for _,c in ipairs(rows)do local body=c.text and text[c.text];if type(body)=='string'and body:find('conquest',1,true)then congratulations=c.text end end
 assert(congratulations,'native Oak championship congratulations missing')
 local contact
 for i,n in ipairs(constants.phoneContactOrder)do if n=='PHONE_OAK'then contact=i-1 end end
 assert(contact==2 and Phone.CONTACTS[contact].callee=='UnusedPhoneScript'and Phone.CONTACTS[contact].calleeTime==0,'unused legacy Oak phone slot differs')
 print('OAK AUDIT',edition,'Lance room congratulations',congratulations,'lab',lab.scriptKey,'8/16 badge branches + Pokedex rating; legacy PHONE_OAK slot 2 is unused')
end
