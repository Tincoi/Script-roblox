--[[ 
    TELEPORT GUI ULTIMATE V6 (STEPPED DISTANCE & AUTO-STOP ON DEATH)
    - Keybind G: Spam TP (Tự tắt khi mục tiêu chết hoặc thoát).
    - Slider: Chỉnh khoảng cách theo bậc (0, 10, 20... 100 studs).
    - Keybind F: TP 1 lần & Ẩn GUI.
    - Chữ lớn, dễ nhìn cho Mobile & PC.
]]

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

if CoreGui:FindFirstChild("TeleportGuiSystem") then
    CoreGui:FindFirstChild("TeleportGuiSystem"):Destroy()
end

local selectedPlayer = nil
local isSpectating = false
local isSpamming = false
local tpDistance = 0 -- Mặc định sát lưng

-- 1. HÀM HỆ THỐNG
local function stopSpectating()
    isSpectating = false
    camera.CameraSubject = player.Character:FindFirstChild("Humanoid")
    return "XEM: TẮT"
end

local function toggleGui(forceState)
    _G.MainFrame.Visible = forceState
    _G.OpenBtn.Visible = not forceState
end

local function stopSpamLogic()
    isSpamming = false
    _G.SpamBtn.Text = "SPAM TP (G): TẮT"
    _G.SpamBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
end

local function teleportAction(target)
    if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
        -- KIỂM TRA NẾU ĐỐI PHƯƠNG CHẾT THÌ DỪNG SPAM
        local hum = target.Character:FindFirstChild("Humanoid")
        if hum and hum.Health <= 0 then
            stopSpamLogic()
            return
        end
        
        local char = player.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            char.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, tpDistance)
        end
    end
end

-- Vòng lặp Spam
RunService.RenderStepped:Connect(function()
    if isSpamming and selectedPlayer then
        teleportAction(selectedPlayer)
    end
end)

-- 2. GIAO DIỆN
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "TeleportGuiSystem"
screenGui.Parent = CoreGui
screenGui.ResetOnSpawn = false

local mainFrame = Instance.new("Frame")
_G.MainFrame = mainFrame
mainFrame.Size = UDim2.new(0, 260, 0, 480)
mainFrame.Position = UDim2.new(0.5, -130, 0.3, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true 
mainFrame.Parent = screenGui
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 10)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 50)
title.Text = "TP MENU (F/G)"
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
closeBtn.TextSize = 18
closeBtn.Parent = mainFrame
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 6)

local spectateBtn = Instance.new("TextButton")
spectateBtn.Size = UDim2.new(1, -20, 0, 35)
spectateBtn.Position = UDim2.new(0, 10, 0, 60)
spectateBtn.Text = "XEM: TẮT"
spectateBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
spectateBtn.TextColor3 = Color3.new(1, 1, 1)
spectateBtn.Font = Enum.Font.GothamBold
spectateBtn.TextSize = 14
spectateBtn.Parent = mainFrame
Instance.new("UICorner", spectateBtn).CornerRadius = UDim.new(0, 6)

local spamBtn = Instance.new("TextButton")
_G.SpamBtn = spamBtn
spamBtn.Size = UDim2.new(1, -20, 0, 35)
spamBtn.Position = UDim2.new(0, 10, 0, 100)
spamBtn.Text = "SPAM TP (G): TẮT"
spamBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
spamBtn.TextColor3 = Color3.new(1, 1, 1)
spamBtn.Font = Enum.Font.GothamBold
spamBtn.TextSize = 14
spamBtn.Parent = mainFrame
Instance.new("UICorner", spamBtn).CornerRadius = UDim.new(0, 6)

-- Slider bậc (Distance Stepped)
local distLabel = Instance.new("TextLabel")
distLabel.Size = UDim2.new(1, -20, 0, 20)
distLabel.Position = UDim2.new(0, 10, 0, 140)
distLabel.Text = "Khoảng cách: " .. tpDistance .. " studs"
distLabel.TextColor3 = Color3.new(0.8, 0.8, 0.8)
distLabel.BackgroundTransparency = 1
distLabel.TextSize = 14
distLabel.Parent = mainFrame

local distBtn = Instance.new("TextButton")
distBtn.Size = UDim2.new(1, -20, 0, 12)
distBtn.Position = UDim2.new(0, 10, 0, 165)
distBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
distBtn.Text = ""
distBtn.Parent = mainFrame
Instance.new("UICorner", distBtn).CornerRadius = UDim.new(0, 4)

local sliderFrame = Instance.new("Frame")
sliderFrame.Size = UDim2.new(0, 0, 1, 0)
sliderFrame.BackgroundColor3 = Color3.fromRGB(255, 165, 0)
sliderFrame.Parent = distBtn
Instance.new("UICorner", sliderFrame).CornerRadius = UDim.new(0, 4)

-- 3. XỬ LÝ SỰ KIỆN
local function toggleSpam()
    if not selectedPlayer then return end
    isSpamming = not isSpamming
    if isSpamming then
        spamBtn.Text = "SPAM TP (G): ĐANG BẬT"
        spamBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
    else
        stopSpamLogic()
    end
end

-- Slider theo bậc (0, 10, 20... 100)
distBtn.MouseButton1Click:Connect(function()
    local mousePos = UserInputService:GetMouseLocation().X
    local btnPos = distBtn.AbsolutePosition.X
    local btnWidth = distBtn.AbsoluteSize.X
    local percent = math.clamp((mousePos - btnPos) / btnWidth, 0, 1)
    
    -- Chia bậc mỗi 10 studs, tối đa 100 studs
    local step = math.floor(percent * 10) 
    tpDistance = step * 10
    
    sliderFrame.Size = UDim2.new(step / 10, 0, 1, 0)
    distLabel.Text = "Khoảng cách: " .. tpDistance .. " studs"
end)

local scrollingFrame = Instance.new("ScrollingFrame")
scrollingFrame.Size = UDim2.new(1, -10, 1, -230)
scrollingFrame.Position = UDim2.new(0, 5, 0, 185)
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
openBtn.Visible = false
openBtn.Parent = screenGui
Instance.new("UICorner", openBtn).CornerRadius = UDim.new(1, 0)

local function updateList()
    for _, child in pairs(scrollingFrame:GetChildren()) do if child:IsA("TextButton") then child:Destroy() end end
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
                    stopSpamLogic()
                    teleportAction(p)
                    toggleGui(false)
                else
                    selectedPlayer = p
                    if isSpamming then stopSpamLogic() end
                    if isSpectating then camera.CameraSubject = p.Character.Humanoid end
                    updateList()
                end
            end)
        end
    end
end

closeBtn.MouseButton1Click:Connect(function() toggleGui(false) end)
openBtn.MouseButton1Click:Connect(function() toggleGui(true) end)
spamBtn.MouseButton1Click:Connect(toggleSpam)

spectateBtn.MouseButton1Click:Connect(function()
    if not selectedPlayer then return end
    isSpectating = not isSpectating
    spectateBtn.Text = isSpectating and ("XEM: " .. selectedPlayer.DisplayName:upper()) or stopSpectating()
    spectateBtn.BackgroundColor3 = isSpectating and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(60, 60, 60)
end)

UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    if input.KeyCode == Enum.KeyCode.K then toggleGui(not mainFrame.Visible)
    elseif input.KeyCode == Enum.KeyCode.F and selectedPlayer then 
        stopSpamLogic()
        teleportAction(selectedPlayer)
        toggleGui(false)
    elseif input.KeyCode == Enum.KeyCode.G then toggleSpam() end
end)

Players.PlayerAdded:Connect(updateList)
Players.PlayerRemoving:Connect(function(p) if selectedPlayer == p then selectedPlayer = nil stopSpamLogic() stopSpectating() end updateList() end)
updateList()
