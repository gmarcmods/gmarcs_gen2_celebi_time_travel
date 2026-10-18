-- Spanish adaptation of the solo GSC quest; HGSS reference transcripts stay intact.
local text={
 ballDescription='La BALL<NEXT>misteriosa.',
 timeRoute22='TRES AÑOS ANTES...\fKANTO - RUTA 22.',
 timeHideout='TRES AÑOS DESPUÉS...\fCATARATAS TOHJO.',
 timePresent='EL PRESENTE...\fENCINAR.',
 idle='SANTUARIO DEL ENCINAR...\fDedicado al protector del bosque...',
 delivery='{PLAYER}, ¿verdad?\f¡Enhorabuena!\f¡Tenemos una GS BALL enviada especialmente para ti!\f¡Acéptala, por favor!',
 deliveryBye='¡Vuelve cuando quieras!',received='¡{PLAYER} recibió la GS BALL!',
 full='No hay sitio en la MOCHILA.',
 handOver='¿Qué es eso?\fNunca había visto nada igual.\fSe parece a una POKé BALL, pero parece ser otra cosa.\fDéjame examinarla.',
 inspecting='La estoy examinando.\f¡Ajá! Ya veo...',
 shook='¡{PLAYER}!\fEsta BALL empezó a temblar mientras la examinaba.\f¡Aquí pasa algo!',
 restless='¡El ENCINAR está inquieto!\f¿Qué estará pasando?\f¡{PLAYER}, aquí tienes tu GS BALL!',
 goForest='¿Podrías averiguar por qué está tan inquieto el ENCINAR?',
 shrine='SANTUARIO DEL ENCINAR...\fDedicado al protector del bosque...\f¿Eh? ¿Qué es esto?\fHay un hueco. Parece que la GS BALL encajaría.\f¿Quieres colocar aquí la GS BALL?',
 inserted='{PLAYER} colocó la GS BALL.',
 retry='Hay una presencia misteriosa junto al SANTUARIO...\f¿Quieres acercarte?',
 partyFull='Deja un hueco libre en tu equipo antes de colocar la GS BALL.',
 noParty='Trae un POKéMON que pueda combatir al SANTUARIO.',
 congratulations='¡Uf, ha sido increíble!\f¡{PLAYER}, has estado genial! ¡Gracias!\fLas leyendas del SANTUARIO eran ciertas.\fLo que acabo de ver me ha inspirado.\f¡Me anima a hacer mejores BALLS!\f¡Me voy!',
 routeRival1='¡Me dijiste que eras el número uno del mundo!\f¿Vas a rendirte? ¿Qué vas a hacer ahora?',
 routeMan1='...Hay que aceptar la derrota para seguir adelante...\fPor ahora seguiré solo...\f¡Algún día formaré una organización más fuerte!',
 routeRival2='¿En qué eras el número uno?\f¡Reuniste a tantos para que os derrotara un simple niño!',
 routeMan2='Uniendo el potencial de muchos se consigue un gran poder...\fEso es una organización... ¡Ésa es su fuerza!\fNo supe aprovechar el potencial de mis subordinados...\f¡Pero algún día verás mi regreso y el del TEAM ROCKET!',
 routeRival3='¡No te entiendo! ¡Nada de lo que dices tiene sentido!',
 routeMan3='...Algún día lo entenderás.',
 routeRival4='¡No quiero entenderte!\fNunca seré como tú.\f¡Un cobarde a solas y un tirano ante otros cobardes!\f¡Seré fuerte! ¡Me haré más fuerte yo solo!\f¡Yo solo!',
 routeStare='...¿Qué estás mirando?',
 hideoutWarning='HOMBRE: ...No sé por qué has venido.\fHOMBRE: Éste no es lugar para un niño como tú.',
 hideoutMemory='HOMBRE: Tienes la misma mirada que el niño que se enfrentó a mí hace tres años...\fHOMBRE: Voy a CIUDAD TRIGAL a responder a la llamada de mi equipo.\fHOMBRE: ¿Vas a interponerte en mi camino?',
 radioCall='RADIO: ...Aquí la TORRE RADIO. ¡Anunciamos el regreso del TEAM ROCKET!\fRADIO: ...¿GIOVANNI? ¿Nos oyes? ¡Por fin lo hemos logrado!',
 hideoutChallenge='GIOVANNI: Mis antiguos compañeros me necesitan...\fGIOVANNI: ¡No repetiremos el fracaso de hace tres años!\fGIOVANNI: ¡El TEAM ROCKET renacerá y dominaré el mundo!',
 hideoutDefeat='GIOVANNI: ¿Quién eres tú?\fGIOVANNI: ¿Han sido en vano estos tres años...?\fGIOVANNI: ¿Cómo puede un niño destruir mi equipo otra vez?\fGIOVANNI: El preciado sueño del TEAM ROCKET se ha convertido en una ilusión...',
 radioAfter='RADIO: ...¡Eh! ¿Dónde está GIOVANNI?\fRADIO: Me pregunto si estará escuchando nuestra emisión...',
 radioBefore='Hay una radio que ya no funciona...',
 radioComplete='No puedes encender la radio.\nGIOVANNI debió de dejarla aquí...',
}
for id,body in pairs(text)do
 if id:find('routeRival',1,true)or id=='routeStare'or id:find('routeMan',1,true)then
  local speaker=(id:find('routeRival',1,true)or id=='routeStare')and '{RIVAL}'or 'HOMBRE'
  text[id]=speaker..': '..body:gsub('\f','\f'..speaker..': ')
 end
end
return text
