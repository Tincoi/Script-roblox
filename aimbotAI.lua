local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Trạng thái
local aimbotBat = false
local doMuot = 0.1 -- độ mượt (càng thấp càng nhanh)

-- ===== GUI =====
local screenGui = Instance.new("ScreenGui")
screenGui.ResetOnSpawn = false
screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0,200,0,50)
frame.Position = UDim2.new(1,-500,1,-45)
frame.BackgroundTransparency = 1
frame.BackgroundColor3 = Color3.fromRGB(0,0,0)
frame.BorderSizePixel = 0
frame.Parent = screenGui

local text = Instance.new("TextLabel")
text.Size = UDim2.new(1,-10,1,-10)
text.Position = UDim2.new(0,5,0,5)
text.BackgroundTransparency = 1
text.TextScaled = true
text.Font = Enum.Font.SourceSansBold
text.TextStrokeTransparency = 0.1
text.TextYAlignment = Enum.TextYAlignment.Top
text.Parent = frame

local function capNhatGUI()
	if aimbotBat then
		text.TextColor3 = Color3.fromRGB(0,255,0)
		text.Text = "AIMBOT: BẬT\nGiữ Chuột Phải để khóa mục tiêu"
	else
		text.TextColor3 = Color3.fromRGB(255,0,0)
		text.Text = "AIMBOT: TẮT\nNhấn H để bật"
	end
end

capNhatGUI()

-- ===== Tìm player gần tâm =====
local function timMucTieuGanNhat()
	local mouse = LocalPlayer:GetMouse()
	local ganNhat = nil
	local khoangCachGanNhat = math.huge

	for _, player in ipairs(Players:GetPlayers()) do
		if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
			
			local head = player.Character.Head
			local screenPos, hienThi = Camera:WorldToViewportPoint(head.Position)

			if hienThi then
				local dx = mouse.X - screenPos.X
				local dy = mouse.Y - screenPos.Y
				local khoangCach = math.sqrt(dx*dx + dy*dy)

				if khoangCach < khoangCachGanNhat then
					khoangCachGanNhat = khoangCach
					ganNhat = player
				end
			end
		end
	end

	return ganNhat
end

-- ===== Bật tắt Aimbot =====
UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end

	if input.KeyCode == Enum.KeyCode.H then
		aimbotBat = not aimbotBat
		capNhatGUI()
	end
end)

-- ===== Lock aim =====
UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end

	if input.UserInputType == Enum.UserInputType.MouseButton2 and aimbotBat then

		local target = timMucTieuGanNhat()

		if target and target.Character and target.Character:FindFirstChild("Head") then

			local conn
			conn = RunService.RenderStepped:Connect(function()

				if UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then

					local mucTieu = CFrame.new(
						Camera.CFrame.Position,
						target.Character.Head.Position
					)

					-- aim mượt
					Camera.CFrame = Camera.CFrame:Lerp(mucTieu, doMuot)

				else
					conn:Disconnect()
				end

			end)

		end
	end
end)
