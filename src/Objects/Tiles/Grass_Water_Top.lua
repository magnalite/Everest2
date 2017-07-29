Tile = require(_G.Everest.Objects.Tile)

Grass_Water_Top = {}
Grass_Water_Top.__index = Grass_Water_Top
setmetatable(Grass_Water_Top, Tile)

Tile.Tiles[5] = Grass_Water_Top

function Grass_Water_Top.new(position)
	local new = Tile.new(position, false)
	setmetatable(new, Grass_Water_Top)
	
	new:SetImage(165445582)	
	
	return new
end

return Grass_Water_Top