--[[ 
    TELEPORT GUI ULTIMATE V4 (AUTO-HIDE ON TP)
    - Tự động ẩn GUI khi dịch chuyển (Teleport).
    - Font chữ lớn, dễ nhìn trên Mobile/PC.
    - Keybind: F (Teleport), K (Toggle).
    - Chức năng Xem (Spectate) tự tắt khi TP.
]]

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

if CoreGui:FindFirstChild("TeleportGuiSystem") then
    CoreGui:FindFirstChild("TeleportGuiSystem"):Destroy()
end

local selectedPlayer = nil
local isSpectating = false

-- 1. HÀM ĐIỀU KHIỂN GUI
local function toggleGui(forceState)
    if forceState ~= nil then
        _G.MainFrame.Visible = forceState
        _G.OpenBtn.Visible = not forceState
    else
        _G.MainFrame.Visible = not _G.MainFrame.Visible
        _G.OpenBtn.Visible = not _G.MainFrame.Visible
    end
end

-- 2. LOGIC HỆ THỐNG
local function stopSpectating()
    isSpectating = false
    camera.CameraSubject = player.Character:FindFirstChild("Humanoid")
    return "XEM: TẮT"
end

local function startSpectating(target)
    if target and target.Character and target.Character:FindFirstChild("Humanoid") then
        camera.CameraSubject = target.Character.Humanoid
        isSpectating = true
        return "XEM: " .. target.DisplayName:upper()
    end
    return stopSpectating()
end

local function teleportTo(targetPlayer)
    if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local char = player.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            -- Tắt xem nếu đang bật
            if isSpectating then 
                stopSpectating() 
                _G.SpectateBtn.Text = "XEM: TẮT"
                _G.SpectateBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            end
            
            -- Thực hiện dịch chuyển
            char.HumanoidRootPart.CFrame = targetPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
            
            -- TỰ ĐỘNG ẨN GUI SAU KHI TP
            toggleGui(false)
        end
    end
end

-- 3. GIAO DIỆN
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "TeleportGuiSystem"
screenGui.Parent = CoreGui
screenGui.ResetOnSpawn = false

local mainFrame = Instance.new("Frame")
_G.MainFrame = mainFrame
mainFrame.Size = UDim2.new(0, 260, 0, 420)
mainFrame.Position = UDim2.new(0.5, -130, 0.3, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true 
mainFrame.Parent = screenGui
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 10)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 50)
title.Text = "TP MENU (F)"
title.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.Parent = mainFrame
Instance.new("UICorner", title).CornerRadius = UDim.new(0, 10)

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 35, 0, 35)
closeBtn.Position = UDim2.new(1, -40, 0, 7)
closeBtn.Text = "X"
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeBtn.TextColor3 = Color3.new(1, 1, 1)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 18
closeBtn.Parent = mainFrame
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 6)

local spectateBtn = Instance.new("TextButton")
_G.SpectateBtn = spectateBtn
spectateBtn.Size = UDim2.new(1, -20, 0, 35)
spectateBtn.Position = UDim2.new(0, 10, 0, 60)
spectateBtn.Text = "XEM: TẮT"
spectateBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
spectateBtn.TextColor3 = Color3.new(1, 1, 1)
spectateBtn.Font = Enum.Font.GothamBold
spectateBtn.TextSize = 14
spectateBtn.Parent = mainFrame
Instance.new("UICorner", spectateBtn).CornerRadius = UDim.new(0, 6)

local scrollingFrame = Instance.new("ScrollingFrame")
scrollingFrame.Size = UDim2.new(1, -10, 1, -165)
scrollingFrame.Position = UDim2.new(0, 5, 0, 105)
scrollingFrame.BackgroundTransparency = 1
scrollingFrame.ScrollBarThickness = 5
scrollingFrame.Parent = mainFrame

local layout = Instance.new("UIListLayout")
layout.Parent = scrollingFrame
layout.Padding = UDim.new(0, 10)

local openBtn = Instance.new("TextButton")
_G.OpenBtn = openBtn
openBtn.Size = UDim2.new(0, 55, 0, 55)
openBtn.Position = UDim2.new(0, 10, 0.5, -25)
openBtn.Text = "TP"
openBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
openBtn.BackgroundTransparency = 0.2
openBtn.TextColor3 = Color3.new(1, 1, 1)
openBtn.TextSize = 18
openBtn.Visible = false
openBtn.Parent = screenGui
Instance.new("UICorner", openBtn).CornerRadius = UDim.new(1, 0)

-- 4. CẬP NHẬT DANH SÁCH
local function updateList()
    for _, child in pairs(scrollingFrame:GetChildren()) do
        if child:IsA("TextButton") then child:Destroy() end
    end

    for _, p in pairs(Players:GetPlayers()) do
        if p ~= player then
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, -10, 0, 55)
            btn.BackgroundColor3 = (selectedPlayer == p) and Color3.fromRGB(255, 165, 0) or Color3.fromRGB(45, 45, 45)
            btn.Text = ""
            btn.Parent = scrollingFrame
            Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)

            local dName = Instance.new("TextLabel")
            dName.Size = UDim2.new(1, -15, 0, 30)
            dName.Position = UDim2.new(0, 12, 0, 4)
            dName.Text = p.DisplayName
            dName.BackgroundTransparency = 1
            dName.TextColor3 = Color3.new(1, 1, 1)
            dName.Font = Enum.Font.GothamBold
            dName.TextSize = 16
            dName.TextXAlignment = Enum.TextXAlignment.Left
            dName.Parent = btn

            local uName = Instance.new("TextLabel")
            uName.Size = UDim2.new(1, -15, 0, 20)
            uName.Position = UDim2.new(0, 12, 0, 28)
            uName.Text = "@" .. p.Name
            uName.BackgroundTransparency = 1
            uName.TextColor3 = (selectedPlayer == p) and Color3.new(0.2, 0.2, 0.2) or Color3.new(0.7, 0.7, 0.7)
            uName.Font = Enum.Font.Gotham
            uName.TextSize = 12
            uName.TextXAlignment = Enum.TextXAlignment.Left
            uName.Parent = btn
            
            btn.MouseButton1Click:Connect(function()
                if selectedPlayer == p then
                    teleportTo(p)
                else
                    selectedPlayer = p
                    if isSpectating then spectateBtn.Text = startSpectating(p) end
                    updateList()
                end
            end)
        end
    end
    scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y)
end

-- 5. ĐIỀU KHIỂN
closeBtn.MouseButton1Click:Connect(function() toggleGui(false) end)
openBtn.MouseButton1Click:Connect(function() toggleGui(true) end)

spectateBtn.MouseButton1Click:Connect(function()
    if not selectedPlayer then return end
    if isSpectating then
        spectateBtn.Text = stopSpectating()
        spectateBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    else
        spectateBtn.Text = startSpectating(selectedPlayer)
        spectateBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
    end
end)

UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    if input.KeyCode == Enum.KeyCode.K then toggleGui()
    elseif input.KeyCode == Enum.KeyCode.F then if selectedPlayer then teleportTo(selectedPlayer) end end
end)

Players.PlayerAdded:Connect(updateList)
Players.PlayerRemoving:Connect(function(p) 
    if selectedPlayer == p then selectedPlayer = nil if isSpectating then stopSpectating() end end 
    updateList() 
end)

updateList()
