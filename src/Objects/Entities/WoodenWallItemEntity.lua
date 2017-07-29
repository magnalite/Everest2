ItemEntity  = require(_G.Everest.Objects.ItemEntity)
WoodenWallItem = require(_G.Everest.Objects.Items.WoodenWall)

WoodenWall = {}
WoodenWall.__index = WoodenWall
setmetatable(WoodenWall, ItemEntity)

function WoodenWall.new(position)
	local new = ItemEntity.new(position)
	setmetatable(new, WoodenWall)	
	
	new:SetImage(170291652, 170291658, Vector2.new(), Vector2.new())
	new:SetType("WoodenWallItemEntity")	
	
	return new
end

function WoodenWall:CreateItem(inventory)
	return WoodenWallItem.new(inventory)
end


return WoodenWall