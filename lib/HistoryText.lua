-- Silver/man dialogue from docs/dialogue/hgss/route_22.md. Companion lines
-- are intentionally omitted. Native paging replaces transcript box layout.
local text={
 routeRival1='You told me... you were the number one in the world!\fAre you gonna quit? What are you going to do now?',
 routeMan1="..............One must acknowledge one's defeat before he can move on...\fI will go solo...for now...\fSo that one day I will form a stronger organization!",
 routeRival2='What aspect of you was number one?\fGathering so many only to be defeated by a mere child!',
 routeMan2="Putting together the potential of many is how you produce a huge power...\fThat's what an organization is...\fThat's the strength of an organization!\fI failed... to make the best use of my subordinates potential...!\fBut you shall witness one day the revival of me and my Team Rocket!",
 routeRival3="I don't understand you! You don't make any sense!",
 routeMan3='.......................One day, you will understand.',
 routeRival4="I don't want to understand you!\fI will never become someone like you.\fA coward when you're alone and acting like a tyrant when you're in front of other cowards!\fI will become strong!\fI will become a stronger man all by myself!\fAll by myself!",
 routeStare='...What are you staring at?',
}

-- Page breaks retain speaker identity; the engine substitutes the actual save name.
for id,body in pairs(text)do
 local speaker=id:find('routeRival',1,true)or id=='routeStare'
 speaker=speaker and '{RIVAL}'or 'MAN'
 text[id]=speaker..': '..body:gsub('\f','\f'..speaker..': ')
end
text.hideoutWarning="MAN: ...I don't know why you have come here.\fMAN: This is not a place for kids like you."
text.hideoutMemory="MAN: You have a certain look... The same eyes as the kid who stood before me three years ago...\fMAN: I'm on my way to GOLDENROD CITY to answer my team's call.\fMAN: Are you going to get in my way?"
text.radioCall="RADIO: ...This is the RADIO TOWER. We declare TEAM ROCKET's revival!\fRADIO: ...GIOVANNI? Can you hear us? We have finally made it!"
text.hideoutChallenge="GIOVANNI: My old associates need me...\fGIOVANNI: We will not repeat the failure of three years ago!\fGIOVANNI: TEAM ROCKET will be born again, and I will rule the world!"
text.hideoutDefeat="GIOVANNI: What in the world are you?\fGIOVANNI: Have the past three years been a waste...?\fGIOVANNI: How can a kid like you destroy my team again?\fGIOVANNI: The precious dream of TEAM ROCKET has become little more than an illusion..."
text.radioAfter="RADIO: ...Hey! Where has GIOVANNI gone?\fRADIO: I wonder if he is listening to our broadcast..."
text.radioBefore='There is a radio that no longer works...'
text.radioComplete='You cannot turn on the radio.\nGiovanni must have left it here...'
return text
