local azuza_client = {}
local pt = game.Players.LocalPlayer
local fps = 0
local total_fps = 0

function azuza_client:Run()
	if pt.PlayerGui:FindFirstChild("AzuzaClient") then
		pt.PlayerGui:FindFirstChild("AzuzaClient"):Destroy()
	end
	
	local window = Instance.new("ScreenGui", pt.PlayerGui)
	window.Name = "AzuzaClient"
	window.IgnoreGuiInset = true
	window.ResetOnSpawn = false
	
	local frameMain = Instance.new("Frame", window)
	frameMain.AnchorPoint = Vector2.new(0.5, 0.5)
	frameMain.Position = UDim2.fromScale(0.5, 0.5)
	frameMain.BackgroundColor3 = Color3.fromRGB(27, 8, 22)
	
	game.TweenService:Create(frameMain, TweenInfo.new(1.2, Enum.EasingStyle.Quart, Enum.EasingDirection.InOut), {Size = UDim2.fromScale(0.25, 0.35)}):Play()
	
	local ui1 = Instance.new("UIAspectRatioConstraint", frameMain)
	ui1.AspectRatio = 1.5
	
	local title = Instance.new("TextButton", frameMain)
	title.Size = UDim2.fromScale(1, 0.1)
	title.Name = "Title"
	title.BackgroundColor3 = Color3.fromRGB(255, 132, 0)
	title.TextScaled = true
	title.TextColor3 = Color3.fromRGB(255,255,255)
	title.Font = Enum.Font.Gotham
	title.Text = "Azuza Client | ? FPS"
	
	local scroll = Instance.new("ScrollingFrame", frameMain)
	scroll.BackgroundTransparency = 1
	scroll.AnchorPoint = Vector2.new(0, 1)
	scroll.Position = UDim2.fromScale(0, 1)
	scroll.Size = UDim2.fromScale(1, 0.9)
	scroll.BorderSizePixel = 0
	scroll.ScrollBarThickness = 5
	scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
	_G.last_title = title
	local ui2 = Instance.new("UIListLayout", scroll)
	ui2.Padding = UDim.new(0.025, 0)
	
	
	local function createInfo(pt1)
		local txt = Instance.new("TextLabel", scroll)
		txt.Size = UDim2.fromScale(1, 0.285)
		txt.Name = "Info"
		txt.BackgroundTransparency = 1
		txt.TextScaled = true
		txt.TextColor3 = Color3.fromRGB(255,255,255)
		txt.Font = Enum.Font.Gotham
		txt.RichText = true
		txt.Text = "User: "..pt1.Name
		txt:SetAttribute("PlayerName", pt1.Name)
		spawn(function()
			while task.wait() do
				local s, err = pcall(function()
					local user = pt1.Name
					local tools = 0
					local tools_c = 0
					for i,v in pairs(pt1.Backpack:GetChildren()) do
						if v:IsA("Tool") then
							tools += 1
						end
					end
					for i,v in pairs(pt1.Character:GetChildren()) do
						if v:IsA("Tool") then
							tools_c += 1
						end
					end
					txt.Text = string.format("User: %s\nTools in backpack: %s\nTools in character: %s", user, tools, tools_c)
				end)
				if not s then
					print(err)
				end
			end
		end)
	end
	local function removeInfo(n)
		for i,v in pairs(scroll:GetChildren()) do
			if v:GetAttribute("PlayerName") == n then
				v:Destroy()
			end
		end
	end
	game.Players.PlayerAdded:Connect(function(pt1)
		createInfo(pt1)
	end)
	
	game.Players.PlayerRemoving:Connect(function(pt1)
		removeInfo(pt1.Name)
	end)
	createInfo(pt)
	local mouse = pt:GetMouse()
	
	local drag = false
	
	title.MouseButton1Down:Connect(function()
		drag = true
	end)
	mouse.Button1Up:Connect(function()
		drag = false
	end)
	spawn(function()
		while task.wait(0.001) do
			if drag then
				local vX, vY = mouse.ViewSizeX, mouse.ViewSizeY
				local X, Y = mouse.X, mouse.Y
				local size = Vector2.new(vX, vY)
				local pos = Vector2.new(X, Y)
				frameMain.Position = UDim2.new(0, X, 0, Y)
			end
		end
	end)
end
-- fps tracking
spawn(function()
	local c = nil
	while task.wait(0.25) do 
	if c ~= nil then
		total_fps = fps
		fps = 0
		c:Disconnect()
	end
	c = game["Run Service"].RenderStepped:Connect(function()
		fps += 4
	end)
	end
end)
spawn(function()
	game["Run Service"].RenderStepped:Connect(function(d)
		task.wait(d)
		if _G.last_title ~= nil then
			_G.last_title.Text = string.format("Azuza Client | %s FPS", total_fps)
		end
	end)
end)

azuza_client:Run()
