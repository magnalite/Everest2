ToolTipHandler     = require(_G.Everest.Handlers.ToolTipHandler)
Entity             = require(_G.Everest.Objects.Entity)

TreeStump = {}
TreeStump.__index = TreeStump
setmetatable(TreeStump, Entity)


function TreeStump.new(position)
	local new = Entity.new(position, Vector2.new(0.5, 0.5))
	setmetatable(new, TreeStump)
	
	new:SetImage(166388660, 166388682, Vector2.new(), Vector2.new())
	new:SetType("TreeStump")	
	local tile = _G.Map:GetTile(Vector2.new(math.floor(position.x), math.floor(position.y)))
	tile:SetWalkable(false)
	tile:SetSolid(false)
	
	
	return new
end

function TreeStump.newReplication(data)
	return TreeStump.new(Vector2.new(data.PosX, data.PosY))
end

function TreeStump:LeftClicked()
	self:OptionChosen("Remove")
end

function TreeStump:RightClicked()
	ToolTipHandler:ProvideOptions({"Remove"}, self:GetPosition(), self)
end

function TreeStump:OptionChosen(option)
	if option == "Remove" then
		_G.Map:GetTile(self:GetPosition()):SetWalkable(true)
		_G.Map:GetTile(self:GetPosition()).HasEntity = nil
		self:Destroy()
	end
end

return TreeStump
