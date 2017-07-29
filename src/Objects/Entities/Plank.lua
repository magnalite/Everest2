ItemEntity  = require(_G.Everest.Objects.ItemEntity)
PlankItem = require(_G.Everest.Objects.Items.Plank)

Plank = {}
Plank.__index = Plank
setmetatable(Plank, ItemEntity)

function Plank.new(position)
	local new = ItemEntity.new(position)
	setmetatable(new, Plank)	
	
	new:SetImage(168909593, 168909628, Vector2.new(), Vector2.new())
	new:SetType("Plank")	
	
	return new
end

function Plank:CreateItem(inventory)
	return PlankItem.new(inventory)
end


return Plank