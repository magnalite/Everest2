if _G.InEditor or _G.Server then
	Screen = Instance.new("ScreenGui", game.StarterGui)
else
	Screen = Instance.new("ScreenGui", game.Players.LocalPlayer.PlayerGui)
end
Container                       = Instance.new("Frame", Screen)
EntityContainer                 = Instance.new("Frame", Container)
Vignette                        = Instance.new("ImageLabel", Screen)
Vignette.Size                   = UDim2.new(1,0,1,0)
Vignette.BackgroundTransparency = 1
Vignette.ImageTransparency      = 0.2
Vignette.ZIndex                 = 10
Vignette.Image                  = "rbxassetid://165505736"

CameraHandler = {}

CameraHandler.Screen          = Screen
CameraHandler.Container       = Container
CameraHandler.EntityContainer = EntityContainer

function CameraHandler:Step(delta)	
	local timer = tick()	
	
	if self.EntityToFollow then
		local pos = self.EntityToFollow.Position
		Container.Position = UDim2.new(0.5, -pos.X * _G.TileSize, 0.5, pos.Y * _G.TileSize)
	end
	
	CameraHandler:ParticalFallSim(delta)	
	
	ProfilerHandler.AddProcessTime("Handler", "Camera", tick() - timer)
end

function CameraHandler:ParticalFallSim(delta)
	if self.EntityToFollow and math.random(1,30) == 1 then
		local particle = Instance.new("ImageLabel", Container)
		local size = math.random()*40
		local startpos = self.EntityToFollow.Position + Vector2.new(math.random()*80 - 40, 15)
		local endpos = self.EntityToFollow.Position + Vector2.new(math.random()*80 - 40, -15)
		particle.Size = UDim2.new(0, size, 0, size)
		particle.Image = "rbxassetid://170090098"
		particle.BackgroundTransparency = 1
		particle.ImageTransparency = math.random()
		particle.Position = UDim2.new(0, startpos.x * _G.TileSize, 0, -startpos.y * _G.TileSize)
		particle:TweenPosition(UDim2.new(0, endpos.x * _G.TileSize, 0, -endpos.y * _G.TileSize), "Out", "Quad", 40, true)
		particle.ZIndex = 7
		
		spawn(function() wait(40) particle:Destroy() end)
	end
end

function CameraHandler:Init()
	ProfilerHandler = require(_G.Everest.Handlers.ProfilerHandler)
end

function CameraHandler:FollowEntity(entity)
	
	self.EntityToFollow = entity
end

function CameraHandler:GetContainer()
	return Container
end

function CameraHandler:GetScreenSize()
	return Screen.AbsoluteSize
end

return CameraHandler