Item = require(_G.Everest.Objects.Item)
WoodenFloorTile = require(_G.Everest.Objects.Tiles.WoodenFloor)

WoodenFloor = {}
WoodenFloor.__index = WoodenFloor
setmetatable(WoodenFloor, Item)

Item.Items[3] = WoodenFloor
Item.Items.WoodenFloor = WoodenFloor

function WoodenFloor.new(inventory)
	local new = Item.new("WoodenFloor", inventory)
	setmetatable(new, WoodenFloor)
	
	new:SetEntityId("WoodenFloorItemEntity")
	new:SetRenderImageId(170302918)
	
	return new
end

function WoodenFloor:OptionChosen(option)
	if option == "Place" then
		self:StartPlacingTile(WoodenFloorTile.new(Vector2.new(math.huge,math.huge)), true, false)
	end
end

function WoodenFloor:GetOptions()
	return {"Place"}
end

function WoodenFloor:GetInfo()
	return "Comfy on the toes."
end

return WoodenFloor