-- PidersawHub | Fly GUI (Stable)
-- Fly: Button + E
-- GUI Toggle: RightShift

repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RS = game:GetService("RunService")

local plr = Players.LocalPlayer
local char = plr.Character or plr.CharacterAdded:Wait()
local hum = char:WaitForChild("Humanoid")
local root = char:WaitForChild("HumanoidRootPart")

local flying = false
local speed = 50
local bv, bg

-- ================= GUI =================
local gui = Instance.new("ScreenGui")
gui.Name = "PidersawGUI"
gui.ResetOnSpawn = false
gui.Parent = game.CoreGui

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.fromOffset(220, 120)
frame.Position = UDim2.fromScale(0.4, 0.35)
frame.BackgroundColor3 = Color3.fromRGB(25,25,25)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1,0,0,30)
title.BackgroundTransparency = 1
title.Text = "Pidersaw Fly GUI V1.0.0"
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.GothamBold
title.TextSize = 16

local flyBtn = Instance.new("TextButton", frame)
flyBtn.Size = UDim2.fromOffset(180,40)
flyBtn.Position = UDim2.fromOffset(20,50)
flyBtn.BackgroundColor3 = Color3.fromRGB(60,60,60)
flyBtn.TextColor3 = Color3.new(1,1,1)
flyBtn.Font = Enum.Font.Gotham
flyBtn.TextSize = 14
flyBtn.Text = "Fly: OFF"

-- ================= FLY =================
local function startFly()
	if flying then return end
	flying = true

	bv = Instance.new("BodyVelocity", root)
	bv.MaxForce = Vector3.new(9e9,9e9,9e9)
	bv.Velocity = Vector3.zero

	bg = Instance.new("BodyGyro", root)
	bg.MaxTorque = Vector3.new(9e9,9e9,9e9)
	bg.CFrame = root.CFrame

	hum.PlatformStand = true

	RS.Heartbeat:Connect(function()
		if not flying then return end

		bg.CFrame = workspace.CurrentCamera.CFrame

		local move = Vector3.zero
		local cam = workspace.CurrentCamera

		if UIS:IsKeyDown(Enum.KeyCode.W) then move += cam.CFrame.LookVector end
		if UIS:IsKeyDown(Enum.KeyCode.S) then move -= cam.CFrame.LookVector end
		if UIS:IsKeyDown(Enum.KeyCode.A) then move -= cam.CFrame.RightVector end
		if UIS:IsKeyDown(Enum.KeyCode.D) then move += cam.CFrame.RightVector end
		if UIS:IsKeyDown(Enum.KeyCode.Space) then move += Vector3.new(0,1,0) end
		if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then move -= Vector3.new(0,1,0) end

		bv.Velocity = move * speed
	end)
end

local function stopFly()
	flying = false
	hum.PlatformStand = false
	if bv then bv:Destroy() end
	if bg then bg:Destroy() end
end

-- ================= CONTROLS =================
flyBtn.MouseButton1Click:Connect(function()
	if flying then
		stopFly()
		flyBtn.Text = "Fly: OFF"
	else
		startFly()
		flyBtn.Text = "Fly: ON"
	end
end)

UIS.InputBegan:Connect(function(input, gpe)
	if gpe then return end

	if input.KeyCode == Enum.KeyCode.E then
		if flying then
			stopFly()
			flyBtn.Text = "Fly: OFF"
		else
			startFly()
			flyBtn.Text = "Fly: ON"
		end
	end

	if input.KeyCode == Enum.KeyCode.RightShift then
		frame.Visible = not frame.Visible
	end
end)

print("✅ Pidersaw Fly GUI Loaded")
