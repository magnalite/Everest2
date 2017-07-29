CameraHandler       = require(_G.Everest.Handlers.CameraHandler)

NotificationHandler = {}
Notifications = {}


function NotificationHandler.NewNotification(text)
	local notification                  = Instance.new("TextLabel", CameraHandler:GetContainer().Parent)
	notification.Size                   = UDim2.new(0,200,0,75)
	notification.BackgroundTransparency = 0.7
	notification.BackgroundColor3       = Color3.new(0,0,0)
	notification.BorderColor3           = Color3.new(1,1,1)
	notification.BorderSizePixel        = 5
	notification.FontSize               = "Size14"
	notification.TextWrapped            = true
	notification.TextStrokeTransparency = 0.5
	notification.TextStrokeColor3       = Color3.new(1,1,1)
	notification.TextColor3             = Color3.new(0,0,0)
	notification.Text                   = text
	notification.ZIndex                 = 10
	notification.Position               = UDim2.new(1, -220, 0, -75)
	notification:TweenPosition(UDim2.new(1, -220, 0, #Notifications * 95 + 20), "Out", "Back", 1, true)
	table.insert(Notifications, notification)
	spawn(function()
		wait(5)
		for i, v in pairs(Notifications) do
			if v == notification then
				table.remove(Notifications, i)
				v:Destroy()
			end
		end
		for i, v in pairs(Notifications) do
			v:TweenPosition(UDim2.new(1, -220, 0, (i - 1) * 95 + 20), "Out", "Back", 1, true)
		end
	end)
end


return NotificationHandler