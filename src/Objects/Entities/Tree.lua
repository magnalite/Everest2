NotificationHandler = require(_G.Everest.Handlers.NotificationHandler)
SoundHandler        = require(_G.Everest.Handlers.SoundHandler)
ToolTipHandler      = require(_G.Everest.Handlers.ToolTipHandler)
Entity              = require(_G.Everest.Objects.Entity)
Log                 = require(_G.Everest.Objects.Entities.Log)
TreeStump           = require(_G.Everest.Objects.Entities.TreeStump)

Tree = {}
Tree.__index = Tree
setmetatable(Tree, Entity)

function Tree.new(position)
	local new = Entity.new(position, Vector2.new(1.7, 2))
	setmetatable(new, Tree)
	
	new:SetImage(166334926, 166334950, Vector2.new(), Vector2.new())
	new:SetType("Tree")
	
	local tile = _G.Map:GetTile(Vector2.new(math.floor(position.x), math.floor(position.y)))
	tile:SetWalkable(false)
	tile:SetSolid(true)
	tile.HasEntity = true
	
	return new
end

function Tree.Serialize(self, dataTable)
	if not dataTable then
		dataTable = {}
		dataTable.Type = "Tree"
	end	

	return Entity.Serialize(self, dataTable)
end

function Tree.newReplication(data)
	return Tree.new(Vector2.new(data.PosX, data.PosY))
end

function Tree:LeftClicked()
	self:OptionChosen("Chop")
end

function Tree:RightClicked()
	ToolTipHandler:ProvideOptions({"Chop", "Harvest fruit"}, self:GetPosition(), self)
end

function Tree:OptionChosen(option)
	if option == "Chop" then
		local dist = (_G.localPlayer:GetPosition() - self:GetPosition()).magnitude
		if dist > 1.5 then
			NotificationHandler.NewNotification("You must be closer to chop a tree down")
		else
			self:Chop()
		end
	end
end

function Tree:Chop()
	SoundHandler.PlayGlobalSound(159798328)
	_G.Map:AddEntity(TreeStump.new(self.Position))
	
	for i = 1, math.random(2,10) do
		local placed
		local timesPlaced = 0
		while not placed and timesPlaced < 20 do 
			timesPlaced = timesPlaced + 1
			local pos = Vector2.new(math.random()*2-1, math.random()*2-1)
			local posx, posy = self.Position.x, self.Position.y
			if _G.Map:GetTile(Vector2.new(math.floor(posx + pos.X), math.floor(posy + pos.Y))):IsWalkable() then
				local droppedLog = Log.new(Vector2.new(math.floor(posx + pos.X + 0.5), math.floor(posy + pos.Y + 0.5)))		
				_G.Map:AddEntity(droppedLog)
				droppedLog:Impulse(pos, pos.magnitude)
				placed = true
			end	
		end
	end	
	
	self:Destroy()
end

return Tree