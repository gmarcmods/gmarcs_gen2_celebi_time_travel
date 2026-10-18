-- Save data only. Item callbacks commit before their corresponding phase.
local P={};P.__index=P
function P.new(storage)return setmetatable({storage=storage},P)end
function P:state()return self.storage:get('quest',{version=1,phase='none'})end
function P:phase()return self:state().phase end
function P:advance(phase,extra)
 local state={};for k,v in pairs(self:state())do state[k]=v end
 state.phase=phase;for k,v in pairs(extra or{})do state[k]=v end
 self.storage:set('quest',state)
end
function P:deliver(give)
 if self:phase()~='none'or not give()then return false end
 self:advance('delivered');return true
end
function P:handOver(day,date,take)
 if self:phase()~='delivered'or not take()then return false end
 self:advance('inspecting',{inspectionDay=day,inspectionDate=date});return true
end
function P:ready(day,date)
 local s=self:state()
 return s.phase=='inspecting'and(s.inspectionDay~=day or s.inspectionDate~=date)
end
function P:leaveWorkshop(day,date)
 if not self:ready(day,date)then return false end
 self:advance('street');return true
end
function P:returnBall(give)
 if self:phase()~='street'or not give()then return false end
 self:advance('restless');return true
end
function P:placeBall(take)
 if self:phase()~='restless'or not take()then return false end
 self:advance('encounter');return true
end
function P:caught()
 if self:phase()~='encounter'then return false end
 self:advance('caught');return true
end
return P
