
InputHandler = {}
InputHandler.Keys = {}
InputHandler.Events = {}

game.Players.LocalPlayer:GetMouse().KeyDown:connect(function(key)
	InputHandler.Keys[key] = true
	if InputHandler.Events[string.lower(key)] then
		InputHandler.Events[string.lower(key)]()
	end
end)

game.Players.LocalPlayer:GetMouse().KeyUp:connect(function(key)
	InputHandler.Keys[key] = false
end)


return InputHandler