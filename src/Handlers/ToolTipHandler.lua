CameraHandler = require(_G.Everest.Handlers.CameraHandler)


ToolTipHandler = {}


function ToolTipHandler:ProvideOptions(options, position, entity)
	if container then container:Destroy() end	
	options[#options + 1] = "Cancel"	
	
	container = Instance.new("Frame", CameraHandler:GetContainer())
	container.ZIndex = 1
	container.Size = UDim2.new(0, 100, 0, 25)	
	container.Position = UDim2.new(0, position.X * _G.TileSize, 0, -position.Y * _G.TileSize)
	
	for i, v in pairs(options) do
		local tip = CreateToolTip(v, container, entity)
		tip.Position = UDim2.new(0,0,0,25 * (i - 1))
	end	
end

function ToolTipHandler:ProvideItemOptions(options, position, item)
	if container then container:Destroy() end	
	
	options[#options + 1] = "Cancel"	
	
	container = Instance.new("Frame", CameraHandler:GetContainer().Parent)
	container.ZIndex = 1
	container.Size = UDim2.new(0, 100, 0, 25)	
	container.Position = position
	
	for i, v in pairs(options) do
		local tip = CreateToolTip(v, container, item)
		tip.Position = UDim2.new(0,0,0,25 * (i - 1))
	end
end

function TipClicked(option, entity)
	if option ~= "Cancel" then
		entity:OptionChosen(option)
	end
end

function CreateToolTip(text, container, entity)
	local tip = Instance.new("TextButton", container)
	tip.Size = UDim2.new(1,0,1,0)
	tip.BackgroundColor3 = Color3.new(1,1,1)
	tip.BackgroundTransparency = 0.1
	tip.BorderSizePixel = 2
	tip.Text = text
	tip.FontSize = "Size12"
	tip.ZIndex = 9	
	
	tip.MouseButton1Click:connect(function()
		TipClicked(text, entity)
		container:Destroy()
	end)
	
	return tip
end


return ToolTipHandler