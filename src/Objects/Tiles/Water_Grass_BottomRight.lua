Tile = require(_G.Everest.Objects.Tile)

Water_Grass_BottomRight = {}
Water_Grass_BottomRight.__index = Water_Grass_BottomRight
setmetatable(Water_Grass_BottomRight, Tile)

Tile.Tiles[11] = Water_Grass_BottomRight

function Water_Grass_BottomRight.new(position)
	local new = Tile.new(position, false)
	setmetatable(new, Water_Grass_BottomRight)
	
	new:SetImage(165479911)	
	
	return new
end

return Water_Grass_BottomRight