local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()

local selectedPlayer = nil
local selectedButton = nil

-- GUI
local gui = Instance.new("ScreenGui")
gui.Parent = player:WaitForChild("PlayerGui")
gui.ResetOnSpawn = false

-- Toggle Button
local toggle = Instance.new("TextButton")
toggle.Parent = gui
toggle.Size = UDim2.new(0,130,0,40)
toggle.Position = UDim2.new(0,20,0,120)
toggle.Text = "Teleport GUI"
toggle.BackgroundColor3 = Color3.fromRGB(40,40,40)
toggle.TextColor3 = Color3.new(1,1,1)
toggle.Active = true
toggle.Draggable = true

Instance.new("UICorner",toggle).CornerRadius = UDim.new(0,10)

-- Main Frame
local frame = Instance.new("Frame")
frame.Parent = gui
frame.Size = UDim2.new(0,320,0,380)
frame.Position = UDim2.new(0.5,-160,0.5,-190)
frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
frame.Visible = false
frame.Active = true
frame.Draggable = true

Instance.new("UICorner",frame).CornerRadius = UDim.new(0,12)

-- Title
local title = Instance.new("TextLabel")
title.Parent = frame
title.Size = UDim2.new(1,0,0,40)
title.Text = "Teleport Player (Press T)"
title.BackgroundColor3 = Color3.fromRGB(45,45,45)
title.TextColor3 = Color3.new(1,1,1)

Instance.new("UICorner",title).CornerRadius = UDim.new(0,10)

-- Scroll list
local scroll = Instance.new("ScrollingFrame")
scroll.Parent = frame
scroll.Size = UDim2.new(1,-10,1,-50)
scroll.Position = UDim2.new(0,5,0,45)
scroll.CanvasSize = UDim2.new(0,0,0,0)
scroll.ScrollBarThickness = 6
scroll.BackgroundColor3 = Color3.fromRGB(35,35,35)

Instance.new("UICorner",scroll).CornerRadius = UDim.new(0,10)

-- Update player list
local function updateList()

	for _,v in pairs(scroll:GetChildren()) do
		if v:IsA("Frame") then
			v:Destroy()
		end
	end

	local y = 0

	for _,plr in pairs(Players:GetPlayers()) do

		if plr ~= player then

			local container = Instance.new("Frame")
			container.Parent = scroll
			container.Size = UDim2.new(1,-10,0,50)
			container.Position = UDim2.new(0,5,0,y)
			container.BackgroundColor3 = Color3.fromRGB(50,50,50)

			Instance.new("UICorner",container).CornerRadius = UDim.new(0,10)

			-- Avatar
			local avatar = Instance.new("ImageLabel")
			avatar.Parent = container
			avatar.Size = UDim2.new(0,40,0,40)
			avatar.Position = UDim2.new(0,5,0.5,-20)
			avatar.BackgroundTransparency = 1

			local thumb = Players:GetUserThumbnailAsync(
				plr.UserId,
				Enum.ThumbnailType.HeadShot,
				Enum.ThumbnailSize.Size100x100
			)

			avatar.Image = thumb

			-- Button
			local btn = Instance.new("TextButton")
			btn.Parent = container
			btn.Size = UDim2.new(1,-60,1,0)
			btn.Position = UDim2.new(0,55,0,0)
			btn.Text = plr.DisplayName.."  @"..plr.Name
			btn.BackgroundTransparency = 1
			btn.TextColor3 = Color3.new(1,1,1)
			btn.TextXAlignment = Enum.TextXAlignment.Left

			btn.MouseButton1Click:Connect(function()

				if selectedPlayer ~= plr then

					if selectedButton then
						selectedButton.Text = selectedPlayer.DisplayName.."  @"..selectedPlayer.Name
					end

					selectedPlayer = plr
					selectedButton = btn

					btn.Text = "SELECTED: "..plr.DisplayName.."  @"..plr.Name

				else

					if plr.Character
					and plr.Character:FindFirstChild("HumanoidRootPart")
					and char:FindFirstChild("HumanoidRootPart") then

						char:PivotTo(
							CFrame.new(plr.Character.HumanoidRootPart.Position + Vector3.new(2,0,2))
						)

					end

				end

			end)

			y = y + 55

		end

	end

	scroll.CanvasSize = UDim2.new(0,0,0,y)

end

updateList()

Players.PlayerAdded:Connect(updateList)
Players.PlayerRemoving:Connect(updateList)

-- Keybind teleport
UserInputService.InputBegan:Connect(function(input,gp)

	if gp then return end

	if input.KeyCode == Enum.KeyCode.T then

		if selectedPlayer
		and selectedPlayer.Character
		and selectedPlayer.Character:FindFirstChild("HumanoidRootPart")
		and char:FindFirstChild("HumanoidRootPart") then

			char:PivotTo(
				CFrame.new(selectedPlayer.Character.HumanoidRootPart.Position + Vector3.new(2,0,2))
			)

		end

	end

end)

-- Toggle GUI
toggle.MouseButton1Click:Connect(function()
	frame.Visible = not frame.Visible
end)

-- Character reload
player.CharacterAdded:Connect(function(newChar)
	char = newChar
end)
