local I={id='GS_BALL'}
function I.record(existing)
 if existing then return nil end
 -- Gold/Silver's numeric 115 is an unrelated TERU-SAMA placeholder. A mod
 -- key item can live by its string id without replacing that ROM record.
 return {id=I.id,name='GS BALL',description='The mysterious BALL.',price=0,
  pocket='KEY_ITEM',pocketId=2,canToss=false,canSelect=false,tossable=false,
  fieldMenu='ITEMMENU_NOUSE',battleMenu='ITEMMENU_NOUSE',heldEffect='HELD_NONE',
  heldParameter=0,propertyRaw=192}
end
return I
