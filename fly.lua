-- PidersawHub v1.0.0
-- FIXED & STABLE

repeat task.wait() until game:IsLoaded()

-- SERVICES
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RS = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")

-- NOTIFICATION
pcall(function()
	StarterGui:SetCore("SendNotification", {
		Title = "Script Loaded",
		Text = "by Pidersaw",
		Duration = 5
	})
end)

-- PLAYER
local player = Players.LocalPlayer
local character = nil
local humanoid = nil
local root = nil

local function bindCharacter(char)
	character = char
	humanoid = char:WaitForChild("Humanoid")
	root = char:WaitForChild("HumanoidRootPart")
end

if player.Character then
	bindCharacter(player.Character)
end
player.CharacterAdded:Connect(bindCharacter)

-- STATES
local flying = false
local noclip = false
local espOn = false
local infJump = false
local flySpeed = 50
local walkSpeed = 16

local bodyVel = nil
local bodyGyro = nil
local flyConn = nil

-- ================= GUI =================
local gui = Instance.new("ScreenGui")
gui.Name = "PidersawHub"
gui.ResetOnSpawn = false
gui.Parent = game.CoreGui

-- Mini Icon
local mini = Instance.new("TextButton")
mini.Parent = gui
mini.Size = UDim2.fromOffset(36,36)
mini.Position = UDim2.fromScale(0.02,0.85)
mini.Text = "◼"
mini.Font = Enum.Font.GothamBold
mini.TextSize = 18
mini.BackgroundColor3 = Color3.fromRGB(30,30,30)
mini.TextColor3 = Color3.new(1,1,1)

-- Main Frame
local frame = Instance.new("Frame")
frame.Parent = gui
frame.Size = UDim2.fromOffset(300,300)
frame.Position = UDim2.fromScale(0.38,0.26)
frame.BackgroundColor3 = Color3.fromRGB(25,25,25)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true

-- Top bar
local top = Instance.new("Frame")
top.Parent = frame
top.Size = UDim2.new(1,0,0,34)
top.BackgroundTransparency = 1

local title = Instance.new("TextLabel")
title.Parent = top
title.Size = UDim2.new(1,-40,1,0)
title.Position = UDim2.fromOffset(10,0)
title.BackgroundTransparency = 1
title.Text = "PidersawHub v1.0.0"
title.Font = Enum.Font.GothamBold
title.TextSize = 15
title.TextColor3 = Color3.new(1,1,1)
title.TextXAlignment = Enum.TextXAlignment.Left

local closeBtn = Instance.new("TextButton")
closeBtn.Parent = top
closeBtn.Size = UDim2.fromOffset(30,30)
closeBtn.Position = UDim2.new(1,-34,0,2)
closeBtn.Text = "✕"
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 14
closeBtn.BackgroundColor3 = Color3.fromRGB(60,60,60)
closeBtn.TextColor3 = Color3.new(1,1,1)

-- Tabs
local tabBar = Instance.new("Frame")
tabBar.Parent = frame
tabBar.Size = UDim2.new(1,0,0,34)
tabBar.Position = UDim2.fromOffset(0,36)
tabBar.BackgroundTransparency = 1

local function createTab(text, x)
	local b = Instance.new("TextButton")
	b.Parent = tabBar
	b.Size = UDim2.fromOffset(120,28)
	b.Position = UDim2.fromOffset(x,3)
	b.Text = text
	b.Font = Enum.Font.Gotham
	b.TextSize = 13
	b.BackgroundColor3 = Color3.fromRGB(60,60,60)
	b.TextColor3 = Color3.new(1,1,1)
	return b
end

local mainTab = createTab("Main", 10)
local settingsTab = createTab("Settings", 140)

-- Pages
local pages = Instance.new("Frame")
pages.Parent = frame
pages.Size = UDim2.new(1,0,1,-76)
pages.Position = UDim2.fromOffset(0,72)
pages.BackgroundTransparency = 1

local mainPage = Instance.new("Frame")
mainPage.Parent = pages
mainPage.Size = UDim2.fromScale(1,1)
mainPage.BackgroundTransparency = 1

local settingsPage = Instance.new("Frame")
settingsPage.Parent = pages
settingsPage.Size = UDim2.fromScale(1,1)
settingsPage.BackgroundTransparency = 1
settingsPage.Visible = false

local coming = Instance.new("TextLabel")
coming.Parent = settingsPage
coming.Size = UDim2.fromScale(1,1)
coming.BackgroundTransparency = 1
coming.Text = "Coming soon :)"
coming.Font = Enum.Font.GothamBold
coming.TextSize = 18
coming.TextColor3 = Color3.new(1,1,1)

-- Helpers
local function makeButton(parent, text, y)
	local b = Instance.new("TextButton")
	b.Parent = parent
	b.Size = UDim2.fromOffset(260,34)
	b.Position = UDim2.fromOffset(20,y)
	b.Text = text
	b.Font = Enum.Font.Gotham
	b.TextSize = 14
	b.BackgroundColor3 = Color3.fromRGB(60,60,60)
	b.TextColor3 = Color3.new(1,1,1)
	return b
end

-- ================= FEATURES =================
-- Fly
local function startFly()
	if flying or not root then return end
	flying = true

	bodyVel = Instance.new("BodyVelocity")
	bodyVel.MaxForce = Vector3.new(9e9,9e9,9e9)
	bodyVel.Parent = root

	bodyGyro = Instance.new("BodyGyro")
	bodyGyro.MaxTorque = Vector3.new(9e9,9e9,9e9)
	bodyGyro.Parent = root

	humanoid.PlatformStand = true

	if flyConn then flyConn:Disconnect() end
	flyConn = RS.Heartbeat:Connect(function()
		if not flying then return end
		bodyGyro.CFrame = workspace.CurrentCamera.CFrame

		local cam = workspace.CurrentCamera
		local move = Vector3.zero

		if UIS:IsKeyDown(Enum.KeyCode.W) then move = move + cam.CFrame.LookVector end
		if UIS:IsKeyDown(Enum.KeyCode.S) then move = move - cam.CFrame.LookVector end
		if UIS:IsKeyDown(Enum.KeyCode.A) then move = move - cam.CFrame.RightVector end
		if UIS:IsKeyDown(Enum.KeyCode.D) then move = move + cam.CFrame.RightVector end
		if UIS:IsKeyDown(Enum.KeyCode.Space) then move = move + Vector3.new(0,1,0) end
		if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then move = move - Vector3.new(0,1,0) end

		bodyVel.Velocity = move * flySpeed
	end)
end

local function stopFly()
	flying = false
	if humanoid then humanoid.PlatformStand = false end
	if flyConn then flyConn:Disconnect() flyConn = nil end
	if bodyVel then bodyVel:Destroy() bodyVel = nil end
	if bodyGyro then bodyGyro:Destroy() bodyGyro = nil end
end

-- ================= UI BUTTONS =================
local flyBtn = makeButton(mainPage, "Fly: OFF", 10)

flyBtn.MouseButton1Click:Connect(function()
	if flying then
		stopFly()
		flyBtn.Text = "Fly: OFF"
	else
		startFly()
		flyBtn.Text = "Fly: ON"
	end
end)

-- Tabs
mainTab.MouseButton1Click:Connect(function()
	mainPage.Visible = true
	settingsPage.Visible = false
end)

settingsTab.MouseButton1Click:Connect(function()
	mainPage.Visible = false
	settingsPage.Visible = true
end)

-- Close / Mini
closeBtn.MouseButton1Click:Connect(function()
	frame.Visible = false
	mini.Visible = true
end)

mini.MouseButton1Click:Connect(function()
	frame.Visible = true
	mini.Visible = false
end)

-- Hotkeys
UIS.InputBegan:Connect(function(input, gpe)
	if gpe then return end

	if input.KeyCode == Enum.KeyCode.RightShift then
		frame.Visible = not frame.Visible
		mini.Visible = not frame.Visible
	end

	if input.KeyCode == Enum.KeyCode.E then
		if flying then
			stopFly()
			flyBtn.Text = "Fly: OFF"
		else
			startFly()
			flyBtn.Text = "Fly: ON"
		end
	end
end)

print("✅ PidersawHub v1.0.0 Loaded (FIXED)")
