ReplicationHandler  = require(_G.Everest.Handlers.ReplicationHandler)
Inventory           = require(_G.Everest.Objects.Inventory)
Mob                 = require(_G.Everest.Objects.Entities.Mob)

TestNPC = {}
TestNPC.__index = TestNPC
setmetatable(TestNPC, Mob)

function TestNPC.new(position)
	local new = Mob.new(position, Vector2.new(1.7,1.7), Inventory.new(100000), "TestNPC")
	setmetatable(new, TestNPC)
	
	new:SetHealth(100)
	new:SetWalkSpeed(5)
	new:SetImage(165812855, 166310217, Vector2.new(0,0), Vector2.new(260,256))	
	new:SetType("TestNPC")
	
	return new	
end

function TestNPC.newReplication(dataTable)
	return TestNPC.new(Vector2.new(dataTable.PosX, dataTable.PosY))
end

function TestNPC.Serialize(self, dataTable)
	if not dataTable then
		dataTable = {}
		dataTable.Type = "TestNPC"
	end	
	
	return Mob.Serialize(self, dataTable)
end

function TestNPC.DeSerialize(self, dataTable)
	Mob.DeSerialize(self, dataTable)
end

function TestNPC:Step(delta)
	if self:IsMoving() then
		self:MoveStep(delta)
	end
	self:BaseStep(delta)
	
	if _G.Server then
		if math.random() > 0.99 then
			self:MoveTo(Vector2.new(math.random(-5, 5), math.random(-5, 5)))
		end	
		ReplicationHandler.Push(self:Serialize())
	end
end

function TestNPC:AnimStep(delta)
	self.AnimLength = self.AnimLength + delta
	local length = math.floor((self.AnimLength * self.WalkSpeed)%4)
	local dir = self.MovementDirection
	
	if     dir == 0 then dir = 3
	elseif dir == 1 then dir = 2
	elseif dir == 2 then dir = 0
	elseif dir == 3 then dir = 1
	end
	
	if length == 0 then
		self:SetImage(165812855, 166310217, Vector2.new(0  ,dir*256), Vector2.new(260,256))
	elseif length == 1 or length == 3 then
		self:SetImage(165812855, 166310217, Vector2.new(260,dir*256), Vector2.new(260,256))
	elseif length == 2 then
		self:SetImage(165812855, 166310217, Vector2.new(520,dir*256), Vector2.new(260,256))
	end
end

function TestNPC:StopAnim()

end

return TestNPC