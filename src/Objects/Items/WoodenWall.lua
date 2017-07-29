Item = require(_G.Everest.Objects.Item)
WoodenWallEntity = require(_G.Everest.Objects.Entities.WoodenWall)

WoodenWall = {}
WoodenWall.__index = WoodenWall
setmetatable(WoodenWall, Item)

Item.Items[2] = WoodenWall
Item.Items.WoodenWall = WoodenWall

function WoodenWall.new(inventory)
	local new = Item.new("WoodenWall", inventory)
	setmetatable(new, WoodenWall)
	
	new:SetEntityId("WoodenWallItemEntity")
	new:SetRenderImageId(170291652)
	
	return new
end

function WoodenWall:OptionChosen(option)
	if option == "Place" then
		self:StartPlacingEntity(WoodenWallEntity.new(Vector2.new(math.huge,math.huge)), true, false)
	end
end

function WoodenWall:GetOptions()
	return {"Place"}
end

function WoodenWall:GetInfo()
	return "Stay safe!"
end

return WoodenWall