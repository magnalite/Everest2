Tile = require(_G.Everest.Objects.Tile)

Grass_Center = {}
Grass_Center.__index = Grass_Center
setmetatable(Grass_Center, Tile)

Tile.Tiles[0] = Grass_Center

function Grass_Center.new(position)
	local new = Tile.new(position, true)
	setmetatable(new, Grass_Center)
	
	new.TileID = 0
	
	new:SetImage(165444671)	
	
	return new
end

return Grass_Center