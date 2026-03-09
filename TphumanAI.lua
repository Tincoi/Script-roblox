--[[ 
    TELEPORT GUI ULTIMATE V9 (5-STEP DISTANCE)
    - Nút < và >: Tăng/Giảm 5 studs mỗi lần bấm.
    - Khoảng cách nhỏ nhất: 1 stud.
    - Khoảng cách lớn nhất: 100 studs.
    - Tự động dừng bám khi đối phương chết hoặc thoát.
]]

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

if CoreGui:FindFirstChild("GeminiTP_V9") then
    CoreGui:FindFirstChild("GeminiTP_V9"):Destroy()
end

local selectedPlayer = nil
local isSpectating = false
local isSpamming = false
local tpDistance = 1 -- Khoảng cách nhỏ nhất là 1 theo yêu cầu

-- 1. HÀM HỆ THỐNG
local function stopSpectating()
    isSpectating = false
    camera.CameraSubject = player.Character:FindFirstChild("Humanoid")
    return "XEM: TẮT"
end

local function toggleGui(state)
    _G.MainFrame.Visible = state
    _G.OpenBtn.Visible = not state
end

local function stopSpam()
    isSpamming = false
    _G.SpamBtn.Text = "SPAM TP (G): TẮT"
    _G.SpamBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
end

local function updateDistanceUI()
    _G.DistLabel.Text = "Khoảng cách: " .. tpDistance .. " studs"
    -- Cập nhật thanh trượt theo tỷ lệ (tpDistance / 100)
    _G.SliderBar.Size = UDim2.new(math.clamp(tpDistance / 100, 0, 1), 0, 1, 0)
end

local function safeTeleport(target)
    if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
        local hum = target.Character:FindFirstChild("Humanoid")
        if hum and hum.Health <= 0 then stopSpam() return end
        
        local myChar = player.Character
        if myChar and myChar:FindFirstChild("HumanoidRootPart") then
            -- Dịch chuyển ra sau lưng theo khoảng cách tpDistance
            myChar.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, tpDistance)
        end
    end
end

RunService.RenderStepped:Connect(function()
    if isSpamming and selectedPlayer then safeTeleport(selectedPlayer) end
end)

-- 2. GIAO DIỆN
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "GeminiTP_V9"
screenGui.Parent = CoreGui
screenGui.ResetOnSpawn = false

local mainFrame = Instance.new("Frame")
_G.MainFrame = mainFrame
mainFrame.Size = UDim2.new(0, 260, 0, 480)
mainFrame.Position = UDim2.new(0.5, -130, 0.2, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
mainFrame.Active = true
mainFrame.Draggable = true 
mainFrame.Parent = screenGui
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 12)
Instance.new("UIStroke", mainFrame).Color = Color3.fromRGB(255, 165, 0)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 50)
title.Text = "GEMINI TP V9"
title.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.Parent = mainFrame
Instance.new("UICorner", title).CornerRadius = UDim.new(0, 12)

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 35, 0, 35)
closeBtn.Position = UDim2.new(1, -42, 0, 7)
closeBtn.Text = "×"
closeBtn.TextSize = 25
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeBtn.TextColor3 = Color3.new(1, 1, 1)
closeBtn.Parent = mainFrame
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 8)

local spectateBtn = Instance.new("TextButton")
spectateBtn.Size = UDim2.new(1, -20, 0, 40)
spectateBtn.Position = UDim2.new(0, 10, 0, 60)
spectateBtn.Text = "XEM: TẮT"
spectateBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
spectateBtn.TextColor3 = Color3.new(1, 1, 1)
spectateBtn.Font = Enum.Font.GothamBold
spectateBtn.Parent = mainFrame
Instance.new("UICorner", spectateBtn).CornerRadius = UDim.new(0, 8)

local spamBtn = Instance.new("TextButton")
_G.SpamBtn = spamBtn
spamBtn.Size = UDim2.new(1, -20, 0, 40)
spamBtn.Position = UDim2.new(0, 10, 0, 105)
spamBtn.Text = "SPAM TP (G): TẮT"
spamBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
spamBtn.TextColor3 = Color3.new(1, 1, 1)
spamBtn.Font = Enum.Font.GothamBold
spamBtn.Parent = mainFrame
Instance.new("UICorner", spamBtn).CornerRadius = UDim.new(0, 8)

-- ĐIỀU CHỈNH KHOẢNG CÁCH (Bước nhảy 5, Min 1)
local distLabel = Instance.new("TextLabel")
_G.DistLabel = distLabel
distLabel.Size = UDim2.new(1, 0, 0, 20)
distLabel.Position = UDim2.new(0, 0, 0, 150)
distLabel.Text = "Khoảng cách: 1 studs"
distLabel.TextColor3 = Color3.new(0.9, 0.9, 0.9)
distLabel.BackgroundTransparency = 1
distLabel.Font = Enum.Font.GothamMedium
distLabel.Parent = mainFrame

local minusBtn = Instance.new("TextButton")
minusBtn.Size = UDim2.new(0, 40, 0, 40)
minusBtn.Position = UDim2.new(0, 10, 0, 172)
minusBtn.Text = "<"
minusBtn.TextSize = 22
minusBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
minusBtn.TextColor3 = Color3.fromRGB(255, 165, 0)
minusBtn.Parent = mainFrame
Instance.new("UICorner", minusBtn).CornerRadius = UDim.new(0, 10)

local plusBtn = Instance.new("TextButton")
plusBtn.Size = UDim2.new(0, 40, 0, 40)
plusBtn.Position = UDim2.new(1, -50, 0, 172)
plusBtn.Text = ">"
plusBtn.TextSize = 22
plusBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
plusBtn.TextColor3 = Color3.fromRGB(255, 165, 0)
plusBtn.Parent = mainFrame
Instance.new("UICorner", plusBtn).CornerRadius = UDim.new(0, 10)

local distBarBG = Instance.new("Frame")
distBarBG.Size = UDim2.new(1, -110, 0, 10)
distBarBG.Position = UDim2.new(0, 55, 0, 187)
distBarBG.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
distBarBG.Parent = mainFrame
Instance.new("UICorner", distBarBG)

local sliderBar = Instance.new("Frame")
_G.SliderBar = sliderBar
sliderBar.Size = UDim2.new(0, 1, 1, 0)
sliderBar.BackgroundColor3 = Color3.fromRGB(255, 165, 0)
sliderBar.Parent = distBarBG
Instance.new("UICorner", sliderBar)

-- 3. LOGIC NÚT KHOẢNG CÁCH (Min 1, Step 5)
minusBtn.MouseButton1Click:Connect(function()
    if tpDistance > 5 then
        tpDistance = tpDistance - 5
    else
        tpDistance = 1
    end
    updateDistanceUI()
end)

plusBtn.MouseButton1Click:Connect(function()
    if tpDistance == 1 then
        tpDistance = 5
    else
        tpDistance = math.min(100, tpDistance + 5)
    end
    updateDistanceUI()
end)

-- Danh sách người chơi
local scrollingFrame = Instance.new("ScrollingFrame")
scrollingFrame.Size = UDim2.new(1, -10, 1, -260)
scrollingFrame.Position = UDim2.new(0, 5, 0, 220)
scrollingFrame.BackgroundTransparency = 1
scrollingFrame.ScrollBarThickness = 4
scrollingFrame.Parent = mainFrame

local layout = Instance.new("UIListLayout")
layout.Parent = scrollingFrame
layout.Padding = UDim.new(0, 10)

local openBtn = Instance.new("TextButton")
_G.OpenBtn = openBtn
openBtn.Size = UDim2.new(0, 60, 0, 60)
openBtn.Position = UDim2.new(0, 15, 0.5, -30)
openBtn.Text = "GEMINI"
openBtn.BackgroundColor3 = Color3.fromRGB(255, 165, 0)
openBtn.Font = Enum.Font.GothamBold
openBtn.Visible = false
openBtn.Parent = screenGui
Instance.new("UICorner", openBtn).CornerRadius = UDim.new(1, 0)

-- 4. LOGIC DANH SÁCH & SỰ KIỆN
local function updateList()
    for _, child in pairs(scrollingFrame:GetChildren()) do if child:IsA("TextButton") then child:Destroy() end end
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= player then
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, -10, 0, 60)
            btn.BackgroundColor3 = (selectedPlayer == p) and Color3.fromRGB(255, 165, 0) or Color3.fromRGB(40, 40, 40)
            btn.Text = ""
            btn.Parent = scrollingFrame
            Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 10)
            
            local dName = Instance.new("TextLabel")
            dName.Size = UDim2.new(1, -15, 0, 30)
            dName.Position = UDim2.new(0, 12, 0, 5)
            dName.Text = p.DisplayName
            dName.TextColor3 = Color3.new(1, 1, 1)
            dName.Font = Enum.Font.GothamBold
            dName.TextSize = 16
            dName.BackgroundTransparency = 1
            dName.TextXAlignment = Enum.TextXAlignment.Left
            dName.Parent = btn

            local uName = Instance.new("TextLabel")
            uName.Size = UDim2.new(1, -15, 0, 20)
            uName.Position = UDim2.new(0, 12, 0, 32)
            uName.Text = "@" .. p.Name
            uName.TextColor3 = (selectedPlayer == p) and Color3.new(0.1, 0.1, 0.1) or Color3.new(0.6, 0.6, 0.6)
            uName.Font = Enum.Font.Gotham
            uName.TextSize = 12
            uName.BackgroundTransparency = 1
            uName.TextXAlignment = Enum.TextXAlignment.Left
            uName.Parent = btn

            btn.MouseButton1Click:Connect(function()
                if selectedPlayer == p then
                    stopSpam()
                    safeTeleport(p)
                    toggleGui(false)
                else
                    selectedPlayer = p
                    if isSpamming then stopSpam() end
                    if isSpectating then camera.CameraSubject = p.Character.Humanoid end
                    updateList()
                end
            end)
        end
    end
end

closeBtn.MouseButton1Click:Connect(function() toggleGui(false) end)
openBtn.MouseButton1Click:Connect(function() toggleGui(true) end)

spectateBtn.MouseButton1Click:Connect(function()
    if not selectedPlayer then return end
    isSpectating = not isSpectating
    if isSpectating then
        camera.CameraSubject = selectedPlayer.Character.Humanoid
        spectateBtn.Text = "XEM: " .. selectedPlayer.DisplayName:upper()
        spectateBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 0)
    else
        spectateBtn.Text = stopSpectating()
        spectateBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    end
end)

spamBtn.MouseButton1Click:Connect(function()
    if not selectedPlayer then return end
    isSpamming = not isSpamming
    spamBtn.Text = isSpamming and "SPAM TP (G): ĐANG BẬT" or "SPAM TP (G): TẮT"
    spamBtn.BackgroundColor3 = isSpamming and Color3.fromRGB(0, 180, 0) or Color3.fromRGB(50, 50, 50)
end)

UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    if input.KeyCode == Enum.KeyCode.K then toggleGui(not mainFrame.Visible)
    elseif input.KeyCode == Enum.KeyCode.F and selectedPlayer then stopSpam() safeTeleport(selectedPlayer) toggleGui(false)
    elseif input.KeyCode == Enum.KeyCode.G and selectedPlayer then
        isSpamming = not isSpamming
        spamBtn.Text = isSpamming and "SPAM TP (G): ĐANG BẬT" or "SPAM TP (G): TẮT"
        spamBtn.BackgroundColor3 = isSpamming and Color3.fromRGB(0, 180, 0) or Color3.fromRGB(50, 50, 50)
    end
end)

Players.PlayerAdded:Connect(updateList)
Players.PlayerRemoving:Connect(function(p) if selectedPlayer == p then selectedPlayer = nil stopSpam() stopSpectating() end updateList() end)
updateList()
