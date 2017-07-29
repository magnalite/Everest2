Item = require(_G.Everest.Objects.Item)

Plank = {}
Plank.__index = Plank
setmetatable(Plank, Item)

Item.Items[1] = Plank
Item.Items.Plank = Plank

function Plank.new(inventory)
	local new = Item.new("Plank", inventory)
	setmetatable(new, Plank)
	
	new:SetEntityId("Plank")
	new:SetRenderImageId(168909593)
	
	return new
end

function Plank:GetInfo()
	return "Useful for construction."
end

return Plank