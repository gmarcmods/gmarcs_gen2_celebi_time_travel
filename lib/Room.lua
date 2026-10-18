-- Authored block layout referencing each edition's native cave tileset.
local Room={id='CELEBI_TOHJO_HIDEOUT',radioName='CELEBI_BROKEN_RADIO'}
-- Native left-hand alcove, reachable by Surf from either Route 27 entrance.
-- The earlier upper ledge placement was disconnected from playable terrain.
Room.entrance={x=3,y=5,block=32,blockId=55}
function Room.radioText(complete)
 if complete then return 'You cannot turn on the radio.\nGiovanni must have left it here...'end
 return 'There is a radio that no longer works...'
end
function Room.build(cave)
 assert(cave and cave.width==15,'unexpected Tohjo Falls layout')
 local warps={};for i,w in ipairs(cave.warps)do warps[i]=w end
 warps[#warps+1]={x=Room.entrance.x,y=Room.entrance.y,destMap=Room.id,destWarp=1}
 local blocks={};for i,b in ipairs(cave.blocks)do blocks[i]=b end
 blocks[Room.entrance.block]=Room.entrance.blockId
 local room={id=Room.id,generation=2,tileset=cave.tileset,
  width=6,height=5,borderBlock=1,environment='CAVE',environmentId=4,
  music=cave.music,landmark=cave.landmark,palette=cave.palette,phoneService=false,
  blocks={
   1,24,25,25,26,1,
   1,28,2,2,30,1,
   1,28,2,2,30,1,
   1,28,2,2,30,1,
   1,32,33,31,34,1,
  },
  voxelShapes={
   assets=false,caveDetails=false,tiles={[16]={class='void',h=0,art='flat',flat=true,authored=true}},
   walkable={class='ground',h=0,art='flat',flat=true,authored=true},
   solid={class='wall',base='wall',h=24,art='top',flat=false,authored=true,topTile=22,sideTile=22},
  },
  connections={},callbacks={},sceneScripts={},coordEvents={},bgEvents={},
  warps={{x=7,y=9,destMap='TOHJO_FALLS',destWarp=#warps}},
  objects={{name=Room.radioName,index=1,sprite='SPRITE_CELEBI_RADIO',
   x=6,y=3,movement=1,palette=7,hours={-1,-1},radius={x=0,y=0},
   type=0,sight=0,runtime=true}},
 }
 return room,{blocks=blocks,warps=warps}
end
return Room
