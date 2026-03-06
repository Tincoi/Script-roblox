-- AUTO LOAD WHEN SERVER HOP
local scriptLink = "LINK_SCRIPT_CUA_BAN"

if queue_on_teleport then
    queue_on_teleport('loadstring(game:HttpGet("'..scriptLink..'"))()')
end

repeat task.wait() until game:IsLoaded()

local player = game.Players.LocalPlayer
local UIS = game:GetService("UserInputService")

local gui = Instance.new("ScreenGui")
gui.Parent = player:WaitForChild("PlayerGui")

-- Nút Menu
local toggle = Instance.new("TextButton")
toggle.Parent = gui
toggle.Size = UDim2.new(0,60,0,30)
toggle.Position = UDim2.new(0,10,0,200)
toggle.Text = "Menu"
toggle.BackgroundColor3 = Color3.fromRGB(40,40,40)
toggle.TextColor3 = Color3.new(1,1,1)
toggle.Active = true
toggle.Draggable = true
Instance.new("UICorner",toggle).CornerRadius = UDim.new(0,8)

-- Frame chính
local frame = Instance.new("Frame")
frame.Parent = gui
frame.Size = UDim2.new(0,520,0,210)
frame.Position = UDim2.new(0.5,-260,0.5,-105)
frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
frame.Visible = false
frame.Active = true
frame.Draggable = true
Instance.new("UICorner",frame).CornerRadius = UDim.new(0,12)

-- Nút đóng
local close = Instance.new("TextButton")
close.Parent = frame
close.Size = UDim2.new(0,30,0,30)
close.Position = UDim2.new(1,-35,0,5)
close.Text = "X"
close.BackgroundColor3 = Color3.fromRGB(170,0,0)
close.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner",close).CornerRadius = UDim.new(0,6)

close.MouseButton1Click:Connect(function()
	gui:Destroy()
end)

-- Nút Menu bật/tắt
toggle.MouseButton1Click:Connect(function()
	frame.Visible = not frame.Visible
end)

-- Keybind K
UIS.InputBegan:Connect(function(input,gp)
	if gp then return end
	if input.KeyCode == Enum.KeyCode.K then
		frame.Visible = not frame.Visible
	end
end)

-- Tạo 20 nút
for i = 1,20 do

	local button = Instance.new("TextButton")
	button.Parent = frame
	button.Size = UDim2.new(0,95,0,35)

	local col = (i-1) % 5
	local row = math.floor((i-1)/5)

	button.Position = UDim2.new(0,10 + col*100,0,40 + row*40)
	button.Text = "Script "..i
	button.BackgroundColor3 = Color3.fromRGB(70,70,70)
	button.TextColor3 = Color3.new(1,1,1)

	Instance.new("UICorner",button).CornerRadius = UDim.new(0,6)

	button.MouseButton1Click:Connect(function()

		if i == 1 then
			loadstring(game:HttpGet("https://raw.githubusercontent.com/Tincoi/Script-roblox/refs/heads/main/TphumanAI.lua"))()

		elseif i == 2 then
			loadstring(game:HttpGet("https://raw.githubusercontent.com/Tincoi/Script-roblox/refs/heads/main/aimbotAI"))()

		elseif i == 3 then
			loadstring(game:HttpGet(""))()

		elseif i == 4 then
			loadstring(game:HttpGet(""))()

		elseif i == 5 then
			loadstring(game:HttpGet(""))()

		elseif i == 6 then
			loadstring(game:HttpGet(""))()

		elseif i == 7 then
			loadstring(game:HttpGet(""))()

		elseif i == 8 then
			loadstring(game:HttpGet(""))()

		elseif i == 9 then
			loadstring(game:HttpGet(""))()

		elseif i == 10 then
			loadstring(game:HttpGet(""))()

		elseif i == 11 then
			loadstring(game:HttpGet(""))()

		elseif i == 12 then
			loadstring(game:HttpGet(""))()

		elseif i == 13 then
			loadstring(game:HttpGet(""))()

		elseif i == 14 then
			loadstring(game:HttpGet(""))()

		elseif i == 15 then
			loadstring(game:HttpGet(""))()

		elseif i == 16 then
			loadstring(game:HttpGet(""))()

		elseif i == 17 then
			loadstring(game:HttpGet(""))()

		elseif i == 18 then
			loadstring(game:HttpGet(""))()

		elseif i == 19 then
			loadstring(game:HttpGet(""))()

		elseif i == 20 then
			loadstring(game:HttpGet(""))()

		end

	end)

end
