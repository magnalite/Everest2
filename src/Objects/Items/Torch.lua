Item = require(_G.Everest.Objects.Item)
TorchEntity = require(_G.Everest.Objects.Entities.Torch)

Torch = {}
Torch.__index = Torch
setmetatable(Torch, Item)

Item.Items[4] = Torch
Item.Items.Torch = Torch

function Torch.new(inventory)
	local new = Item.new("Torch", inventory)
	setmetatable(new, Torch)
	
	new:SetEntityId("TorchItemEntity")
	new:SetRenderImageId(171307663)
	
	return new
end

function Torch:OptionChosen(option)
	if option == "Place" then
		self:StartPlacingEntity(TorchEntity.new(_G.localPlayer.Position), false, true)
	end
end

function Torch:GetOptions()
	return {"Place"}
end

function Torch:GetInfo()
	return "Brighten up the darkness."
end

return Torch