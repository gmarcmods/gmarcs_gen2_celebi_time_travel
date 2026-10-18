-- Bounded breadth-first search. Each result is a native one-cell walk action.
local Path={}
local directions={{'down',0,1},{'left',-1,0},{'right',1,0},{'up',0,-1}}
local function key(x,y)return x..':'..y end
function Path.find(map,x,y,goals,blocked)
 local targets={};for _,g in ipairs(goals)do targets[key(g[1],g[2])]=true end
 local start={x=x,y=y};local queue,seen={start},{[key(x,y)]=true}
 local cursor=1
 while queue[cursor]and cursor<=8192 do
  local node=queue[cursor];cursor=cursor+1
  if targets[key(node.x,node.y)]then
   local reversed={};while node.parent do reversed[#reversed+1]=node.dir;node=node.parent end
   local route={};for i=#reversed,1,-1 do route[#route+1]=reversed[i]end
   return route
  end
  for _,d in ipairs(directions)do
   local nx,ny=node.x+d[2],node.y+d[3];local k=key(nx,ny)
   if not seen[k]and map:isWalkable(nx,ny)and not(blocked and blocked(nx,ny))then
    seen[k]=true;queue[#queue+1]={x=nx,y=ny,dir=d[1],parent=node}
   end
  end
 end
 return nil
end
return Path
